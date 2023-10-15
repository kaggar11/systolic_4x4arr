#!/bin/sh -x

if [ -d work ]; then
    rm -rf work
fi
vlib work

rtl_dir="../rtl"
tb_dir="."

vlog \
    $rtl_dir/MAC.v \
    $rtl_dir/MMU.v \
    $tb_dir/MMU_test.v \
    -timescale "1 ns / 1 ns" \
    -incr


vsim -c \
    -do "transcript on" \
    -do "add wave -r /*" \
    -do "run -all" \
    -do "quit" \
    -l vsim.log \
    -wlf mmu.wlf \
    +nowarnTSCALE \
    -voptargs=+acc \
    test_TPU
