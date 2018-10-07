vlib work

vlog full_adder.v
vsim full_adder

log {/*}
add wave {/*}

# run all possible inputs

force {b} 0
force {a} 0
force {c_in} 0
run 10ns

force {b} 0
force {a} 0
force {c_in} 1
run 10ns

force {b} 0
force {a} 1
force {c_in} 0
run 10ns

force {b} 0
force {a} 1
force {c_in} 1
run 10ns

force {b} 1
force {a} 0
force {c_in} 0
run 10ns

force {b} 1
force {a} 0
force {c_in} 1
run 10ns

force {b} 1
force {a} 1
force {c_in} 0
run 10ns

force {b} 1
force {a} 1
force {c_in} 1
run 10ns



