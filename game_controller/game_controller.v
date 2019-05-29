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
	
	output reg [18:0] ball_ver_position,
	output reg [18:0] ball_hor_position,
	
	output reg [9:0] team1_ver_position,
	output reg [9:0] team2_ver_position,
	
	/*
	output reg [9:0] team1_hor_position,
	output reg [9:0] team2_hor_position,
	*/

	output reg [7:0] time_left
);

	wire score_to_team1;
	wire score_to_team2;

	wire [18:0] x_position;
	wire [18:0] y_position;

	wire [9:0] team1_ver_pos;
	wire [9:0] team2_ver_pos;

	wire game_on;
	reg game_over;

//	wire [9:0] team1_hor_pos;
//	wire [9:0] team2_hor_pos;
	
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
				team1_ver_ctrl (clk, team1_vu_button, team1_vd_button, team1_ver_pos);
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
				team2_ver_ctrl (clk, team2_vu_button, team2_vd_button, team2_ver_pos);
	
	ball_controller_cansu #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
				ball_ctrl (clk, game_over, team1_ver_position, team2_ver_position,team1_vu_button,team1_vd_button,team2_vu_button,team2_vd_button,score_to_team1,score_to_team2,x_position,y_position,x_blugger, y_blugger, game_on);
	//board #(.x_position (x_position),.y_position(y_position),.GOAL_RADIUS(GOAL_RADIUS),.BALL_RADIUS(BALL_RADIUS))
				//board_ctrl (clk,team1_vu_button, team1_vd_button,team2_vu_button,team2_vd_button,score_to_team1, score_to_team2);
//	input [9:0] x_position,
//	input [9:0] y_position,
	//team1_ver_pos,
//	input [9:0] team1_hor_pos,
	//team2_ver_pos,
//	input [9:0] team2_hor_pos,
	//team1_vu_button, team1_vd_button, team2_vu_button, team2_vd_button, score_to_team1, score_to_team2, ball_x, ball_y);
	
/*
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_TEAM1_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
				team1_ver_ctrl (clk, team1_hl_button, team1_hr_button, team1_hor_pos);
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_TEAM2_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
				team2_ver_ctrl (clk, team2_hl_button, team2_hr_button, team2_hor_pos);			
*/
	
//	team1_controller t1_ctrl (clk, team1_vu_button, team1_vd_button, team1_ver_pos);

//	team2_controller t2_ctrl (clk, team2_vu_button, team2_vd_button, team2_ver_pos);
	
	integer counter_clk;

	initial begin
		counter_clk = 0;
		time_left = 'd180;
		game_over = 0;
	end
 
	always @(posedge clk) begin
      if(game_on==1) begin
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
	always begin
		team1_score <= score_to_team1;
		team2_score <= score_to_team2;
	
		ball_hor_position <= x_position;
		ball_ver_position <= y_position;
		
		team1_ver_position <= team1_ver_pos;
		team2_ver_position <= team2_ver_pos;
		
//		team1_hor_position <= team1_hor_pos;
//		team2_hor_position <= team2_hor_pos;
	end

endmodule