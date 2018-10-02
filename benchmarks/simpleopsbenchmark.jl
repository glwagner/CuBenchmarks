using CuBenchmark

testns = @. 2^(6:11)

simpleopsbenchmark(testns, Float32)
simpleopsbenchmark(testns, Float64)
