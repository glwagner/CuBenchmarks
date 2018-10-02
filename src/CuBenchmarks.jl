module CuBenchmarks

export 
  fftbenchmark,
  simpleopsbenchmark,
  twodturbbenchmark

using
  Random,
  Printf,
  BenchmarkTools,
  FFTW,
  CuArrays

using LinearAlgebra: mul!, ldiv!

macro cuconvertarrays(vars...)
  expr = Expr(:block)
  append!(expr.args, [:($(esc(var)) = CuArray($(esc(var)));) for var in vars])
  expr 
end

include("cpugpufft.jl")
include("cpugpusimpleops.jl")
include("cpugputwodturb.jl")

end # module
