using 
  Printf,
  BenchmarkTools,
  CuSpeedTests

# Parameters
Lx = 2π               # Physical box size
nu = 8e-5             # Laplacian viscosity
dt = 1e-2             # Time step
nsteps = 100
T = Float64

# Precompile
v = Vars(T, 32, Lx; usegpu=false)
twodturbspeedtest!(v, nu, dt, 1)

v = Vars(T, 32, Lx; usegpu=true)
twodturbspeedtest!(v, nu, dt, 1)

# Run tests
for nx in [64, 128, 256, 512, 1024, 2048]
  vcpu = Vars(T, nx, Lx; usegpu=false)
  vgpu = Vars(T, nx, Lx; usegpu=true)

  @printf "n=%d, CPU" nx
  @btime twodturbspeedtest!(vcpu, nu, dt, nsteps)

  @printf "n=%d, GPU" nx
  @btime twodturbspeedtest!(vgpu, nu, dt, nsteps)
  println(" ")
end
