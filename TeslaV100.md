# Timing simple operations

```
julia> include("benchmarks/simpleopsbenchmark.jl")

  *** CPU/GPU speed comparison for simple operations on arrays of Float32 ***

N:    64^2, cpu mult: 0.0001, cpu broadcasted mult: 0.0001
            gpu mult: 0.0005, gpu broadcasted mult: 0.0005
               ratio: 0.15  ,                ratio: 0.11  
N:   128^2, cpu mult: 0.0002, cpu broadcasted mult: 0.0002
            gpu mult: 0.0005, gpu broadcasted mult: 0.0005
               ratio: 0.44  ,                ratio: 0.40  
N:   256^2, cpu mult: 0.0012, cpu broadcasted mult: 0.0011
            gpu mult: 0.0005, gpu broadcasted mult: 0.0005
               ratio: 2.56  ,                ratio: 2.05  
N:   512^2, cpu mult: 0.0084, cpu broadcasted mult: 0.0063
            gpu mult: 0.0005, gpu broadcasted mult: 0.0005
               ratio: 15.93 ,                ratio: 12.07 
N:  1024^2, cpu mult: 0.0508, cpu broadcasted mult: 0.0286
            gpu mult: 0.0020, gpu broadcasted mult: 0.0016
               ratio: 25.98 ,                ratio: 17.74 
N:  2048^2, cpu mult: 0.3399, cpu broadcasted mult: 0.2052
            gpu mult: 0.0066, gpu broadcasted mult: 0.0054
               ratio: 51.28 ,                ratio: 38.11 
N:  4096^2, cpu mult: 1.8160, cpu broadcasted mult: 1.3882
            gpu mult: 0.0249, gpu broadcasted mult: 0.0202
               ratio: 73.02 ,                ratio: 68.77 
N:  8192^2, cpu mult: 7.5265, cpu broadcasted mult: 5.6695
            gpu mult: 0.0999, gpu broadcasted mult: 0.0792
               ratio: 75.37 ,                ratio: 71.56 
N: 16384^2, cpu mult: 33.5541, cpu broadcasted mult: 22.7045
            gpu mult: 0.3945, gpu broadcasted mult: 0.3149
               ratio: 85.05 ,                ratio: 72.10 

  *** CPU/GPU speed comparison for simple operations on arrays of Float64 ***

N:    64^2, cpu mult: 0.0001, cpu broadcasted mult: 0.0001
            gpu mult: 0.0005, gpu broadcasted mult: 0.0005
               ratio: 0.23  ,                ratio: 0.29  
N:   128^2, cpu mult: 0.0005, cpu broadcasted mult: 0.0003
            gpu mult: 0.0005, gpu broadcasted mult: 0.0005
               ratio: 0.94  ,                ratio: 0.66  
N:   256^2, cpu mult: 0.0044, cpu broadcasted mult: 0.0025
            gpu mult: 0.0005, gpu broadcasted mult: 0.0005
               ratio: 8.81  ,                ratio: 5.23  
N:   512^2, cpu mult: 0.0222, cpu broadcasted mult: 0.0139
            gpu mult: 0.0006, gpu broadcasted mult: 0.0005
               ratio: 39.59 ,                ratio: 26.17 
N:  1024^2, cpu mult: 0.1100, cpu broadcasted mult: 0.0578
            gpu mult: 0.0035, gpu broadcasted mult: 0.0025
               ratio: 31.06 ,                ratio: 22.87 
N:  2048^2, cpu mult: 0.8330, cpu broadcasted mult: 0.5964
            gpu mult: 0.0126, gpu broadcasted mult: 0.0088
               ratio: 65.92 ,                ratio: 67.95 
N:  4096^2, cpu mult: 3.7111, cpu broadcasted mult: 2.7473
            gpu mult: 0.0488, gpu broadcasted mult: 0.0340
               ratio: 76.04 ,                ratio: 80.90 
N:  8192^2, cpu mult: 15.6453, cpu broadcasted mult: 11.4698
            gpu mult: 0.1930, gpu broadcasted mult: 0.1344
               ratio: 81.06 ,                ratio: 85.32 
N: 16384^2, cpu mult: 63.2279, cpu broadcasted mult: 45.5665
            gpu mult: 0.7693, gpu broadcasted mult: 0.5353
               ratio: 82.19 ,                ratio: 85.12
```

