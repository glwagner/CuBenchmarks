function simpleopsbenchmark(testns, T=Float64)
  println("\n*** CPU/GPU speed comparison for simple operations on arrays of $T ***\n")
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

    gpurtime = @belapsed CuArrays.@sync mult!($Ag, $Bg, $Cg)
    gpubtime = @belapsed CuArrays.@sync broadcastmult!($Ag, $bg, $Cg)

    println(simpleopsmsg(n, btime, rtime, gpubtime, gpurtime))
  end
  nothing
end

function broadcastmult!(A, x, F; nloops=100)
  for i = 1:nloops
    @. A = x*F
  end
end

function mult!(A, X, F; nloops=100)
  for i = 1:nloops
    @. A = X*F
  end
end

function simpleopsmsg(n, btime, rtime, gpubtime, gpurtime) 
  msg =  @sprintf("N: %5d^2, cpu mult: %.4f, cpu broadcasted mult: %.4f\n", n, rtime, btime)
  msg *= @sprintf("            gpu mult: %.4f, gpu broadcasted mult: %.4f\n", gpurtime, gpubtime)
  msg *= @sprintf("               ratio: %-6.2f,                ratio: %-6.2f", rtime/gpurtime, btime/gpubtime)
  msg
end

