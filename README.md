# CuSpeedTests

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
and 64 GB of memory. My CPU is a [Quadro P6000]() with 24 GB of on-device memory and 3840 cores.

## Simple ops

The results of 

```julia
julia> include("scripts/speedtest_simpleops.jl")
```

are

```shell
*** CPU/GPU speed comparison for simple operations on arrays of Float32 ***
N:    64^2, cpu mult: 0.0014, cpu broadcasted mult: 0.0013
            gpu mult: 0.0099, gpu broadcasted mult: 0.0099
N:   128^2, cpu mult: 0.0063, cpu broadcasted mult: 0.0049
            gpu mult: 0.0096, gpu broadcasted mult: 0.0107
N:   256^2, cpu mult: 0.0352, cpu broadcasted mult: 0.0260
            gpu mult: 0.0111, gpu broadcasted mult: 0.0112
N:   512^2, cpu mult: 0.1390, cpu broadcasted mult: 0.1015
            gpu mult: 0.0111, gpu broadcasted mult: 0.0113
N:  1024^2, cpu mult: 1.2929, cpu broadcasted mult: 0.5533
            gpu mult: 0.0133, gpu broadcasted mult: 0.0135
N:  2048^2, cpu mult: 7.4291, cpu broadcasted mult: 4.7246
            gpu mult: 0.0134, gpu broadcasted mult: 0.0136
*** CPU/GPU speed comparison for simple operations on arrays of Float64 ***
N:    64^2, cpu mult: 0.0027, cpu broadcasted mult: 0.0023
            gpu mult: 0.0106, gpu broadcasted mult: 0.0098
N:   128^2, cpu mult: 0.0162, cpu broadcasted mult: 0.0104
            gpu mult: 0.0106, gpu broadcasted mult: 0.0109
N:   256^2, cpu mult: 0.0695, cpu broadcasted mult: 0.0512
            gpu mult: 0.0110, gpu broadcasted mult: 0.0111
N:   512^2, cpu mult: 0.2943, cpu broadcasted mult: 0.2025
            gpu mult: 0.0133, gpu broadcasted mult: 0.0119
N:  1024^2, cpu mult: 3.6762, cpu broadcasted mult: 2.2882
            gpu mult: 0.0135, gpu broadcasted mult: 0.0133
N:  2048^2, cpu mult: 13.1741, cpu broadcasted mult: 6.8731
            gpu mult: 0.0132, gpu broadcasted mult: 0.0134
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

[Quadro P6000]: https://images.nvidia.com/content/pdf/quadro/data-sheets/192152-NV-DS-Quadro-P6000-US-12Sept-NV-FNL-WEB.pdf
