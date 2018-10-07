# set working dir
vlib work

# 7400_modules.v contains implementations of 7404, 7408, 7432 chips
vlog 7400_modules.v

# load simulation
vsim v7408

# log all signals
log {/*}
add wave {/*}

# run some test cases
# test each gate to satisfy main condition: when both signals are 1, output = 1
# test each gate on another random set of inputs for which output = 0
force {pin1} 1
force {pin2} 1
run 10ns
force {pin1} 0
force {pin2} 0
run 10ns

force {pin4} 1
force {pin5} 1
run 10ns
force {pin4} 0
force {pin5} 1
run 10ns

force {pin9} 1
force {pin10} 1
run 10ns
force {pin9} 1
force {pin10} 0
run 10ns

force {pin12} 1
force {pin13} 1
run 10ns
force {pin12} 1
force {pin13} 0
run 10ns