module fakequidditch (clk, team1_vu_button, team1_vd_button, team2_vu_button, team2_vd_button, red, green, blue, hor_sync, ver_sync, vga_clk);

	input clk;
	input team1_vu_button;
	input team1_vd_button;
	input team2_vu_button;
	input team2_vd_button;

	wire clk_en;
	parameter div = 2; // <-- divide 50 MHz by this

	wire move_down;
	reg  next_line;

	wire [9:0]    current_row;
	wire [9:0] current_column;
	reg  [9:0] x;
	reg  [9:0] y;

	wire [9:0] team1_ver_position;
	wire [9:0] team2_ver_position;
	reg [9:0] team1_ver_pos;
	reg [9:0] team2_ver_pos;

	output  hor_sync;
	output  ver_sync;
	output wire [7:0]   red;
	output wire [7:0] green;
	output wire [7:0]  blue;
	output reg vga_clk;

	clock_divider cd (clk, div, clk_en);

	vga_horizontal vga_hor (vga_clk, move_down, current_column);

	vga_vertical vga_ver (vga_clk, next_line, current_row);

	team1_controller t1_ctrl (vga_clk, team1_vu_button, team1_vd_button, team1_ver_position);

	team2_controller t2_ctrl (vga_clk, team2_vu_button, team2_vd_button, team2_ver_position);

	vga_controller vga_cont (vga_clk, y, x, team1_ver_pos, team2_ver_pos, hor_sync, ver_sync, red, green, blue);

	//vga_controller vga_cont (vga_clk, y, x, hor_sync, ver_sync, red, green, blue);
	
	always begin
		next_line     <= move_down;
		x         <= current_column;
		y         <=    current_row;
		team1_ver_pos <= team1_ver_position;
		team2_ver_pos <= team2_ver_position;
		vga_clk <= clk_en;
	end

endmodule
