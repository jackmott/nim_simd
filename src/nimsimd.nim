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


proc replaceSIMD(node:NimNode, simdType:string, vectorSize:string) =           
    var simdIdent = toNimIdent("simd")
    var simdTypeIdent = toNimIdent(simdType)
    for node in node.children:
        #echo $node.kind
        if node.kind == nnkIdent:
           #echo $node.ident
           if node.ident == simdIdent:
                node.ident = simdTypeIdent
                break  #only want to check for ident simd on first ident
        replaceSIMD(node,simdType,vectorsize)

macro SIMD_AVX2(body:untyped): untyped =            
    replaceSIMD(body,"avx2","256")
    body

macro SIMD_SSE2(body:untyped): untyped =            
    replaceSIMD(body,"sse2","128")
    body


# width will be replaced with the width of the SIMD vector in bytes
template SIMD*(body:untyped) =
                    
    if cpuType == UNINITIALIZED:
        cpuType = getCPUType()
        echo "Detected cpu type:" & $cpuType        
             
    # instead of calling different macros, is there a way to pass the string?
    # I tried this and got odd compile errors
    if cpuType == SSE2:    
        SIMD_SSE2(body)
    elif cpuType == AVX2:        
        SIMD_AVX2(body)

