import nimsimd/mmx
import nimsimd/avx
import nimsimd/sse
import nimsimd/avx2
import nimsimd/sse2
import macros 
import rdstdin

proc cpuidex(cpuInfo:ptr int,function_id:cint,subfunction_id:cint)
    {.importc:"__cpuidex", header:"intrin.h"}

proc cpuid_count(level,count,a,b,c,d:cint)
    {.importc:"__cpuid_count", header:"cpuid.h"}

proc c_xgetbv(xcr:cuint) : uint64
    {.importc:"_xgetbv", header:"immintrin.h"}


when defined(Windows):
    proc cpuid(outarray:openarray[int32],x:int32) =
        cpuidex(cast[ptr int32](outarray[0].unsafeAddr),x.cint,0)

    proc xgetbv(x:uint) : uint64 =
        c_xgetbv(x.cuint)
else:
    proc cpuid*(outarray:openarray[int32],x:int32) =
        cpuid_count(x.cint,0,outarray[0].cint,outarray[1].cint,outarray[2].cint,outarray[3].cint)

    proc xgetbv(index:uint) : uint64 = 
        {.emit:"""
        unsigned eax, edx;
        __asm__ __volatile__("xgetbv" : "=a"(eax), "=d"(edx) : "c"(index));
        return ((unsigned long)edx << 32) | eax;
        """.}

const XCR_FEATURE_ENABLED_MASK = 0        

type CPU_TYPE = enum
        UNINITIALIZED,NO_SIMD,SSE2,SSE41,AVX2,AVX512,NEON

var cpuType = UNINITIALIZED

proc getCPUType() : CPU_TYPE =
    var cpuInfo = newSeq[int32](4)
    cpuid(cpuInfo,0)
    let nIds = cpuInfo[0]

    if nIds < 0x00000001:
        return NO_SIMD
    
    cpuid(cpuInfo,0x00000001)

    if (cpuInfo[3] and 1 shl 26) == 0:
        return NO_SIMD

    if (cpuInfo[2] and 1 shl 19) == 0:
        return SSE2

    var cpuXSaveSupport = (cpuInfo[2] and 1 shl 26) != 0
    var osAVXSupport = (cpuInfo[2] and 1 shl 27) != 0
    var cpuAVXSupport = (cpuInfo[2] and 1 shl 28) != 0

    if cpuXSaveSupport and osAVXSupport and cpuAVXSupport:
        var xcrFeatureMask = xgetbv(XCR_FEATURE_ENABLED_MASK)
        if (xcrFeatureMask and 0x6) != 0x6:
            return SSE41
    else:
        return SSE41

    if nIds < 0x00000007:
        return SSE41

    var cpuFMA3Support = (cpuInfo[2] and 1 shl 12) != 0    
    cpuid(cpuInfo,0x00000007)
    var cpuAVX2Support = (cpuInfo[1] and 1 shl 5) != 0

    if not cpuFMA3Support or not cpuAVX2Support:
        return SSE41

    var cpuAVX512Support = (cpuInfo[1] and 1 shl 16) != 0
    var oxAVX512Support = (xgetbv(XCR_FEATURE_ENABLED_MASK) and 0xe6) == 0xe6

    if not cpuAVX512Support or not oxAVX512Support:
        return AVX2
    return AVX512

type vector = void


proc replaceSIMD(node:NimNode, simdType:string, vectorSize:string) =            
    for node in node.children:
        #echo $node.kind
        if node.kind == nnkIdent:
           #echo $node.ident
           if node.ident == !"simd":
                node.ident = !simdType
                break  #only want to check for ident simd on first ident
        replaceSIMD(node,simdType,vectorsize)

macro SIMD_AVX2(body:untyped): untyped =            
    replaceSIMD(body,"avx2","256")
    body

macro SIMD_SSE2(body:untyped): untyped =            
    replaceSIMD(body,"sse2","128")
    body


