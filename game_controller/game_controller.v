  module game_controller #(
	parameter PLAYER_RADIUS,
	parameter BALL_RADIUS,
	parameter GOAL_RADIUS,
	parameter INITIAL_VER_POS,
	parameter INITIAL_HOR_POS,
	parameter PLAYER_MOVEMENT_FREQUENCY,
	parameter BALL_MOVEMENT_FREQUENCY
)
(	input clk,

	input team1_vu_button,
	input team1_vd_button,
	input team2_vu_button,
	input team2_vd_button,
	
	input team1_hl_button,
	input team1_hr_button,
	input team2_hl_button,
	input team2_hr_button,
	
	output reg [18:0] ball_ver_position,
	output reg [18:0] ball_hor_position,
	
	output reg [9:0] team1_ver_position,
	output reg [9:0] team2_ver_position,
	
	output reg [9:0] team1_hor_position,
	output reg [9:0] team2_hor_position,

	output reg [7:0] time_left,
	
	output reg [6:0] blue_score,
	output reg [6:0] red_score
);

	wire [18:0] x_position;
	wire [18:0] y_position;

	wire [9:0] team1_ver_pos;
	wire [9:0] team2_ver_pos;

	reg game_on;
	reg game_over;
	
	wire blue_score_up, red_score_up;
	
	wire button_pressed;
	reg  game_initiated;

	wire [9:0] team1_hor_pos;
	wire [9:0] team2_hor_pos;
	
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
		team1_ver_ctrl (clk, team1_vu_button, team1_vd_button, team1_ver_pos);
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
		team2_ver_ctrl (clk, team2_vu_button, team2_vd_button, team2_ver_pos);
/*
	ball_controller_cansu #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
				ball_ctrl (clk, game_over, team1_ver_position, team2_ver_position,team1_vu_button,team1_vd_button,team2_vu_button,team2_vd_button,team1_hl_button,team1_hr_button,team2_hl_button,team2_hr_button,/*score_to_team1,score_to_team2,*//* x_position,y_position, game_on);
*/	
/*
	ball_controller #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
		ball_ctrl (clk, game_on, game_over, team1_ver_position, team2_ver_position, team1_hor_position, team2_hor_position, x_position,y_position);
*/
	
	ball_controller_furkan #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
		ball_ctrl (clk, game_initiated, game_over, team1_ver_position, team2_ver_position, team1_hor_position, team2_hor_position, x_position, y_position, blue_score_up, red_score_up);

	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
		team1_hor_ctrl (clk, team1_hl_button, team1_hr_button, team1_hor_pos);
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
		team2_hor_ctrl (clk, team2_hl_button, team2_hr_button, team2_hor_pos);
	
	integer counter_clk;

	initial begin
		counter_clk =     0;
		time_left   = 'd180;
		game_over   =     0;
		game_on     =     0;
	end
	
	assign button_pressed = !(team1_vu_button && team1_vd_button && team2_vu_button && team2_vd_button);
	
	always @(posedge clk) begin
		if (button_pressed == 1) begin
			game_on <= 1;
		end
	end
	
	always @(posedge clk) begin
       if (game_on == 1) begin
			if ((counter_clk == 49999999) && time_left != 0) begin
				counter_clk <= 'd0;
				time_left <= time_left - 'd1;
			end else if (time_left == 0) begin
				game_over <= 1;
			end else begin
				counter_clk <= counter_clk + 'd1;
			end
		end
	end
	
	always @(posedge clk) begin
		if ((blue_score[0] ^ blue_score_up) == 1) begin
			blue_score = blue_score + 1;
		end
		if ((red_score[0] ^ red_score_up) == 1) begin
			red_score = red_score + 1;
		end
	end
	
	always begin
		ball_hor_position <= x_position;
		ball_ver_position <= y_position;
		
		team1_ver_position <= team1_ver_pos;
		team2_ver_position <= team2_ver_pos;
		
		team1_hor_position <= team1_hor_pos;
		team2_hor_position <= team2_hor_pos;
		
		game_initiated <= button_pressed;
	end

endmodule 