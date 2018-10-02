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

Some sample benchmarking scripts which can be modified to suit preferences and needs are included in `benchmarks/`. 


## Simple ops

After activating, instantiating, and compiling the project, the simple ops benchmark can be run with

```julia
julia> include("benchmarks/simpleopsbenchmark.jl")
```

This benchmark compares element-wise array multiplication between single- and double-precision arrays of the same 
size, and a broadcasted multiplication between two arrays of different size.


## FFTs

After activating, instantiating, and compiling the project, the FFT benchmark can be run with

```julia
julia> include("benchmarks/fftbenchmark.jl")
```

This benchmark tests 2-dimensional FFTs of complex single- and double-precision arrays of various sizes.

## FFTs

After activating, instantiating, and compiling the project, the 'twodturb' benchmark can be run with

```julia
julia> include("benchmarks/twodturbbenchmark.jl")
```

This benchmark tests the solution of the barotropic vorticity equation on a doubly-periodic domain using
a pseudospectral method and Forward Euler time-stepping.

# Results in one particular case

I have a 8 core linux desktop that runs Ubuntu with Intel(R) Xeon(R) CPU E5-2609 v2 @ 2.50GHz processors
and 64 GB of memory. My GPU is an [NVIDIA Quadro P6000]() with 24 GB of memory and 3840 cores.

## Simple ops

The results of 

```julia
julia> include("benchmark/simpleopsbenchmark.jl")
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
julia> include("benchmarks/fftbenchmark.jl")
```

are

```shell
Testing CPU Float64 complex fft speed...
64... 128... 256... 512... 1024... 2048... 4096... 8192... 
Testing GPU Float64 complex fft speed...
64... 128... 256... 512... 1024... 2048... 4096... 8192... done.

*** complex 2d Float64 fft results (8 cpu threads, 50 loops) ***

 machine | n:       64 |       128 |       256 |       512 |      1024 |      2048 |      4096 |      8192 | 
-------------------------------------------------------------------------------
     CPU |     0.00332 |   0.00959 |   0.02663 |   0.10918 |   0.66981 |   3.25993 |  14.76250 |  66.91702 | 
     GPU |     0.00229 |   0.00331 |   0.00367 |   0.00264 |   0.00503 |   0.06236 |   1.73771 |   8.86702 | 
   ratio |     1.44593 |   2.90037 |   7.25765 |  41.42443 |  133.20224 |  52.27636 |   8.49536 |   7.54673 | 


Testing CPU Float64 complex fft speed...
16... 32... 64... 128... 256... 
Testing GPU Float64 complex fft speed...
16... 32... 64... 128... 256... done.

*** complex 3d Float64 fft results (8 cpu threads, 50 loops) ***

 machine | n:       16 |        32 |        64 |       128 |       256 | 
-------------------------------------------------------------------------------
     CPU |     0.00270 |   0.01335 |   0.10222 |   1.15505 |  11.52794 | 
     GPU |     0.00293 |   0.00331 |   0.00353 |   0.00503 |   1.59870 | 
   ratio |     0.91884 |   4.03436 |  28.96920 |  229.75366 |   7.21083 | 
```

## Twodturb

The results of

```julia
julia> include("benchmarks/twodturbbenchmark.jl")
```

are

```shell
100 steps of Float32 twodturb with n=   64^2. CPU:   0.0141 s, GPU:   0.0236, ratio:  0.60
100 steps of Float32 twodturb with n=  128^2. CPU:   0.0388 s, GPU:   0.0251, ratio:  1.55
100 steps of Float32 twodturb with n=  256^2. CPU:   0.1264 s, GPU:   0.0295, ratio:  4.29
100 steps of Float32 twodturb with n=  512^2. CPU:   0.4705 s, GPU:   0.0811, ratio:  5.80
100 steps of Float32 twodturb with n= 1024^2. CPU:   2.3159 s, GPU:   0.3208, ratio:  7.22
100 steps of Float32 twodturb with n= 2048^2. CPU:  19.4742 s, GPU:   1.6268, ratio:  11.97
100 steps of Float32 twodturb with n= 4096^2. CPU:  54.5162 s, GPU:   8.0080, ratio:  6.81
 
100 steps of Float64 twodturb with n=   64^2. CPU:   0.0157 s, GPU:   0.0252, ratio:  0.62
100 steps of Float64 twodturb with n=  128^2. CPU:   0.0401 s, GPU:   0.0255, ratio:  1.57
100 steps of Float64 twodturb with n=  256^2. CPU:   0.1451 s, GPU:   0.0311, ratio:  4.66
100 steps of Float64 twodturb with n=  512^2. CPU:   0.6787 s, GPU:   0.1092, ratio:  6.21
100 steps of Float64 twodturb with n= 1024^2. CPU:   3.2180 s, GPU:   0.4564, ratio:  7.05
100 steps of Float64 twodturb with n= 2048^2. CPU:  25.2678 s, GPU:   2.1854, ratio:  11.56
100 steps of Float64 twodturb with n= 4096^2. CPU:  77.2774 s, GPU:  10.2066, ratio:  7.57
```

[NVIDIA Quadro P6000]: https://images.nvidia.com/content/pdf/quadro/data-sheets/192152-NV-DS-Quadro-P6000-US-12Sept-NV-FNL-WEB.pdf
