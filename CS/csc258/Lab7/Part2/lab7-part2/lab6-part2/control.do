vlib work

vlog -timescale 1ns/1ns part2.v

vsim control

log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2
force {resetn} 0 0, 1 3

force {go} 0 0, 1 5 -r 10

force {enable} 0 0, 1 18

run 50ns