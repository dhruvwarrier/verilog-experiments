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

# tests all cases in NOR and NAND, bitwise
# 3 NAND 5 = E
# 3 NOR 5 = 8
force {KEY[2:0]} 101
force {SW[7:4]} 0011
force {SW[3:0]} 0101
run 10ns

# random example 1
# E NAND 5 = B
# E NOR 5 = 0
force {KEY[2:0]} 101
force {SW[7:4]} 1110
force {SW[3:0]} 0101
run 10ns

# random example 2
# 7 NAND 9 = E
# 7 NOR 9 = 0
force {KEY[2:0]} 101
force {SW[7:4]} 0111
force {SW[3:0]} 1001
run 10ns