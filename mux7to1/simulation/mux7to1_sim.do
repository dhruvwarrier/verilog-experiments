# set working dir
vlib work

# mux7to1 returns a multiplexed output given a data bus and select bus
vlog mux7to1.v
# mux7to1_main binds input switches and output LED to mux7to1
vlog mux7to1_main.v

# load simulation
vsim mux7to1_main
log {/*}
add wave {/*}

# run all possible select inputs

# select digit 0
force {SW[9:7]} 000
force {SW[6:0]} 1101010
run 10ns

# select digit 1
force {SW[9:7]} 001
force {SW[6:0]} 1101010
run 10ns

# select digit 2
force {SW[9:7]} 010
force {SW[6:0]} 1101010
run 10ns

# select digit 3
force {SW[9:7]} 011
force {SW[6:0]} 1101010
run 10ns

# select digit 4
force {SW[9:7]} 100
force {SW[6:0]} 1101010
run 10ns

# select digit 5
force {SW[9:7]} 101
force {SW[6:0]} 1101010
run 10ns

# select digit 6
force {SW[9:7]} 110
force {SW[6:0]} 1101010
run 10ns