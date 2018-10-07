# set working dir
vlib work

# 7400_modules.v contains implementations of 7404, 7408, 7432 chips
vlog 7400_modules.v

# load simulation
vsim v7404

# log all signals
log {/*}
add wave {/*}

# run some test cases
force {pin1} 0
run 10ns

force {pin3} 1
run 10ns

force {pin5} 0
run 10ns

force {pin9} 0
run 10ns

force {pin11} 1
run 10ns

force {pin13} 0
run 10ns