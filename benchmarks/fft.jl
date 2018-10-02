using CuBenchmarks

dim = 2
testns = [64, 128, 256, 512, 1024, 2048, 4096]

#dim = 3
#testns = [16, 32, 64, 128, 256]

fftbenchmark(testns; dim=dim)
