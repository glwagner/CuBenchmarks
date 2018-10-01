using CuSpeedTests

testns = @. 2^(6:11)
testbroadcastspeed(testns, Float32)
testbroadcastspeed(testns, Float64)
