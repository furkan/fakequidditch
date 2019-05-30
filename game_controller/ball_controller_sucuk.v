module ball_controller_sucuk #(
	parameter PLAYER_RADIUS,
	parameter BALL_RADIUS,
	parameter GOAL_RADIUS,
	parameter MOVEMENT_FREQUENCY
)
(
	input clk,
	
	input game_initiated,
	input game_over,
	
	input [9:0] team1_ver_pos, // 240
	input [9:0] team2_ver_pos, // 560
	input [9:0] team1_hor_pos, // 380
	input [9:0] team2_hor_pos, // 180
	
	output reg signed [10:0] x_position,
	output reg signed [10:0] y_position,
	
	output reg blue_score_up,
	output reg red_score_up
);

	reg signed [4:0] x_dir, y_dir;
//	reg signed [18:0] m, b, x_bef, y_bef, x_aft, y_aft;
	
	integer counter;
	integer inside_goal     = (GOAL_RADIUS - BALL_RADIUS)   ** 2;
	integer touching_player = (PLAYER_RADIUS + BALL_RADIUS + 2) ** 2;

	reg state;
	
	parameter dead  = 'd0;
	parameter alive = 'd1;
	
	initial begin 
		state      = dead;
		counter    =    0;
		x_position =  400;
		y_position =  275;
		x_dir      =    2;
		y_dir      =    2;
		blue_score_up = 0;
		red_score_up  = 0;
	end

	always @(posedge clk) begin
		if (counter < MOVEMENT_FREQUENCY) begin
			counter <= counter + 'd1;
		end else begin
			counter <= 0;
		end
	end
	
	always @(posedge clk) begin
		if (game_over == 1) begin
			state <= dead;
		end else if (game_initiated == 1) begin
			state <= alive;
		end else if (
			      (((y_position-450)**2)+((x_position-300)**2) < inside_goal) // BLUE GOAL 1
				|| (((y_position-450)**2)+((x_position-400)**2) < inside_goal) // BLUE GOAL 2
				|| (((y_position-450)**2)+((x_position-500)**2) < inside_goal) // BLUE GOAL 3
		) begin
			state <= dead;
			red_score_up <= ~red_score_up;
		end else if (
			      (((y_position-100)**2)+((x_position-300)**2) < inside_goal) // RED  GOAL 1
				|| (((y_position-100)**2)+((x_position-400)**2) < inside_goal) // RED  GOAL 2
				|| (((y_position-100)**2)+((x_position-500)**2) < inside_goal) // RED  GOAL 3
		) begin
		  state <= dead;
		  blue_score_up <= ~blue_score_up;
		end
	end
	
	always @(posedge clk) begin
		
		if (state == dead) begin
			x_position = 400;
			y_position = 275;
		end else if (state == alive && counter == 'd28) begin
			x_position = x_position + x_dir;
			y_position = y_position + y_dir;
		end
		
		// wall collisions
		if ((y_position) < (36 + BALL_RADIUS)) begin // top wall
			y_dir = - y_dir;
			y_position = y_position + 5;
		end else if ((y_position) > (510 - BALL_RADIUS)) begin // bottom wall
			y_dir = - y_dir;
			y_position = y_position - 5;
		end else if ((x_position) < (150 + BALL_RADIUS)) begin // left wall
			x_dir = - x_dir;
			x_position = x_position + 5;
		end else if (x_position > (660 - BALL_RADIUS)) begin // right wall
			x_dir = - x_dir;
			x_position = x_position - 5;
		end
		
/*
		if ((((y_position - team1_ver_pos)**2)+((x_position - 240)**2) < touching_player)) begin
			m = (y_position - team1_ver_pos) / (x_position - 240);
			b = y_position - m * x_position;
			x_bef = x_position - x_dir;
			y_bef = y_position - y_dir;
			x_aft = (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) - x_bef;
			y_aft = m * (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) + 2 * b - x_bef;
			x_dir = x_aft - x_position;
			y_dir = y_aft - y_position;
			x_position = x_aft;
			y_position = y_aft;
		end
		
		if ((((y_position - team2_ver_pos)**2)+((x_position - 560)**2) < touching_player)) begin
			m = (y_position - team2_ver_pos) / (x_position - 560);
			b = y_position - m * x_position;
			x_bef = x_position - x_dir;
			y_bef = y_position - y_dir;
			x_aft = (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) - x_bef;
			y_aft = m * (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) + 2 * b - x_bef;
			x_dir = x_aft - x_position;
			y_dir = y_aft - y_position;
			x_position = x_aft;
			y_position = y_aft;
		end
		
		if ((((y_position - 380)**2)+((x_position - team1_hor_pos)**2) < touching_player)) begin
			m = (y_position - 380) / (x_position - team1_hor_pos);
			b = y_position - m * x_position;
			x_bef = x_position - x_dir;
			y_bef = y_position - y_dir;
			x_aft = (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) - x_bef;
			y_aft = m * (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) + 2 * b - x_bef;
			x_dir = x_aft - x_position;
			y_dir = y_aft - y_position;
			x_position = x_aft;
			y_position = y_aft;
		end
		
		if ((((y_position - 180)**2)+((x_position - team2_hor_pos)**2) < touching_player)) begin
			m = (y_position - 180) / (x_position - team2_hor_pos);
			b = y_position - m * x_position;
			x_bef = x_position - x_dir;
			y_bef = y_position - y_dir;
			x_aft = (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) - x_bef;
			y_aft = m * (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) + 2 * b - x_bef;
			x_dir = x_aft - x_position;
			y_dir = y_aft - y_position;
			x_position = x_aft;
			y_position = y_aft;
		end
*/
	end
endmodule