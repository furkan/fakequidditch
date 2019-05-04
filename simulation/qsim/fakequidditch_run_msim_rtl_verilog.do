transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Cansu/Desktop/fakequidditch {C:/Users/Cansu/Desktop/fakequidditch/fakequidditch.v}
vlog -vlog01compat -work work +incdir+C:/Users/Cansu/Desktop/fakequidditch {C:/Users/Cansu/Desktop/fakequidditch/clock_divider.v}
vlog -vlog01compat -work work +incdir+C:/Users/Cansu/Desktop/fakequidditch/vga_controller {C:/Users/Cansu/Desktop/fakequidditch/vga_controller/vga_vertical.v}
vlog -vlog01compat -work work +incdir+C:/Users/Cansu/Desktop/fakequidditch/vga_controller {C:/Users/Cansu/Desktop/fakequidditch/vga_controller/vga_horizontal.v}
vlog -vlog01compat -work work +incdir+C:/Users/Cansu/Desktop/fakequidditch/vga_controller {C:/Users/Cansu/Desktop/fakequidditch/vga_controller/vga_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Cansu/Desktop/fakequidditch/game_controller {C:/Users/Cansu/Desktop/fakequidditch/game_controller/team1_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Cansu/Desktop/fakequidditch/game_controller {C:/Users/Cansu/Desktop/fakequidditch/game_controller/team2_controller.v}

