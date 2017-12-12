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
    var perm = [        
        151'i32,160'i32,137'i32,91'i32,90'i32,15'i32,
        131'i32,13'i32,201'i32,95'i32,96'i32,53'i32,194'i32,233'i32,7'i32,225'i32,140'i32,36'i32,103'i32,30'i32,69'i32,142'i32,8'i32,99'i32,37'i32,240'i32,21'i32,10'i32,23'i32,
        190'i32, 6'i32,148'i32,247'i32,120'i32,234'i32,75'i32,0'i32,26'i32,197'i32,62'i32,94'i32,252'i32,219'i32,203'i32,117'i32,35'i32,11'i32,32'i32,57'i32,177'i32,33'i32,
        88'i32,237'i32,149'i32,56'i32,87'i32,174'i32,20'i32,125'i32,136'i32,171'i32,168'i32, 68'i32,175'i32,74'i32,165'i32,71'i32,134'i32,139'i32,48'i32,27'i32,166'i32,
        77'i32,146'i32,158'i32,231'i32,83'i32,111'i32,229'i32,122'i32,60'i32,211'i32,133'i32,230'i32,220'i32,105'i32,92'i32,41'i32,55'i32,46'i32,245'i32,40'i32,244'i32,
        102'i32,143'i32,54'i32, 65'i32,25'i32,63'i32,161'i32, 1'i32,216'i32,80'i32,73'i32,209'i32,76'i32,132'i32,187'i32,208'i32, 89'i32,18'i32,169'i32,200'i32,196'i32,
        135'i32,130'i32,116'i32,188'i32,159'i32,86'i32,164'i32,100'i32,109'i32,198'i32,173'i32,186'i32, 3'i32,64'i32,52'i32,217'i32,226'i32,250'i32,124'i32,123'i32,
        5'i32,202'i32,38'i32,147'i32,118'i32,126'i32,255'i32,82'i32,85'i32,212'i32,207'i32,206'i32,59'i32,227'i32,47'i32,16'i32,58'i32,17'i32,182'i32,189'i32,28'i32,42'i32,
        223'i32,183'i32,170'i32,213'i32,119'i32,248'i32,152'i32, 2'i32,44'i32,154'i32,163'i32, 70'i32,221'i32,153'i32,101'i32,155'i32,167'i32, 43'i32,172'i32,9'i32,
        129'i32,22'i32,39'i32,253'i32, 19'i32,98'i32,108'i32,110'i32,79'i32,113'i32,224'i32,232'i32,178'i32,185'i32, 112'i32,104'i32,218'i32,246'i32,97'i32,228'i32,
        251'i32,34'i32,242'i32,193'i32,238'i32,210'i32,144'i32,12'i32,191'i32,179'i32,162'i32,241'i32, 81'i32,51'i32,145'i32,235'i32,249'i32,14'i32,239'i32,107'i32,
        49'i32,192'i32,214'i32, 31'i32,181'i32,199'i32,106'i32,157'i32,184'i32, 84'i32,204'i32,176'i32,115'i32,121'i32,50'i32,45'i32,127'i32, 4'i32,150'i32,254'i32,
        138'i32,236'i32,205'i32,93'i32,222'i32,114'i32,67'i32,29'i32,24'i32,72'i32,243'i32,141'i32,128'i32,195'i32,78'i32,66'i32,215'i32,61'i32,156'i32,180'i32,
        151'i32,160'i32,137'i32,91'i32,90'i32,15'i32,
        131'i32,13'i32,201'i32,95'i32,96'i32,53'i32,194'i32,233'i32,7'i32,225'i32,140'i32,36'i32,103'i32,30'i32,69'i32,142'i32,8'i32,99'i32,37'i32,240'i32,21'i32,10'i32,23'i32,
        190'i32, 6'i32,148'i32,247'i32,120'i32,234'i32,75'i32,0'i32,26'i32,197'i32,62'i32,94'i32,252'i32,219'i32,203'i32,117'i32,35'i32,11'i32,32'i32,57'i32,177'i32,33'i32,
        88'i32,237'i32,149'i32,56'i32,87'i32,174'i32,20'i32,125'i32,136'i32,171'i32,168'i32, 68'i32,175'i32,74'i32,165'i32,71'i32,134'i32,139'i32,48'i32,27'i32,166'i32,
        77'i32,146'i32,158'i32,231'i32,83'i32,111'i32,229'i32,122'i32,60'i32,211'i32,133'i32,230'i32,220'i32,105'i32,92'i32,41'i32,55'i32,46'i32,245'i32,40'i32,244'i32,
        102'i32,143'i32,54'i32, 65'i32,25'i32,63'i32,161'i32, 1'i32,216'i32,80'i32,73'i32,209'i32,76'i32,132'i32,187'i32,208'i32, 89'i32,18'i32,169'i32,200'i32,196'i32,
        135'i32,130'i32,116'i32,188'i32,159'i32,86'i32,164'i32,100'i32,109'i32,198'i32,173'i32,186'i32, 3'i32,64'i32,52'i32,217'i32,226'i32,250'i32,124'i32,123'i32,
        5'i32,202'i32,38'i32,147'i32,118'i32,126'i32,255'i32,82'i32,85'i32,212'i32,207'i32,206'i32,59'i32,227'i32,47'i32,16'i32,58'i32,17'i32,182'i32,189'i32,28'i32,42'i32,
        223'i32,183'i32,170'i32,213'i32,119'i32,248'i32,152'i32, 2'i32,44'i32,154'i32,163'i32, 70'i32,221'i32,153'i32,101'i32,155'i32,167'i32, 43'i32,172'i32,9'i32,
        129'i32,22'i32,39'i32,253'i32, 19'i32,98'i32,108'i32,110'i32,79'i32,113'i32,224'i32,232'i32,178'i32,185'i32, 112'i32,104'i32,218'i32,246'i32,97'i32,228'i32,
        251'i32,34'i32,242'i32,193'i32,238'i32,210'i32,144'i32,12'i32,191'i32,179'i32,162'i32,241'i32, 81'i32,51'i32,145'i32,235'i32,249'i32,14'i32,239'i32,107'i32,
        49'i32,192'i32,214'i32, 31'i32,181'i32,199'i32,106'i32,157'i32,184'i32, 84'i32,204'i32,176'i32,115'i32,121'i32,50'i32,45'i32,127'i32, 4'i32,150'i32,254'i32,
        138'i32,236'i32,205'i32,93'i32,222'i32,114'i32,67'i32,29'i32,24'i32,72'i32,243'i32,141'i32,128'i32,195'i32,78'i32,66'i32,215'i32,61'i32,156'i32,180'i32]

    var permMOD12 = [        
        7'i32, 4'i32, 5'i32, 7'i32, 6'i32, 3'i32, 11'i32, 1'i32, 9'i32, 11'i32, 0'i32, 5'i32, 2'i32, 5'i32, 7'i32, 9'i32, 8'i32, 0'i32, 7'i32, 6'i32, 9'i32, 10'i32, 8'i32, 3'i32,
        1'i32, 0'i32, 9'i32, 10'i32, 11'i32, 10'i32, 6'i32, 4'i32, 7'i32, 0'i32, 6'i32, 3'i32, 0'i32, 2'i32, 5'i32, 2'i32, 10'i32, 0'i32, 3'i32, 11'i32, 9'i32, 11'i32, 11'i32,
        8'i32, 9'i32, 9'i32, 9'i32, 4'i32, 9'i32, 5'i32, 8'i32, 3'i32, 6'i32, 8'i32, 5'i32, 4'i32, 3'i32, 0'i32, 8'i32, 7'i32, 2'i32, 9'i32, 11'i32, 2'i32, 7'i32, 0'i32, 3'i32, 10'i32,
        5'i32, 2'i32, 2'i32, 3'i32, 11'i32, 3'i32, 1'i32, 2'i32, 0'i32, 7'i32, 1'i32, 2'i32, 4'i32, 9'i32, 8'i32, 5'i32, 7'i32, 10'i32, 5'i32, 4'i32, 4'i32, 6'i32, 11'i32, 6'i32,
        5'i32, 1'i32, 3'i32, 5'i32, 1'i32, 0'i32, 8'i32, 1'i32, 5'i32, 4'i32, 0'i32, 7'i32, 4'i32, 5'i32, 6'i32, 1'i32, 8'i32, 4'i32, 3'i32, 10'i32, 8'i32, 8'i32, 3'i32, 2'i32, 8'i32,
        4'i32, 1'i32, 6'i32, 5'i32, 6'i32, 3'i32, 4'i32, 4'i32, 1'i32, 10'i32, 10'i32, 4'i32, 3'i32, 5'i32, 10'i32, 2'i32, 3'i32, 10'i32, 6'i32, 3'i32, 10'i32, 1'i32, 8'i32, 3'i32,
        2'i32, 11'i32, 11'i32, 11'i32, 4'i32, 10'i32, 5'i32, 2'i32, 9'i32, 4'i32, 6'i32, 7'i32, 3'i32, 2'i32, 9'i32, 11'i32, 8'i32, 8'i32, 2'i32, 8'i32, 10'i32, 7'i32, 10'i32, 5'i32,
        9'i32, 5'i32, 11'i32, 11'i32, 7'i32, 4'i32, 9'i32, 9'i32, 10'i32, 3'i32, 1'i32, 7'i32, 2'i32, 0'i32, 2'i32, 7'i32, 5'i32, 8'i32, 4'i32, 10'i32, 5'i32, 4'i32, 8'i32, 2'i32, 6'i32,
        1'i32, 0'i32, 11'i32, 10'i32, 2'i32, 1'i32, 10'i32, 6'i32, 0'i32, 0'i32, 11'i32, 11'i32, 6'i32, 1'i32, 9'i32, 3'i32, 1'i32, 7'i32, 9'i32, 2'i32, 11'i32, 11'i32, 1'i32, 0'i32,
        10'i32, 7'i32, 1'i32, 7'i32, 10'i32, 1'i32, 4'i32, 0'i32, 0'i32, 8'i32, 7'i32, 1'i32, 2'i32, 9'i32, 7'i32, 4'i32, 6'i32, 2'i32, 6'i32, 8'i32, 1'i32, 9'i32, 6'i32, 6'i32, 7'i32, 5'i32,
        0'i32, 0'i32, 3'i32, 9'i32, 8'i32, 3'i32, 6'i32, 6'i32, 11'i32, 1'i32, 0'i32, 0'i32,
        7'i32, 4'i32, 5'i32, 7'i32, 6'i32, 3'i32, 11'i32, 1'i32, 9'i32, 11'i32, 0'i32, 5'i32, 2'i32, 5'i32, 7'i32, 9'i32, 8'i32, 0'i32, 7'i32, 6'i32, 9'i32, 10'i32, 8'i32, 3'i32,
        1'i32, 0'i32, 9'i32, 10'i32, 11'i32, 10'i32, 6'i32, 4'i32, 7'i32, 0'i32, 6'i32, 3'i32, 0'i32, 2'i32, 5'i32, 2'i32, 10'i32, 0'i32, 3'i32, 11'i32, 9'i32, 11'i32, 11'i32,
        8'i32, 9'i32, 9'i32, 9'i32, 4'i32, 9'i32, 5'i32, 8'i32, 3'i32, 6'i32, 8'i32, 5'i32, 4'i32, 3'i32, 0'i32, 8'i32, 7'i32, 2'i32, 9'i32, 11'i32, 2'i32, 7'i32, 0'i32, 3'i32, 10'i32,
        5'i32, 2'i32, 2'i32, 3'i32, 11'i32, 3'i32, 1'i32, 2'i32, 0'i32, 7'i32, 1'i32, 2'i32, 4'i32, 9'i32, 8'i32, 5'i32, 7'i32, 10'i32, 5'i32, 4'i32, 4'i32, 6'i32, 11'i32, 6'i32,
        5'i32, 1'i32, 3'i32, 5'i32, 1'i32, 0'i32, 8'i32, 1'i32, 5'i32, 4'i32, 0'i32, 7'i32, 4'i32, 5'i32, 6'i32, 1'i32, 8'i32, 4'i32, 3'i32, 10'i32, 8'i32, 8'i32, 3'i32, 2'i32, 8'i32,
        4'i32, 1'i32, 6'i32, 5'i32, 6'i32, 3'i32, 4'i32, 4'i32, 1'i32, 10'i32, 10'i32, 4'i32, 3'i32, 5'i32, 10'i32, 2'i32, 3'i32, 10'i32, 6'i32, 3'i32, 10'i32, 1'i32, 8'i32, 3'i32,
        2'i32, 11'i32, 11'i32, 11'i32, 4'i32, 10'i32, 5'i32, 2'i32, 9'i32, 4'i32, 6'i32, 7'i32, 3'i32, 2'i32, 9'i32, 11'i32, 8'i32, 8'i32, 2'i32, 8'i32, 10'i32, 7'i32, 10'i32, 5'i32,
        9'i32, 5'i32, 11'i32, 11'i32, 7'i32, 4'i32, 9'i32, 9'i32, 10'i32, 3'i32, 1'i32, 7'i32, 2'i32, 0'i32, 2'i32, 7'i32, 5'i32, 8'i32, 4'i32, 10'i32, 5'i32, 4'i32, 8'i32, 2'i32, 6'i32,
        1'i32, 0'i32, 11'i32, 10'i32, 2'i32, 1'i32, 10'i32, 6'i32, 0'i32, 0'i32, 11'i32, 11'i32, 6'i32, 1'i32, 9'i32, 3'i32, 1'i32, 7'i32, 9'i32, 2'i32, 11'i32, 11'i32, 1'i32, 0'i32,
        10'i32, 7'i32, 1'i32, 7'i32, 10'i32, 1'i32, 4'i32, 0'i32, 0'i32, 8'i32, 7'i32, 1'i32, 2'i32, 9'i32, 7'i32, 4'i32, 6'i32, 2'i32, 6'i32, 8'i32, 1'i32, 9'i32, 6'i32, 6'i32, 7'i32, 5'i32,
        0'i32, 0'i32, 3'i32, 9'i32, 8'i32, 3'i32, 6'i32, 6'i32, 11'i32, 1'i32, 0'i32, 0'i32
    ]
    
    SIMD(w2):
        let F3 = simd.set1_ps(1.0'f32/3.0'f32)    
        let G3 = simd.set1_ps(1.0'f32 / 6.0'f32)
        let G32 = simd.set1_ps((1.0'f32 / 6.0'f32) * 2.0'f32)
        let G33 = simd.set1_ps((1.0'f32 / 6.0'f32) * 3.0'f32)
        let ONE = simd.set1_epi32(1)
        let FF = simd.set1_epi32(0xff)
        let ONEF = simd.set1_ps(1.0'f32)

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

            let xy_yz = simd.and_si(simd.castps_si(simd.cmplt_ps(x0,y0)),simd.castps_si(simd.cmplt_ps(y0,z0)))
            let zy_yx = simd.and_si(simd.castps_si(simd.cmpge_ps(y0,z0)),simd.castps_si(simd.cmpge_ps(x0,y0)))

            let yz_zx = simd.and_si(simd.castps_si(simd.cmplt_ps(y0,z0)),simd.castps_si(simd.cmpge_ps(x0,z0)))
            let xz_zy = simd.and_si(simd.castps_si(simd.cmplt_ps(x0,z0)),simd.castps_si(simd.cmpge_ps(y0,z0)))

            let i2 = simd.and_si(ONE,simd.or_si(i1,simd.or_si(yx_xz,zx_xy)))
            let j2 = simd.and_si(ONE,simd.or_si(j1,simd.or_si(xy_yz,zy_yx)))
            let k2 = simd.and_si(ONE,simd.or_si(k1,simd.or_si(yz_zx,xz_zy)))

            let x1 = simd.add_ps(simd.sub_ps(x0,simd.cvtepi32_ps(i1)),G3)
            let y1 = simd.add_ps(simd.sub_ps(y0,simd.cvtepi32_ps(j1)),G3)
            let z1 = simd.add_ps(simd.sub_ps(z0,simd.cvtepi32_ps(k1)),G3)
            let x2 = simd.add_ps(simd.sub_ps(x0,simd.cvtepi32_ps(i2)),G32)
            let y2 = simd.add_ps(simd.sub_ps(y0,simd.cvtepi32_ps(j2)),G32)
            let zz = simd.add_ps(simd.sub_ps(z0,simd.cvtepi32_ps(k2)),G32)
            let x3 = simd.add_ps(simd.sub_ps(x0,ONEF),G33)
            let y3 = simd.add_ps(simd.sub_ps(y0,ONEF),G33)
            let z3 = simd.add_ps(simd.sub_ps(z0,ONEF),G33)

            let ii = simd.and_si(i,FF)
            let jj = simd.and_si(j,FF)
            let kk = simd.and_si(k,FF) 
             
            let pkk = simd.i32gather_epi32(perm[0].unsafeAddr,kk,4)
            let pkkk1 = simd.i32gather_epi32(perm[0].unsafeAddr,simd.add_epi32(kk,k1),4)
            let pkkk2 = simd.i32gather_Epi32(perm[0].unsafeAddr,simd.add_epi32(kk,k2),4)
            let pkk1 = simd.i32gather_epi32(perm[0].unsafeAddr,simd.add_epi32(kk,ONE),4)

            let pjj = simd.i32gather_epi32(perm[0].unsafeAddr,simd.add_epi32(jj,pkk),4)
            let pjjj1 = simd.i32gather_epi32(perm[0].unsafeAddr,simd.add_epi32(jj,simd.add_epi32(j1,pkkk1)),4)
            let pjjj2 = simd.i32gather_epi32(perm[0].unsafeAddr,simd.add_epi32(jj,simd.add_epi32(j2,pkkk2)),4)
            let pjj1 = simd.i32gather_epi32(perm[0].unsafeAddr,simd.add_epi32(jj,simd.add_epi32(ONE,pkk1)),4)

            let gi0 = simd.i32gather_epi32(permMOD12[0].unsafeAddr,simd.add_epi32(ii,pjj),4)
            let gi1 = simd.i32gather_epi32(permMOD12[0].unsafeAddr,simd.add_epi32(i1,simd.add_epi32(ii,pjjj1)),4)
            let gi2 = simd.i32gather_epi32(permMOD12[0].unsafeAddr,simd.add_epi32(i2,simd.add_epi32(ii,pjjj2)),4)
            let gi3 = simd.i32gather_epi32(permMOD12[0].unsafeAddr,simd.add_epi32(ONE,simd.add_epi32(ii,pjj1)),4)

            


            let p = simd.set1_ps(1.0'f32)
            return p 

          


        

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
