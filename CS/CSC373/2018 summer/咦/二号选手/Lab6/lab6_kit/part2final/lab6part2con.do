vlib work

vlog -timescale 1ns/1ns lab6part2.v

vsim control

log {/*}

add wave {/*}

force {clk} 0
force {resetn} 0
force {go} 0
run 5ns

force {clk} 1
force {resetn} 0
force {go} 0
run 5ns

force {clk} 0
force {resetn} 1
force {go} 0
run 5ns

##after reset

force {clk} 0 0, 1 1 -repeat 2
force {resetn} 1
force {go} 0 0, 1 5 -repeat 10
run 100ns



