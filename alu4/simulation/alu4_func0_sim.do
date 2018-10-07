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

# identical test cases for ripple_adder, with function inputs

# tests if carry propagates all the way through (can add 1 + 1 + 1)
force {KEY[2:0]} 111
force {SW[7:4]} 1111
force {SW[3:0]} 1111
run 10ns

# tests if all the full adders can add 1 + 1
force {KEY[2:0]} 111
force {SW[7:4]} 1010
force {SW[3:0]} 0101
run 10ns

# tests if all the full adders can add 0 + 0
force {KEY[2:0]} 111
force {SW[7:4]} 0000
force {SW[3:0]} 0000
run 10ns

# tests if all the full adders can add 0 + 1
force {KEY[2:0]} 111
force {SW[7:4]} 0000
force {SW[3:0]} 1111
run 10ns

# a few sample additions

# 7 + 9 = 16
force {KEY[2:0]} 111
force {SW[7:4]} 0111
force {SW[3:0]} 1001
run 10ns

# 10 + 14 = 24
force {KEY[2:0]} 111
force {SW[7:4]} 1010
force {SW[3:0]} 1110
run 10ns

# 11 + 13 = 24
force {KEY[2:0]} 111
force {SW[7:4]} 1011
force {SW[3:0]} 1101
run 10ns

# 5 + 15 = 20
force {KEY[2:0]} 111
force {SW[7:4]} 0101
force {SW[3:0]} 1111
run 10ns




