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

# checks if enabled when both conditions match (6D --> 0110 1101), output must be 3F
force {KEY[2:0]} 011
force {SW[7:4]} 0110
force {SW[3:0]} 1101
run 10ns

# checks if enabled when second condition fails (6F --> 0110 1111), output must be 00
force {KEY[2:0]} 011
force {SW[7:4]} 0110
force {SW[3:0]} 1111
run 10ns

# checks if enabled when both conditions match for a different set (5E --> 0101 1110), output must be 3F
force {KEY[2:0]} 011
force {SW[7:4]} 0101
force {SW[3:0]} 1110
run 10ns

# checks if enabled when first condition fails (7E --> 0111 1110), output must be 00
force {KEY[2:0]} 011
force {SW[7:4]} 0111
force {SW[3:0]} 1110
run 10ns