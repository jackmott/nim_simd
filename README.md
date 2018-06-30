# nim_simd

This is an experiment / proof of concept to use Nim's metaprogramming to provide an easy to use SIMD abstraction layer. 
The goal is for users of the library to be able to write blocks of code containing SIMD intrinsics *one time* and end up with optimum
or near optimum SIMD instructions being used at runtime according to the users hardware. If you are interested in this, you may be interesting in my other Rust library, which is a more complete version of the same idea: [SIMDeez](https://github.com/jackmott/simdeez)

How this will work:

* The user will write a block of code containing SIMD intrinsics using the `simd:` macro
* At *compile time* the macro will produce all desired simd versions of the block.  sse, sse2, avx, and so on
* At *run time* the simd instructions available on the computer will be detected, and the appropriate version of the code block will be executed

# Progress So Far:

See simd.nim for the proof of concept so far.  Already you can write code like this successfully:

```nim
var
    a = newSeq[float32](12)
    b = newSeq[float32](12)
    r = newSeq[float32](12)

for i,v in a:
    a[i] = float32(i)
    b[i] = 2.0'f32


SIMD:     
    for i in countup(0,<a.len,simd.width div 4):
        let av = simd.loadu_ps(addr a[i])
        let bv = simd.loadu_ps(addr b[i])
        let rv = simd.add_ps(av,bv)
        simd.storeu_ps(addr r[i],rv)

echo a
echo b
echo r

```

# Goals / Todo

* Newer SIMD instruction sets include functions with no counterpart in older instruction sets.  Optimally performing fallbacks will need to be crafted for each case. For instance
a call to a blend instruction on SSE2 would need to be converted to  Or(AndNot(z,x), And(z,y)).  In some cases fallbacks may be degenerate or impossible. Compiler warnings? Errors?
* The ability to loop over arrays of a given type should be made as simple as possible. We should provide some abstraction via the macro such that you can do something like `for i,v in myArray` and
it will convert to iterate over the array at the appropriate stride length. Perhaps doing the loads automatically.  But I would like to give the user as much control as possible for performance.
* Runtime cost needs to be kept very near 0. The whole point of SIMD is to extract as much performance as possible from the hardware

# Help Needed

I would love help with this, I am slowly learning Nim meta programming, so anyone who can help with that aspect, or who can help with SIMD issues would be appreciated. Feel free to jump in.
