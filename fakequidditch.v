module fakequidditch (clk, team1_vu_button, team1_vd_button, team2_vu_button, team2_vd_button, red, green, blue, hor_sync, ver_sync);

	input clk;
	input team1_vu_button;
	input team1_vd_button;
	input team2_vu_button;
	input team2_vd_button;

	wire clk_en;
	parameter div = 2; // <-- divide 50 MHz by this

	wire move_down;
	reg  next_line;

	wire [9:0]  instant_line;
	wire [9:0] instant_pixel;
	reg [9:0]  current_line;
	reg [9:0] current_pixel;

	wire [9:0] team1_ver_position;
	wire [9:0] team2_ver_position;
	reg [9:0] team1_ver_pos;
	reg [9:0] team2_ver_pos;

	output wire  hor_sync;
	output wire  ver_sync;
	output wire [7:0]   red;
	output wire [7:0] green;
	output wire [7:0]  blue;

	clock_divider cd (clk, div, clk_en);

	vga_horizontal vga_hor (clk_en, move_down, instant_pixel);

	vga_vertical vga_ver (clk_en, next_line, instant_line);

	team1_controller t1_ctrl (clk_en, team1_vu_button, team1_vd_button, team1_ver_position);

	team2_controller t2_ctrl (clk_en, team2_vu_button, team2_vd_button, team2_ver_position);

	vga_controller vga_cont (current_line, current_pixel, team1_ver_pos, team2_ver_pos, hor_sync, ver_sync, red, green, blue);

	always begin
		next_line     <= move_down;
		current_line  <= instant_line;
		current_pixel <= instant_pixel;
		team1_ver_pos <= team1_ver_position;
		team2_ver_pos <= team2_ver_position;
	end

endmodule
