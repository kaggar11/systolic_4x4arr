#!/bin/sh -x

if [ -d work_gls ]; then
    rm -rf work_gls
fi
vlib work_gls

rtl_dir="../rtl"
tb_dir="."

vlog \
    $rtl_dir/asap7sc7p5t_24_AO_RVT_TT.v \
    $rtl_dir/asap7sc7p5t_24_INVBUF_RVT_TT.v \
    $rtl_dir/asap7sc7p5t_24_OA_RVT_TT.v \
    $rtl_dir/asap7sc7p5t_24_SEQ_RVT_TT.v \
    $rtl_dir/asap7sc7p5t_24_SIMPLE_RVT_TT.v \
    $rtl_dir/MAC.v \
    $rtl_dir/MMU.2000.syn.v \
    $tb_dir/MMU_test.v \
    -v $rtl_dir/asap7sc7p5t_24_AO_RVT_TT.lib \
    -timescale "1 ns / 1 ns" \
    -incr \
    -work work_gls


vsim -c \
    -do "transcript on" \
    -do "add wave -r /*" \
    -do "run -all" \
    -do "quit" \
    -l vsim_gls.log \
    -wlf mmu_gls.wlf \
    +nowarnTSCALE \
    -voptargs=+acc \
    -lib work_gls \
    test_TPU
