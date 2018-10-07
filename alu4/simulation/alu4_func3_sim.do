vlib work

vlog alu4_main.v
vlog alu4.v
vlog ripple_adder4.v
vlog ripple_subtractor4.v
vlog full_adder.v
vlog hex_decoder.v

vsim alu4_main
log {/*}
add wave {/*}

# no 1 bits present, output must be condition_failed (00000000)
force {KEY[2:0]} 100
force {SW[7:4]} 0000
force {SW[3:0]} 0000
run 10ns

# can 1's be detected in A? output must be C0 (11000000)
force {KEY[2:0]} 100
force {SW[7:4]} 1110
force {SW[3:0]} 0000
run 10ns

# can 1's be detected in B? output must be C0 (11000000)
force {KEY[2:0]} 100
force {SW[7:4]} 0000
force {SW[3:0]} 0101
run 10ns