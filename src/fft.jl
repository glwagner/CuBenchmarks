ffttype = "complex"

function fftbenchmark(ns; T=Float64, dim=3, nthreads=Sys.CPU_THREADS, effort=FFTW.MEASURE, nloops=1000)
  FFTW.set_num_threads(nthreads)
  times = fill(0.0, length(ns))
  gputimes = fill(0.0, length(ns))

  @printf("\nTesting CPU %s %s fft speed...\n", T, ffttype)
  for (i, n) in enumerate(ns)
    @printf "%d... " n

    a = makearray(n, dim, T)
    ah = fft(a)
    fftplan = plan_fft(deepcopy(a); flags=effort)
    fftloop!(a, ah, fftplan; nloops=1) # Compile

    times[i] = @belapsed fftloop!($a, $ah, $fftplan; nloops=$nloops) # Run
  end

  @printf("\nTesting GPU %s %s fft speed...\n", T, ffttype)
  for (i, n) in enumerate(ns)
    @printf "%d... " n

    a = CuArray(makearray(n, dim, T))
    ah = fft(a)
    fftplan = plan_fft(deepcopy(a))
    fftloop!(a, ah, fftplan; nloops=1)

    gputimes[i] = @belapsed fftloop!($a, $ah, $fftplan; nloops=$nloops)
  end

  @printf "done.\n"

  fftmsg(nthreads, ns, nloops, dim, times, gputimes, T)
  nothing
end

"Prettily print the results of an fft test across arrays of size ns and nthreads."
function fftmsg(nthreads, ns, nloops, dim, times, gputimes, T)

  # Header
  results = @sprintf("\n*** %s %dd %s fft results (%d cpu threads, %d loops) ***\n\n", 
                     ffttype, dim, T, nthreads, nloops)
  results *= @sprintf(" machine | n:")
  for n in ns
    results *= @sprintf("% 9d | ", n)
  end

  # Divider
  results *= "\n"
  results *= "----------------------------------------------------------------"
  results *= "---------------\n"

  # Body
  results *= @sprintf("% 8s |   ", "CPU")
  for (i, n) in enumerate(ns)
    results *= @sprintf("% 9.5f | ", times[i])
  end
  results *= "\n"

  results *= @sprintf("% 8s |   ", "GPU")
  for (i, n) in enumerate(ns)
    results *= @sprintf("% 9.5f | ", gputimes[i])
  end
  results *= "\n"

  results *= @sprintf("% 8s |   ", "ratio")
  for (i, n) in enumerate(ns)
    results *= @sprintf("% 9.5f | ", times[i]/gputimes[i])
  end
  results *= "\n"

  println(results)
  nothing
end

function makearray(n, dim, T) 
  shape = Tuple([n for i=1:dim])
  rand(T, shape) .+ im.*rand(T, shape)
end

function fftloop!(a, ah, fftplan; nloops=100)
  for i = 1:nloops
    mul!(ah, fftplan, a)
    ah .*= π
    ldiv!(a, fftplan, ah)
  end
  nothing
end
