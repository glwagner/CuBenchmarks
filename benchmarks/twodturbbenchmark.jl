using CuBenchmarks

# Resolutions from 64^2 to 4096^2
nxs = @. 2^(6:12)

for nx in nxs
  twodturbbenchmark(nx, T=Float32)
end

println(" ")

for nx in nxs
  twodturbbenchmark(nx, T=Float64)
end
