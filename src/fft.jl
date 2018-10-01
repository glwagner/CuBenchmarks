function testfftspeed(ns; T=Float64, dim=3, nthreads=Sys.CPU_THREADS, effort=FFTW.MEASURE, nloops=100,
                      ffttype="complex")
                      
  FFTW.set_num_threads(nthreads)
  ENV["MKL_NUM_THREADS"] = nthreads
  ENV["JULIA_NUM_THREADS"] = nthreads

  times = zeros(T, length(ns))
  gputimes = zeros(T, length(ns))

  @printf("\nTesting CPU %s fft speed...\n", ffttype)
  for (i, n) in enumerate(ns)
    @printf "%d... " n
    a = makearray(n, dim, T)
    ah = fft(a)
    fftplan = plan_fft(deepcopy(a); flags=effort)
    fftloop!(a, ah, fftplan; nloops=1) # Compile
    times[i] = @belapsed fftloop!($a, $ah, $fftplan; nloops=$nloops) # Run
  end

  @printf("\nTesting GPU %s fft speed...\n", ffttype)
  for (i, n) in enumerate(ns)
    @printf "%d... " n
    a = CuArray(makearray(n, dim, T))
    ah = fft(a)
    fftplan = plan_fft(deepcopy(a))
    fftloop!(a, ah, fftplan; nloops=1)
    gputimes[i] = @belapsed fftloop!($a, $ah, $fftplan; nloops=$nloops)
  end

  @printf "done.\n"

  ns, nthreads, dim, times, gputimes
end


"""
Prettily print the results of an fft test across arrays of size ns and
nthreads.
"""
function printresults(nthreads, ns, nloops, dim, times, gputimes; ffttype="complex")

  # Header
  results = @sprintf("\n*** %s %dd fft results (%d cpu threads, %d loops) ***\n\n", 
                     ffttype, dim, nthreads, nloops)
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

  results *= @sprintf("% 8s |   ", "speedup")
  for (i, n) in enumerate(ns)
    results *= @sprintf("% 9.5f | ", times[i]/gputimes[i])
  end
  results *= "\n"

  println(results)
  nothing
end

function makearray(n, dim, T) 
  shape = Tuple([1 for i=1:dim])
  rand(T, shape) .+ im.*rand(T, shape)
end

function fftloop!(a, ah, fftplan; nloops=100)
  for i = 1:nloops
    mul!(ah, fftplan, a)
    ldiv!(a, fftplan, ah)
  end
  nothing
end

