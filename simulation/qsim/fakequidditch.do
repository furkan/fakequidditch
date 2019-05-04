onerror {exit -code 1}
vlib work
vlog -work work fakequidditch.vo
vlog -work work vga_controller.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.fakequidditch_vlg_vec_tst -voptargs="+acc"
vcd file -direction fakequidditch.msim.vcd
vcd add -internal fakequidditch_vlg_vec_tst/*
vcd add -internal fakequidditch_vlg_vec_tst/i1/*
run -all
quit -f
