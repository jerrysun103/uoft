vlib work

vlog -timescale 1ns/1ns sequence_detector.v

vsim sequence_detector

log {/*}

add wave {/*}

force {SW[0]} 0
force {SW[1]} 1
force {KEY[0]} 1
run 5ns

force {SW[0]} 0
force {SW[1]} 1
force {KEY[0]} 0
run 5ns

force {SW[0]} 1
force {KEY[0]} 0 0, 1 1 -repeat 2
force {SW[1]} 1
run 10ns

#
force {SW[0]} 1
force {KEY[0]} 0
force {SW[1]} 0
run 1ns

force {SW[0]} 1
force {KEY[0]} 1
force {SW[1]} 0
run 1ns

force {SW[0]} 1
force {KEY[0]} 0
force {SW[1]} 1
run 1ns

force {SW[0]} 1
force {KEY[0]} 1
force {SW[1]} 1
run 1ns

#
force {SW[0]} 1
force {KEY[0]} 0
force {SW[1]} 0
run 1ns

force {SW[0]} 1
force {KEY[0]} 1
force {SW[1]} 0
run 1ns

force {SW[0]} 1
force {KEY[0]} 0
force {SW[1]} 0
run 1ns

force {SW[0]} 1
force {KEY[0]} 1
force {SW[1]} 0
run 1ns

force {SW[0]} 1
force {KEY[0]} 0
force {SW[1]} 1
run 1ns

force {SW[0]} 1
force {KEY[0]} 1
force {SW[1]} 1
run 1ns

