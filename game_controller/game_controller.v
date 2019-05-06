module game_controller #(
	parameter PLAYER_RADIUS,
	parameter INITIAL_VER_POS,
	parameter INITIAL_TEAM1_HOR_POS,
	parameter INITIAL_TEAM2_HOR_POS,
	parameter PLAYER_MOVEMENT_FREQUENCY
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
	
	output reg [9:0] team1_ver_position,
	output reg [9:0] team2_ver_position
	
	/*
	output reg [9:0] team1_hor_position,
	output reg [9:0] team2_hor_position,
	*/
);

	wire [9:0] team1_ver_pos;
	wire [9:0] team2_ver_pos;
	
//	wire [9:0] team1_hor_pos;
//	wire [9:0] team2_hor_pos;
	
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
				team1_ver_ctrl (clk, team1_vu_button, team1_vd_button, team1_ver_pos);
	ver_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_VER_POS(INITIAL_VER_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
				team2_ver_ctrl (clk, team2_vu_button, team2_vd_button, team2_ver_pos);

/*
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_TEAM1_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY))
				team1_ver_ctrl (clk, team1_hl_button, team1_hr_button, team1_hor_pos);
	hor_player_controller #(.PLAYER_RADIUS(PLAYER_RADIUS), .INITIAL_HOR_POS(INITIAL_TEAM2_HOR_POS), .MOVEMENT_FREQUENCY(PLAYER_MOVEMENT_FREQUENCY)) 
				team2_ver_ctrl (clk, team2_hl_button, team2_hr_button, team2_hor_pos);			
*/
	
//	team1_controller t1_ctrl (clk, team1_vu_button, team1_vd_button, team1_ver_pos);

//	team2_controller t2_ctrl (clk, team2_vu_button, team2_vd_button, team2_ver_pos);
	
	always begin
		team1_ver_position <= team1_ver_pos;
		team2_ver_position <= team2_ver_pos;
		
//		team1_hor_position <= team1_hor_pos;
//		team2_hor_position <= team2_hor_pos;
	end

endmodule