module ball_controller #(
	parameter PLAYER_RADIUS,		// 35 px works
	parameter BALL_RADIUS,
	parameter GOAL_RADIUS,
	parameter MOVEMENT_FREQUENCY	// inversely proportinal to speed ('d200000 works)
)
(
	input clk,
//	input [9:0] x_position,
//	input [9:0] y_position,
	input [9:0] team1_ver_pos,
// team1_ver_player_hor_pos = 240

//	input [9:0] team1_hor_pos,
	input [9:0] team2_ver_pos,
// team2_ver_player_hor_pos = 560
//	input [9:0] team2_hor_pos,

	input team1_vu_button,
	input team1_vd_button,
	input team2_vu_button,
	input team2_vd_button,
	
	output reg score_to_team1,
	output reg score_to_team2,
	output reg [9:0] x_position,
	output reg [9:0] y_position
);

	reg [4:0] ball_dir_x, ball_dir_y;
	
	integer counter;
	integer inside_goal = (GOAL_RADIUS - BALL_RADIUS) ** 2;

	reg [2:0] state;
	
	parameter dead       = 'd0;
	parameter alive      = 'd1;
	parameter up_right   = 'd2;
	parameter up_left    = 'd3;
	parameter down_left  = 'd4;
	parameter down_right = 'd5;
	
	initial begin 
		state          = dead;
		counter        =    0;
		x_position     =  463;
		y_position     =  275;
		score_to_team1 =    0;
		score_to_team2 =    0;
		ball_dir_x     =    5;
		ball_dir_y     =    5;
	end
	
	always @(posedge clk) begin
		if ((team1_vu_button && team1_vd_button && team2_vu_button && team2_vd_button) == 0) begin
			state = down_right;
		end else if (
			      (((y_position-450)**2)+((x_position-300)**2) < inside_goal) // BLUE GOAL 1
				|| (((y_position-450)**2)+((x_position-400)**2) < inside_goal) // BLUE GOAL 2
				|| (((y_position-450)**2)+((x_position-500)**2) < inside_goal) // BLUE GOAL 3
		) begin
			//state = dead;
			score_to_team2 = 1;
		end else if (
			      (((y_position-100)**2)+((x_position-300)**2) < inside_goal) // RED  GOAL 1
				|| (((y_position-100)**2)+((x_position-400)**2) < inside_goal) // RED  GOAL 2
				|| (((y_position-100)**2)+((x_position-500)**2) < inside_goal) // RED  GOAL 3
		) begin
			//state = dead;
			score_to_team1 = 1;
		end else if (y_position < 36 + BALL_RADIUS) begin
			if (state == up_left) begin
				state = down_left;
			end else begin
				state = down_right;
			end
		end else if (y_position > 510 - BALL_RADIUS) begin
			if (state == down_left) begin
				state = up_left;
			end else begin
				state = up_right;
			end
		end else if (x_position < 150 + BALL_RADIUS) begin
			if (state == down_left) begin
				state = down_right;
			end else begin
				state = up_right;
			end
		end else if (x_position > 680 - BALL_RADIUS) begin
			if (state == down_right) begin
				state = down_left;
			end else begin
				state = up_left;
			end
		end
	end

	always @(posedge clk) begin
		if (counter < MOVEMENT_FREQUENCY) begin
			counter <= counter + 'd1;
		end else begin
			counter <= 0;
		end
	end
	
	always @(posedge clk) begin
		case (state)
			dead: begin
				x_position <= x_position;
				y_position <= y_position;
			end
			alive: begin
				if (counter == 'd98) begin
					x_position <= x_position + ball_dir_x;
					y_position <= y_position + ball_dir_y;
				end
			end
			up_left: begin
				if (counter == 'd98) begin
					x_position <= x_position - ball_dir_x;
					y_position <= y_position - ball_dir_y;
				end
			end
			up_right: begin
				if (counter == 'd98) begin
					x_position <= x_position + ball_dir_x;
					y_position <= y_position - ball_dir_y;
				end
			end
			down_right: begin
				if (counter == 'd98) begin
					x_position <= x_position + ball_dir_x;
					y_position <= y_position + ball_dir_y;
				end
			end
			down_left: begin
				if (counter == 'd98) begin
					x_position <= x_position - ball_dir_x;
					y_position <= y_position + ball_dir_y;
				end
			end
		endcase
	end
	/*
	always @(posedge clk) begin
		if (y_position < 88 + BALL_RADIUS) begin
			ball_dir_y = 5;
		end else if (y_position > 510 - BALL_RADIUS) begin
			ball_dir_y = -5;
		end else if (x_position < 145 + BALL_RADIUS) begin
			ball_dir_x = 5;
		end else if (x_position > 780 - BALL_RADIUS) begin
			ball_dir_x = -5;
		end
	end
	*/
/*
	reg [30:0] x_positions;
	reg [30:0] y_positions;
	
	initial begin
		x_positions = {10'b0 + 'd463, 10'b0 + 'd463, 10'b0 + 463};
		y_positions = {10'b0 + 'd275, 10'b0 + 'd275, 10'b0 + 275};
	end
	always @(posedge clk) begin
		x_positions <= x_positions << 'd10 + x_position;
		y_positions <= y_positions << 'd10 + y_position;
	end
*/

endmodule