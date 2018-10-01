function testbroadcastspeed(testns, T=Float64)
  println("*** CPU/GPU speed comparison for simple operations on arrays of $T ***")
  for n in testns
    C = rand(T, n, n)
    b = Array(reshape(rand(T, n), (n, 1)))
    B = [ b[i] for i=1:n, j=1:n ]
    A = zeros(eltype(B), size(B))

    Ag = CuArray(A)
    bg = CuArray(b)
    Bg = CuArray(B)
    Cg = CuArray(C)

    # Compile
    broadcastmult!(A, b, C; nloops=1)
    mult!(A, B, C; nloops=1)
    broadcastmult!(Ag, bg, Cg; nloops=1)
    mult!(Ag, Bg, Cg; nloops=1)
    
    # Run
    rtime = @belapsed mult!($A, $B, $C)
    btime = @belapsed broadcastmult!($A, $b, $C)

    gpurtime = @belapsed mult!($Ag, $Bg, $Cg)
    gpubtime = @belapsed broadcastmult!($Ag, $bg, $Cg)

    println(simpleresultmsg(n, btime, rtime, gpubtime, gpurtime))
  end
  nothing
end

function broadcastmult!(A, x, F; nloops=1000)
  for i = 1:nloops
    @. A = x*F
  end
end

function mult!(A, X, F; nloops=1000)
  for i = 1:nloops
    @. A = X*F
  end
end

simpleresultmsg(n, btime, rtime, gpubtime, gpurtime) =  @sprintf(
  "N: %5d^2, cpu mult: %.4f, cpu broadcasted mult: %.4f\n            gpu mult: %.4f, gpu broadcasted mult: %.4f",
  n, rtime, btime, gpurtime, gpubtime)

