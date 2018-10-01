using CuSpeedTests

# Default test params
nloops = 1000
dim = 2
testns = [64, 128, 256, 512, 1024, 2048, 4096]
#testns = [16, 32, 64, 128, 256] #, 512, 1024, 2048, 4096]

# Real and complex fft speed tests
ns, nthreads, dim, times, gputimes = testfftspeed(testns, nloops=nloops, dim=dim)
printresults(nthreads, ns, nloops, dim, times, gputimes)
