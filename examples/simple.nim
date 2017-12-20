import ../src/nimsimd
import ../src/nimsimd/sse2
import ../src/nimsimd/avx2

var
    a = newSeq[float32](16)            
    b = newSeq[float32](16)
    r = newSeq[float32](16)

for i,v in a:
    a[i] = float32(i)            
    b[i] = float32(i*2)

SIMD:
    echo "SIMD lane width in bytes:" & $simd.width    
    for i in countup(0,<a.len,simd.width div 4):    
        var av = simd.loadu_ps(addr a[i])    
        var bv = simd.loadu_ps(addr b[i])
        var rv = simd.add_ps(av,bv)   
        simd.storeu_ps(addr r[i],rv)

echo "A + B = R"
echo a        
echo b
echo r
