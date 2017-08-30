onerror {quit -f}
vlib work
vlog -work work UARTBaseStation.vo
vlog -work work UARTBaseStation.vt
vsim -novopt -c -t 1ps -L maxv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.FullBaseStation_vlg_vec_tst
vcd file -direction UARTBaseStation.msim.vcd
vcd add -internal FullBaseStation_vlg_vec_tst/*
vcd add -internal FullBaseStation_vlg_vec_tst/i1/*
add wave /*
run -all
