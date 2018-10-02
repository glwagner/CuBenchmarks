using CuBenchmarks

for nx in [64, 128, 256, 512, 1024, 2048]
  twodturbbenchmark(nx)
end