# Testing FFTs
```
julia> include("benchmarks/fftbenchmark.jl")

Testing CPU Float64 complex fft speed...
64... 128... 256... 512... 1024... 2048... 4096... 8192... 
Testing GPU Float64 complex fft speed...
64... 128... 256... 512... 1024... 2048... 4096... 8192... done.

*** complex 2d Float64 fft results (8 cpu threads, 200 loops) ***

 machine | n:       64 |       128 |       256 |       512 |      1024 |      2048 |      4096 |      8192 | 
-------------------------------------------------------------------------------
     CPU |     0.03158 |   0.05229 |   0.13441 |   0.40504 |   1.83394 |  10.87794 |  49.97035 |  216.79679 | 
     GPU |     0.00470 |   0.00526 |   0.00583 |   0.01242 |   0.12862 |   0.94711 |   5.21529 |  23.19938 | 
   ratio |     6.71933 |   9.94114 |  23.04391 |  32.61099 |  14.25878 |  11.48542 |   9.58151 |   9.34494 | 


Testing CPU Float64 complex fft speed...
16... 32... 64... 128... 256... 
Testing GPU Float64 complex fft speed...
16... 32... 64... 128... 256... done.

*** complex 3d Float64 fft results (8 cpu threads, 200 loops) ***

 machine | n:       16 |        32 |        64 |       128 |       256 | 
-------------------------------------------------------------------------------
     CPU |     0.03042 |   0.07090 |   0.35078 |   4.42231 |  49.43630 | 
     GPU |     0.00574 |   0.00713 |   0.03148 |   0.25626 |   5.07424 | 
   ratio |     5.29591 |   9.95094 |  11.14441 |  17.25722 |   9.74260 |
```

# Testing 2D turbulence with pseudo-spectral method
```
julia> include("benchmarks/twodturbbenchmark.jl")

100 steps of Float32 twodturb with n=   64^2. CPU:   0.0591 s, GPU:   0.0127, ratio:  4.66
100 steps of Float32 twodturb with n=  128^2. CPU:   0.0686 s, GPU:   0.0126, ratio:  5.43
100 steps of Float32 twodturb with n=  256^2. CPU:   0.1404 s, GPU:   0.0223, ratio:  6.31
100 steps of Float32 twodturb with n=  512^2. CPU:   0.4823 s, GPU:   0.0730, ratio:  6.60
100 steps of Float32 twodturb with n= 1024^2. CPU:   2.2486 s, GPU:   0.2828, ratio:  7.95
100 steps of Float32 twodturb with n= 2048^2. CPU:   8.9168 s, GPU:   1.4325, ratio:  6.22
100 steps of Float32 twodturb with n= 4096^2. CPU:  32.2673 s, GPU:   7.1773, ratio:  4.50

100 steps of Float64 twodturb with n=   64^2. CPU:   0.0521 s, GPU:   0.0130, ratio:  4.01
100 steps of Float64 twodturb with n=  128^2. CPU:   0.0688 s, GPU:   0.0131, ratio:  5.26
100 steps of Float64 twodturb with n=  256^2. CPU:   0.2167 s, GPU:   0.0228, ratio:  9.51
100 steps of Float64 twodturb with n=  512^2. CPU:   0.5965 s, GPU:   0.0762, ratio:  7.83
100 steps of Float64 twodturb with n= 1024^2. CPU:   2.9324 s, GPU:   0.3380, ratio:  8.68
100 steps of Float64 twodturb with n= 2048^2. CPU:  12.0575 s, GPU:   1.5391, ratio:  7.83
100 steps of Float64 twodturb with n= 4096^2. CPU:  51.7457 s, GPU:   7.6637, ratio:  6.75
```

