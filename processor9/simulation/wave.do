onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Resetn /testbench/Resetn
add wave -noupdate -label CLOCK_50 /testbench/CLOCK_50
add wave -noupdate -label Run /testbench/Run
add wave -noupdate -label Instruction -radix octal /testbench/Instruction
add wave -noupdate -divider processor
add wave -noupdate -label resetn /testbench/U1/resetn
add wave -noupdate -label clock /testbench/U1/clock
add wave -noupdate -label run /testbench/U1/run
add wave -noupdate -label DIN -radix octal /testbench/U1/DIN
add wave -noupdate -label done /testbench/U1/done
add wave -noupdate -label instruction -radix octal /testbench/U1/instr_reg
add wave -noupdate -label current_state /testbench/U1/FSM/current_state
add wave -noupdate -label R0 -radix hexadecimal /testbench/U1/proc/R0
add wave -noupdate -label R1 -radix hexadecimal /testbench/U1/proc/R1
add wave -noupdate -label A -radix hexadecimal /testbench/U1/proc/A
add wave -noupdate -label G -radix hexadecimal /testbench/U1/proc/G
add wave -noupdate -label system_bus -radix hexadecimal /testbench/U1/system_bus
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 98
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {250 ns}
