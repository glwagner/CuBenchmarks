using CuBenchmarks

testns2 = @. 2^(6:13)
fftbenchmark(testns2; dim=2)

testns3 = @. 2^(4:8)
fftbenchmark(testns3; dim=3)
