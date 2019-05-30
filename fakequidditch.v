module fakequidditch (clk, team1_vu_button, team1_vd_button, team2_vu_button, team2_vd_button, team1_hl_button, team1_hr_button, team2_hl_button, team2_hr_button, red, green, blue, hor_sync, ver_sync, vga_clk);

	input clk;
	
	input team1_vu_button;
	input team1_vd_button;
	input team2_vu_button;
	input team2_vd_button;

	input team1_hl_button;
	input team1_hr_button;
	input team2_hl_button;
	input team2_hr_button;

	wire clk_en;

	wire [9:0] team1_ver_position;
	wire [9:0] team2_ver_position;
	reg  [9:0] team1_ver_pos;
	reg  [9:0] team2_ver_pos;

	wire [9:0] team1_hor_position;
	wire [9:0] team2_hor_position;
	reg  [9:0] team1_hor_pos;
	reg  [9:0] team2_hor_pos;

	wire [18:0] ball_hor_position;
	wire [18:0] ball_ver_position;
	reg  [18:0] ball_x;
	reg  [18:0] ball_y;
	
	wire [6:0]  blue_score;
	wire [6:0]   red_score;
	reg  [6:0] team1_score;
	reg  [6:0] team2_score;

	wire [7:0] time_left;
	reg  [7:0] left_seconds;

	output  hor_sync;
	output  ver_sync;
	output wire [7:0]   red;
	output wire [7:0] green;
	output wire [7:0]  blue;
	output reg vga_clk;

	// Clock divider

	integer counter_clk;

	initial begin
		vga_clk = 0;
		counter_clk = 0;
	end

	always @(posedge clk) begin

		if (counter_clk == 'd1) begin
			counter_clk <= 'd0;
			vga_clk <= 1;
		end else begin
			counter_clk <= counter_clk + 'd1;
			vga_clk <= 0;
		end
	end


	game_controller #(.PLAYER_RADIUS(25),.BALL_RADIUS(5),.GOAL_RADIUS(25),.INITIAL_VER_POS('d250),.INITIAL_HOR_POS('d410),.PLAYER_MOVEMENT_FREQUENCY('d200000), .BALL_MOVEMENT_FREQUENCY('d500000)) 
		game_ctrl (clk, team1_vu_button, team1_vd_button, team2_vu_button, team2_vd_button,
			team1_hl_button, team1_hr_button, team2_hl_button, team2_hr_button,
				 ball_ver_position, ball_hor_position,
				team1_ver_position, team2_ver_position,
				team1_hor_position, team2_hor_position,
					time_left, blue_score, red_score);



	vga_controller #(.PLAYER_RADIUS(25), .GOAL_RADIUS(25), .BALL_RADIUS(5))

		vga_cont (clk, vga_clk, team1_ver_pos, team2_ver_pos, team1_hor_pos, team2_hor_pos, ball_x, ball_y, left_seconds, team1_score, team2_score, hor_sync, ver_sync, red, green, blue);


	always begin
		ball_x <= ball_hor_position;
		ball_y <= ball_ver_position;
		
		team1_ver_pos <= team1_ver_position;
		team2_ver_pos <= team2_ver_position;
		team1_hor_pos <= team1_hor_position;
		team2_hor_pos <= team2_hor_position;
		
		left_seconds  <= time_left;
		
		team1_score   <= blue_score;
		team2_score   <=  red_score;
	end

endmodule