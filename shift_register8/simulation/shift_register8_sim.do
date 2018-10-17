# set the working dir, where all compiled verilog goes
vlib work

vlog shift_register8_main.v
vlog shift_register8.v
vlog flipflop/shift_flipflop.v
vlog flipflop/flipflopD_posedge.v
vlog flipflop/mux2to1.v

vsim shift_register8_main
log {/*}
add wave {/*}

# default behaviour is parallel load
force {KEY[3:1]} 111
force {KEY[0]} 0
force {SW[9:0]} 0001100101
run 5ns
# produce high pulse
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0

# rotate right (no parallel load, stored value is rotated right)
force {KEY[3:1]} 100
force {SW[9:0]} 0001100101
run 5ns
# produce multiple high pulses
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0

# logical rotate right (no parallel load, stored value is logically rotated right)
force {KEY[3:1]} 000
force {SW[9:0]} 0001100101
run 1ns
# produce multiple high pulses
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0

# rotate left (no parallel load, stored value is rotated left)
force {KEY[3:1]} 110
force {SW[9:0]} 0001100101
run 1ns
# produce multiple high pulses
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0

# LSRight is ignored on RotateLeft:
force {KEY[3:1]} 010
run 1ns
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0

# reset shift register
force {SW[9]} 1
run 1ns
force {KEY[0]} 1
run 5ns

