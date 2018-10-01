module CuSpeedTests

export 
  testfftspeed,
  printresults,
  testbroadcastspeed,
  twodturbspeedtest!,
  Vars

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

include("fft.jl")
include("simpleops.jl")
include("twodturb.jl")

end # module
