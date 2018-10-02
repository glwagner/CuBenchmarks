# CuBenchmarks

Somewhat haphazard benchmarks that compare CPU to GPU performance via CuArrays.jl.

This code provides benchmarks for three tasks: 'simple' element-wise array multiplication, FFTs, and
a simple psueodspectral solver for the barotropic vorticity equation. Using this code requires an NVIDIA
GPU, CUDA, and Julia 0.7 or 1.0 with CuArrays linked to CUDA and the GPU device.

Download the code with 

```shell 
git clone https://github.com/glwagner/CuSpeedTests.git
```

To use the project's environment, move into the code directory, start Julia, and press `]` to use Julia's
package manager interactively. Then type

```julia
pkg> activate .
pkg> instantiate
pkg> precompile
```

Some sample benchmarks which can be modified to suit preferences and needs are included in `scripts/`. 


## Simple ops

After activating, instantiating, and compiling the project, the simple ops benchmark can be run with

```julia
julia> include("scripts/speedtest_simpleops.jl")
```

This benchmark compares element-wise array multiplication between single- and double-precision arrays of the same 
size, and a broadcasted multiplication between two arrays of different size.


## FFTs

After activating, instantiating, and compiling the project, the FFT benchmark can be run with

```julia
julia> include("scripts/speedtest_fft.jl")
```

This benchmark tests 2-dimensional FFTs of complex single- and double-precision arrays of various sizes.

## FFTs

After activating, instantiating, and compiling the project, the 'twodturb' benchmark can be run with

```julia
julia> include("scripts/speedtest_twodturb.jl")
```

This benchmark tests the solution of the barotropic vorticity equation on a doubly-periodic domain using
a pseudospectral method and Forward Euler time-stepping.

# Results in one particular case

I have a 8 core linux desktop that runs Ubuntu with Intel(R) Xeon(R) CPU E5-2609 v2 @ 2.50GHz processors
and 64 GB of memory. My GPU is an [NVIDIA Quadro P6000]() with 24 GB of memory and 3840 cores.

## Simple ops

The results of 

```julia
julia> include("scripts/speedtest_simpleops.jl")
```

are

```shell
*** CPU/GPU speed comparison for simple operations on arrays of Float32 ***

N:    64^2, cpu mult: 0.0014, cpu broadcasted mult: 0.0013
            gpu mult: 0.0101, gpu broadcasted mult: 0.0101
               ratio: 0.14  ,                ratio: 0.13  
N:   128^2, cpu mult: 0.0058, cpu broadcasted mult: 0.0044
            gpu mult: 0.0100, gpu broadcasted mult: 0.0102
               ratio: 0.58  ,                ratio: 0.44  
N:   256^2, cpu mult: 0.0357, cpu broadcasted mult: 0.0261
            gpu mult: 0.0103, gpu broadcasted mult: 0.0104
               ratio: 3.46  ,                ratio: 2.52  
N:   512^2, cpu mult: 0.1388, cpu broadcasted mult: 0.1012
            gpu mult: 0.0108, gpu broadcasted mult: 0.0108
               ratio: 12.89 ,                ratio: 9.39  
N:  1024^2, cpu mult: 1.3515, cpu broadcasted mult: 0.5379
            gpu mult: 0.0125, gpu broadcasted mult: 0.0126
               ratio: 108.16,                ratio: 42.85 
N:  2048^2, cpu mult: 6.6590, cpu broadcasted mult: 4.7654
            gpu mult: 0.0127, gpu broadcasted mult: 0.0129
               ratio: 523.32,                ratio: 370.43

*** CPU/GPU speed comparison for simple operations on arrays of Float64 ***

N:    64^2, cpu mult: 0.0029, cpu broadcasted mult: 0.0023
            gpu mult: 0.0102, gpu broadcasted mult: 0.0102
               ratio: 0.28  ,                ratio: 0.22  
N:   128^2, cpu mult: 0.0174, cpu broadcasted mult: 0.0101
            gpu mult: 0.0103, gpu broadcasted mult: 0.0102
               ratio: 1.69  ,                ratio: 1.00  
N:   256^2, cpu mult: 0.0695, cpu broadcasted mult: 0.0518
            gpu mult: 0.0104, gpu broadcasted mult: 0.0107
               ratio: 6.69  ,                ratio: 4.84  
N:   512^2, cpu mult: 0.2775, cpu broadcasted mult: 0.2032
            gpu mult: 0.0124, gpu broadcasted mult: 0.0115
               ratio: 22.41 ,                ratio: 17.64 
N:  1024^2, cpu mult: 3.6468, cpu broadcasted mult: 2.3000
            gpu mult: 0.0125, gpu broadcasted mult: 0.0126
               ratio: 291.95,                ratio: 182.23
N:  2048^2, cpu mult: 14.2797, cpu broadcasted mult: 9.6399
            gpu mult: 0.0127, gpu broadcasted mult: 0.0126
               ratio: 1127.85,                ratio: 764.85
```


## FFTs

The results of 

```julia
julia> include("scripts/speedtest_fft.jl")
```

are

```shell

```



## Twodturb

The results of

```julia
julia> include("scripts/speedtest_twodturb.jl")
```

are

```shell
n=64, CPU  15.667 ms (905 allocations: 51.77 KiB)
n=64, GPU  26.060 ms (29852 allocations: 1.49 MiB)
 
n=128, CPU  40.197 ms (905 allocations: 51.77 KiB)
n=128, GPU  26.197 ms (29852 allocations: 1.49 MiB)
 
n=256, CPU  144.524 ms (905 allocations: 51.77 KiB)
n=256, GPU  31.060 ms (29852 allocations: 1.49 MiB)
 
n=512, CPU  672.587 ms (905 allocations: 51.77 KiB)
n=512, GPU  109.104 ms (29852 allocations: 1.49 MiB)
 
n=1024, CPU  3.645 s (905 allocations: 51.77 KiB)
n=1024, GPU  458.940 ms (29852 allocations: 1.49 MiB)

n=2048, CPU  27.729 s (905 allocations: 51.77 KiB)
n=2048, GPU  2.140 s (29852 allocations: 1.49 MiB)
```

[NVIDIA Quadro P6000]: https://images.nvidia.com/content/pdf/quadro/data-sheets/192152-NV-DS-Quadro-P6000-US-12Sept-NV-FNL-WEB.pdf
