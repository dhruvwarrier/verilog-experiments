# set the working dir, where all compiled verilog goes
vlib work

vlog alu4_accumulator_main.v
vlog alu4/alu4_accumulator.v
vlog alu4/full_adder.v
vlog alu4/hex_decoder.v
vlog register8.v
vlog alu4/ripple_adder4.v


vsim alu4_main
log {/*}
add wave {/*}

# reset accumulator at the beginning
force {SW[9:0]} 0000000000
force {KEY[3:0]} 1110
run 1ns
force {KEY[0]} 1

# show that accumulator got reset
run 5ns

force {KEY[0]} 0
# prevents reset from here on out
force {SW[9]} 1

# show that 4 lower bits from register pass back to ALU
# adds 6 then 7
force {KEY[3:1]} 111
force {SW[3:0]} 0110
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
force {SW[3:0]} 0111
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0

# show that new function 7 works, the stored value 13 is held
force {KEY[3:1]} 000
force {SW[3:0]} 1001
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
force {SW[3:0]} 1010
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0




