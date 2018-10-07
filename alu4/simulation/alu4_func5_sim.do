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

# checks that 0xF complement is 0x0
force {KEY[2:0]} 010
force {SW[7:4]} 1111
force {SW[3:0]} 1101
run 10ns

# checks that 0x0 complement is 0xF
force {KEY[2:0]} 010
force {SW[7:4]} 0000
force {SW[3:0]} 1111
run 10ns

# checks A_complement on a random example, result should be 0xA
force {KEY[2:0]} 010
force {SW[7:4]} 0101
force {SW[3:0]} 1110
run 10ns