import avx
import sse
import avx2
import sse2
import macros
import rdstdin

proc replaceSIMD(node:NimNode, simdType:string) =
    for node in node.children:
        echo $node.kind
        if node.kind == nnkIdent:
            echo $node.ident
            if node.ident == !"simd":
                node.ident = !simdType
                break  #only want to check for ident simd on first ident
        replaceSIMD(node,simdType)

macro SIMD_AVX(body:untyped): untyped =            
    replaceSIMD(body,"avx")
    body

macro SIMD_SSE(body:untyped): untyped =            
    replaceSIMD(body,"sse")
    body

# width will be replaced with the width of the SIMD vector in bytes
template SIMD(width:untyped,body:untyped) =
    let str = readLineFromStdin "sse or avx? "    
    var width : int
    # instead of calling different macros, is there a way to pass the string?
    # I tried this and got odd compile errors
    if str == "sse":
        width = 16
        SIMD_SSE(body)
    if str == "avx":
        width = 32
        SIMD_AVX(body)


var
    a = newSeq[float32](12)
    b = newSeq[float32](12)
    r = newSeq[float32](12)

for i,v in a:
    a[i] = float32(i)
    b[i] = 2.0'f32

SIMD(width):    
    var floatWidth = int(width/4)
    for i in countup(0,a.len-1,floatWidth):
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