# width will be replaced with the width of the SIMD vector in bytes
template SIMD(lane_width_bytes:untyped,body:untyped) =
                    
    if cpuType == UNINITIALIZED:
        cpuType = getCPUType()
        echo "Detected cpu type:" & $cpuType        
         

    var lane_width_bytes:int
    # instead of calling different macros, is there a way to pass the string?
    # I tried this and got odd compile errors
    if cpuType == SSE2:
        lane_width_bytes = 16        
        SIMD_SSE2(body)
    elif cpuType == AVX2:
        lane_width_bytes = 32
        SIMD_AVX2(body)


when isMainModule:         
    SIMD(w2):
        let F3 = simd.set1_ps(1.0'f32/3.0'f32)    
        let G3 = simd.set1_ps(1.0'f32 / 6.0'f32)
        let G32 = simd.set1_ps((1.0'f32 / 6.0'f32) * 2.0'f32)
        let G33 = simd.set1_ps((1.0'f32 / 6.0'f32) * 3.0'f32)
        let ONE = simd.set1_epi32(1)
        proc simplexNoise(x,y,z: simd.mf32) : simd.mf32 = 
            let s = simd.mul_ps(F3,simd.add_ps(x,simd.add_ps(y,z)))
            let i = simd.floor_ps_epi32(simd.add_ps(x,s))
            let j = simd.floor_ps_epi32(simd.add_ps(y,s))
            let k = simd.floor_ps_epi32(simd.add_ps(z,s))
         
            let t = simd.mul_ps(simd.cvtepi32_ps(simd.add_epi32(i,simd.add_epi32(j,k))),G3)
            let X0 = simd.sub_ps(simd.cvtepi32_ps(i),t)
            let Y0 = simd.sub_ps(simd.cvtepi32_ps(j),t)
            let Z0 = simd.sub_ps(simd.cvtepi32_ps(k),t)
            let x0 = simd.sub_ps(x,X0)
            let y0 = simd.sub_ps(y,Y0)
            let z0 = simd.sub_ps(z,Z0) 

            let i1 = simd.and_si(ONE,simd.and_si(simd.castps_si(simd.cmpge_ps(x0,y0)),simd.castps_si(simd.cmpge_ps(x0,z0))))
            let j1 = simd.and_si(ONE,simd.and_si(simd.castps_si(simd.cmpgt_ps(y0,x0)),simd.castps_si(simd.cmpgt_ps(y0,z0))))
            let k1 = simd.and_si(ONE,simd.and_si(simd.castps_si(simd.cmpgt_ps(z0,x0)),simd.castps_si(simd.cmpgt_ps(z0,y0))))

            let yx_xz = simd.and_si(simd.castps_si(simd.cmpge_ps(x0,y0)),simd.castps_si(simd.cmplt_ps(x0,z0)))
            let zx_xy = simd.and_si(simd.castps_si(simd.cmpge_ps(x0,z0)),simd.castps_si(simd.cmplt_ps(x0,y0)))
            

          


        

    var
        a = newSeq[float32](16)
        b = newSeq[float32](16) 
        r = newSeq[float32](16)

    for i,v in a:
        a[i] = float32(i)
        b[i] = 2.0'f32
    
        

    SIMD(width):     
        echo "SIMD lane width in bytes:" & $width    
        for i in countup(0,<a.len,width div 4):
            let av = simd.loadu_ps(addr a[i])
            let bv = simd.loadu_ps(addr b[i])
            let rv = simd.add_ps(av,bv)
            simd.storeu_ps(addr r[i],rv)

    echo a
    echo b
    echo r

    
    


#avx.add =
#StmtList
#  Call
#    DotExpr
#      Ident !"avx"
#      Ident !"add"
#    IntLit 1
#    IntLit 2


#add =
#StmtList
#  Call
#    Ident !"add"
#    IntLit 1
#    IntLit 2
