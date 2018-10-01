#= twodturb.jl

Solves the 2D vorticity equation using a Fourier pseudospectral method
in a doubly-periodic box. Time-stepping is Forward Euler. Does not 
dealias.
=#

function twodturbspeedtest!(vs, nu, dt, nsteps; dmsg=1000)
  t = 0.0
  for step = 1:nsteps
    if step % dmsg == 0 && step > 1
      @printf("step: %04d, t: %6.1f\n", step, t)
    end

    # Step forward
    calcrhs!(vs, nu)
    @. vs.qh += dt*vs.rhs
    t += dt
  end
  vs.qsh .= vs.qh
  ldiv!(vs.q, vs.rfftplan, vs.qsh)

  nothing
end

"Calculate right hand side of vorticity equation."
function calcrhs!(k, l, Ksq, invKsq, q, u, v, qh, qsh, rhs, uh, vh, rfftplan, nu)
  @. uh =  im * l * invKsq * qh
  @. vh = -im * k * invKsq * qh
  qsh .= qh  # Necessary because ldiv! on an rfftplan destroys its input.

  ldiv!(q, rfftplan, qsh)
  ldiv!(u, rfftplan, uh)
  ldiv!(v, rfftplan, vh)

  @. u *= q
  @. v *= q

  mul!(uh, rfftplan, u)
  mul!(vh, rfftplan, v)

  @. rhs = -im*k*uh - im*l*vh - nu*Ksq*qh
  nothing
end

calcrhs!(vs, nu) = calcrhs!(vs.k, vs.l, vs.Ksq, vs.invKsq, vs.q, vs.u, vs.v, vs.qh, vs.qsh, vs.rhs, vs.uh, vs.vh, 
                          vs.rfftplan, nu)

struct Vars{T}
  k::Array{T,2}
  l::Array{T,2}
  Ksq::Array{T,2}
  invKsq::Array{T,2}
  q::Array{T,2}
  u::Array{T,2}
  v::Array{T,2}
  qh::Array{Complex{T},2}
  qsh::Array{Complex{T},2}
  rhs::Array{Complex{T},2}
  uh::Array{Complex{T},2}
  vh::Array{Complex{T},2}
  rfftplan::FFTW.rFFTWPlan{T,-1,false,2}
end

struct CuVars{T}
  k::CuArray{T,2}
  l::CuArray{T,2}
  Ksq::CuArray{T,2}
  invKsq::CuArray{T,2}
  q::CuArray{T,2}
  u::CuArray{T,2}
  v::CuArray{T,2}
  qh::CuArray{Complex{T},2}
  qsh::CuArray{Complex{T},2}
  rhs::CuArray{Complex{T},2}
  uh::CuArray{Complex{T},2}
  vh::CuArray{Complex{T},2}
  rfftplan::CuArrays.FFT.rCuFFTPlan{T,-1,false,2}
end

function Vars(T, nx, Lx; usegpu=false)
  # Construct the grid
  dx = Lx/nx
  nk, nl = Int(nx/2+1), nx
  k = Array{T,2}(reshape(2π/Lx*(0:Int(nx/2)), (nk, 1)))
  l = Array{T,2}(reshape(2π/Lx*cat(0:nl/2, -nl/2+1:-1, dims=1), (1, nl)))

  Ksq = @. k^2 + l^2
  invKsq = @. 1/Ksq
  invKsq[1, 1] = 0.0  # Will eliminate 0th mode during inversion

  # Random initial condition
  q = rand(nx, nx)
  qh = rfft(q)

  # Preallocate
  u = zeros(T, nx, nx)
  v = zeros(T, nx, nx)

  qsh  = zeros(Complex{T}, nk, nl)
  rhs  = zeros(Complex{T}, nk, nl)
  uh   = zeros(Complex{T}, nk, nl)
  vh   = zeros(Complex{T}, nk, nl)

  if usegpu
    @cuconvertarrays(k, l, Ksq, invKsq, q, u, v, qh, qsh, rhs, uh, vh)
    rfftplan  = plan_rfft(deepcopy(u))
    return CuVars(k, l, Ksq, invKsq, q, u, v, qh, qsh, rhs, uh, vh, rfftplan)
  else
    FFTW.set_num_threads(Sys.CPU_THREADS)
    rfftplan = plan_rfft(deepcopy(u); flags=FFTW.MEASURE)
    return Vars(k, l, Ksq, invKsq, q, u, v, qh, qsh, rhs, uh, vh, rfftplan)
  end
end
