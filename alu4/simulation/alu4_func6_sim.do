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

# checks all combinations of bits for XOR and XNOR, bitwise
# 35 --> 0011 0101 to 69 --> 0110 1001
force {KEY[2:0]} 001
force {SW[7:4]} 0011
force {SW[3:0]} 0101
run 10ns

# random example 1 (BC --> 1011 1100 to 78 --> 0111 1000)
force {KEY[2:0]} 001
force {SW[7:4]} 1011
force {SW[3:0]} 1100
run 10ns

# random example 2 (64 --> 0110 0100 to 2D --> 0010 1101)
force {KEY[2:0]} 001
force {SW[7:4]} 0110
force {SW[3:0]} 0100
run 10ns