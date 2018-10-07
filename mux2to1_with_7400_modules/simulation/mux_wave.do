# set working dir
vlib work

# 7400_modules.v contains implementations of 7404, 7408, 7432 chips
vlog 7400_modules.v
# mux_with_7400_modules.v contains implementation of 2to1 mux using 7400-series chips
vlog mux_with_7400_modules.v

# load simulation
vsim mux_with_7400_modules

# log all signals
log {/*}
add wave {/*}

# run some test cases
# SW[0] should control LED[0]
force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 0
run 10ns

# SW[0] should control LED[0]
force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 0
run 10ns

# SW[0] should control LED[0]
force {SW[0]} 1
force {SW[1]} 0
force {SW[9]} 0
run 10ns

# SW[0] should control LED[0]
force {SW[0]} 1
force {SW[1]} 1
force {SW[9]} 0
run 10ns

# SW[1] should control LED[0]
force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 1
run 10ns

# SW[1] should control LED[0]
force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 1
run 10ns

# SW[1] should control LED[0]
force {SW[0]} 1
force {SW[1]} 0
force {SW[9]} 1
run 10ns

# SW[1] should control LED[0]
force {SW[0]} 1
force {SW[1]} 1
force {SW[9]} 1
run 10ns