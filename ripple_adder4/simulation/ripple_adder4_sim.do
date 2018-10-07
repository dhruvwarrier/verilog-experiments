vlib work

vlog full_adder.v
# adds two 4 bit binary numbers with Cin, outputs sum and Cout
vlog ripple_adder4.v
# binds DE1_SOC switches and pins to ripple_adder4
vlog ripple_adder4_main.v

vsim ripple_adder4_main
log {/*}
add wave {/*}

# tests if carry propagates all the way through (can add 1 + 1 + 1)
force {SW[8]} 0
force {SW[7:4]} 1111
force {SW[3:0]} 1111
run 10ns

# tests if all the full adders can add 1 + 1
force {SW[8]} 1
force {SW[7:4]} 1010
force {SW[3:0]} 0101
run 10ns

# tests if all the full adders can add 0 + 0
force {SW[8]} 0
force {SW[7:4]} 0000
force {SW[3:0]} 0000
run 10ns

# tests if all the full adders can add 0 + 1
force {SW[8]} 0
force {SW[7:4]} 0000
force {SW[3:0]} 1111
run 10ns

# a few sample additions

# 7 + 9 = 16
force {SW[8]} 0
force {SW[7:4]} 0111
force {SW[3:0]} 1001
run 10ns

# 10 + 14 = 24
force {SW[8]} 0
force {SW[7:4]} 1010
force {SW[3:0]} 1110
run 10ns

# 11 + 13 = 24
force {SW[8]} 0
force {SW[7:4]} 1011
force {SW[3:0]} 1101
run 10ns

# 5 + 15 = 20
force {SW[8]} 0
force {SW[7:4]} 0101
force {SW[3:0]} 1111
run 10ns



