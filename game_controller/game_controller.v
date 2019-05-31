  module game_controller #(
	parameter PLAYER_RADIUS,
	parameter BALL_RADIUS,
	parameter BLUDGER_RADIUS,
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
	
	output reg [10:0] bludger_ver_position,
	output reg [10:0] bludger_hor_position,
	
	output reg [9:0] team1_ver_position,
	output reg [9:0] team2_ver_position,
	
	output reg [9:0] team1_hor_position,
	output reg [9:0] team2_hor_position,

	output reg [7:0] time_left,
	
	output reg [6:0] blue_score,
	output reg [6:0] red_score,
	
	output reg [3:0] blue_ver_bludge_time,
	output reg [3:0] blue_hor_bludge_time,
	output reg [3:0]  red_ver_bludge_time,
	output reg [3:0]  red_hor_bludge_time
	
);

	wire [18:0] x_position;
	wire [18:0] y_position;
	
	wire [10:0] x_bludger;
	wire [10:0] y_bludger;
	
	reg blue_ver_bludged;
	reg red_ver_bludged;
	reg blue_hor_bludged;
	reg red_hor_bludged;
	
	reg blue_ver_clean;
	reg red_ver_clean;
	reg blue_hor_clean;
	reg red_hor_clean;
	
	wire [3:0] blue_ver_bludge_time_wire;
	wire [3:0] red_ver_bludge_time_wire;
	wire [3:0] blue_hor_bludge_time_wire;
	wire [3:0] red_hor_bludge_time_wire;
	
	wire [9:0] team1_ver_pos;
	wire [9:0] team2_ver_pos;

	reg game_on;
	reg game_over;
	
	wire blue_score_up, red_score_up;
	
	wire button_pressed;
	reg  game_initiated;

	wire [9:0] team1_hor_pos;
	wire [9:0] team2_hor_pos;
	
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS + 'd50), .HOR_POS(240), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY), .TOP_BOUNDARY(276), .BOT_BOUNDARY(510), .BLOCKING_BALL_Y(380))
		team1_ver_ctrl (clk, blue_ver_bludged, team1_vu_button, team1_vd_button, team1_hor_position, team1_ver_pos, blue_ver_clean_wire, blue_ver_bludge_time_wire);
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS - 'd50), .HOR_POS(560),.MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY), .TOP_BOUNDARY(36), .BOT_BOUNDARY(274), .BLOCKING_BALL_Y(180)) 
		team2_ver_ctrl (clk, red_ver_bludged, team2_vu_button, team2_vd_button, team2_hor_position, team2_ver_pos, red_ver_clean_wire, red_ver_bludge_time_wire);
/*
	ball_controller_cansu #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
				ball_ctrl (clk, game_over, team1_ver_position, team2_ver_position,team1_vu_button,team1_vd_button,team2_vu_button,team2_vd_button,team1_hl_button,team1_hr_button,team2_hl_button,team2_hr_button,/*score_to_team1,score_to_team2,*//* x_position,y_position, game_on);
*/	

	/*ball_controller #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
		ball_ctrl (clk, game_initiated, game_over, team1_ver_position, team2_ver_position, team1_hor_position, team2_hor_position, x_position,y_position, blue_score_up, red_score_up);
*/
	
	ball_controller_furkan #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.GOAL_RADIUS(GOAL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
		ball_ctrl (clk, game_initiated, game_over, team1_ver_position, team2_ver_position, team1_hor_position, team2_hor_position, x_position, y_position, blue_score_up, red_score_up);

	bludger_controller #(.PLAYER_RADIUS(PLAYER_RADIUS),.BALL_RADIUS(BALL_RADIUS),.MOVEMENT_FREQUENCY(BALL_MOVEMENT_FREQUENCY))
		bludger_ctrl (clk, game_initiated, blue_ver_clean, blue_hor_clean, red_ver_clean, red_hor_clean,
			team1_ver_position, team2_ver_position, team1_hor_position, team2_hor_position,
				x_bludger, y_bludger, blue_ver_bludged_wire, blue_hor_bludged_wire, red_ver_bludged_wire, red_hor_bludged_wire);
		
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_HOR_POS + 50), .VER_POS(380), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY), .BLOCKING_BALL_X(240))
		team1_hor_ctrl (clk, blue_hor_bludged, team1_hl_button, team1_hr_button, team1_ver_position, team1_hor_pos, blue_hor_clean_wire, blue_hor_bludge_time_wire);
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_HOR_POS - 50), .VER_POS(180), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY), .BLOCKING_BALL_X(560)) 
		team2_hor_ctrl (clk, red_hor_bludged, team2_hl_button, team2_hr_button, team2_ver_position, team2_hor_pos, red_hor_clean_wire, red_hor_bludge_time_wire);
	
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
				counter_clk <= 'd0;
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
		
		bludger_hor_position <= x_bludger;
		bludger_ver_position <= y_bludger;
		
		blue_ver_bludged <= blue_ver_bludged_wire;
		red_ver_bludged  <=  red_ver_bludged_wire;
		blue_hor_bludged <= blue_hor_bludged_wire;
		red_hor_bludged  <=  red_hor_bludged_wire;
		
		blue_ver_bludge_time <= blue_ver_bludge_time_wire;
		red_ver_bludge_time  <=  red_ver_bludge_time_wire;
		blue_hor_bludge_time <= blue_hor_bludge_time_wire;
		red_hor_bludge_time  <=  red_hor_bludge_time_wire;
		
		blue_ver_clean <= blue_ver_clean_wire;
		red_ver_clean  <=  red_ver_clean_wire;
		blue_hor_clean <= blue_hor_clean_wire;
		red_hor_clean  <=  red_hor_clean_wire;
		
		team1_ver_position <= team1_ver_pos;
		team2_ver_position <= team2_ver_pos;
		
		team1_hor_position <= team1_hor_pos;
		team2_hor_position <= team2_hor_pos;
		
		game_initiated <= button_pressed;
	end

endmodule 