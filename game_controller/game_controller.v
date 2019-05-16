module game_controller #(
	parameter PLAYER_RADIUS,
	parameter BALL_RADIUS,
	parameter GOAL_RADIUS,
	parameter INITIAL_VER_POS,
	parameter INITIAL_TEAM1_HOR_POS,
	parameter INITIAL_TEAM2_HOR_POS,
	parameter PLAYER_MOVEMENT_FREQUENCY,
	parameter BALL_MOVEMENT_FREQUENCY
)
(	input clk,
	input team1_vu_button,
	input team1_vd_button,
	input team2_vu_button,
	input team2_vd_button,
	
	/*
	input team1_hl_button,
	input team1_hr_button,
	input team2_hl_button,
	input team2_hr_button,
	*/
	
	output reg team1_score,
	output reg team2_score,
	
	output reg [9:0] ball_ver_position,
	output reg [9:0] ball_hor_position,
	
	output reg [9:0] team1_ver_position,
	output reg [9:0] team2_ver_position
	
	/*
	output reg [9:0] team1_hor_position,
	output reg [9:0] team2_hor_position,
	*/
);

	wire score_to_team1;
	wire score_to_team2;

	wire [9:0] ball_x;
	wire [9:0] ball_y;

	wire [9:0] team1_ver_pos;
	wire [9:0] team2_ver_pos;
	
//	wire [9:0] team1_hor_pos;
//	wire [9:0] team2_hor_pos;
	
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
				team1_ver_ctrl (clk, team1_vu_button, team1_vd_button, team1_ver_pos);
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
				team2_ver_ctrl (clk, team2_vu_button, team2_vd_button, team2_ver_pos);
	
	ball_controller #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
				ball_ctrl (clk,
//	input [9:0] x_position,
//	input [9:0] y_position,
	team1_ver_pos,
//	input [9:0] team1_hor_pos,
	team2_ver_pos,
//	input [9:0] team2_hor_pos,
	team1_vu_button, team1_vd_button, team2_vu_button, team2_vd_button, score_to_team1, score_to_team2, ball_x, ball_y);
	
/*
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_TEAM1_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
				team1_ver_ctrl (clk, team1_hl_button, team1_hr_button, team1_hor_pos);
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_TEAM2_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
				team2_ver_ctrl (clk, team2_hl_button, team2_hr_button, team2_hor_pos);			
*/
	
//	team1_controller t1_ctrl (clk, team1_vu_button, team1_vd_button, team1_ver_pos);

//	team2_controller t2_ctrl (clk, team2_vu_button, team2_vd_button, team2_ver_pos);
	
	always begin
		team1_score <= score_to_team1;
		team2_score <= score_to_team2;
	
		ball_hor_position <= ball_x;
		ball_ver_position <= ball_y;
		
		team1_ver_position <= team1_ver_pos;
		team2_ver_position <= team2_ver_pos;
		
//		team1_hor_position <= team1_hor_pos;
//		team2_hor_position <= team2_hor_pos;
	end

endmodule