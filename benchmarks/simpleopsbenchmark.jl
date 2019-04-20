using CuBenchmarks

testns = @. 2^(6:12)

simpleopsbenchmark(testns, Float32)
simpleopsbenchmark(testns, Float64)
