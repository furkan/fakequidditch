module ball_controller_reflection #(
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
	
	output reg signed [18:0] x_position,
	output reg signed [18:0] y_position,
	
	output reg blue_score_up,
	output reg red_score_up
);

	reg signed [18:0] x_dir, y_dir;
	
	wire [18:0] blue_ver_pos_x;
	wire [18:0] blue_ver_pos_y;
	wire [18:0] blue_ver_dir_x;
	wire [18:0] blue_ver_dir_y;
	
	wire [18:0] red_ver_pos_x;
	wire [18:0] red_ver_pos_y;
	wire [18:0] red_ver_dir_x;
	wire [18:0] red_ver_dir_y;
	
	wire [18:0] blue_hor_pos_x;
	wire [18:0] blue_hor_pos_y;
	wire [18:0] blue_hor_dir_x;
	wire [18:0] blue_hor_dir_y;
	
	wire [18:0] red_hor_pos_x;
	wire [18:0] red_hor_pos_y;
	wire [18:0] red_hor_dir_x;
	wire [18:0] red_hor_dir_y;
	
	integer counter;
	integer inside_goal     = (GOAL_RADIUS - BALL_RADIUS)   ** 2;
	integer touching_player = (PLAYER_RADIUS + BALL_RADIUS + 2) ** 2;
	
	wire inside_blue_goal, inside_red_goal;
	
	assign inside_blue_goal = (
			      (((y_position-470)**2)+((x_position-300)**2) < inside_goal)
				|| (((y_position-430)**2)+((x_position-400)**2) < inside_goal)
				|| (((y_position-470)**2)+((x_position-500)**2) < inside_goal)) ? 1 : 0 ;
				
	assign inside_red_goal = (
			      (((y_position-80)**2)+((x_position-300)**2) < inside_goal)
				|| (((y_position-120)**2)+((x_position-400)**2) < inside_goal)
				|| (((y_position-80)**2)+((x_position-500)**2) < inside_goal)) ? 1 : 0 ;
				
	player_ball_collider blue_ver_collider (.old_ball_x(x_position), .old_ball_y(y_position), .player_x(240), .player_y(team1_ver_pos), .old_ball_dir_x(x_dir), .old_ball_dir_y(y_dir),
								.new_ball_x(blue_ver_pos_x), .new_ball_y(blue_ver_pos_y), .new_ball_dir_x(blue_ver_dir_x), .new_ball_dir_y(blue_ver_dir_y));
	player_ball_collider blue_hor_collider (.old_ball_x(x_position), .old_ball_y(y_position), .player_x(240), .player_y(team1_ver_pos), .old_ball_dir_x(x_dir), .old_ball_dir_y(y_dir),
								.new_ball_x(blue_hor_pos_x), .new_ball_y(blue_hor_pos_y), .new_ball_dir_x(blue_hor_dir_x), .new_ball_dir_y(blue_hor_dir_y));
	player_ball_collider  red_ver_collider (.old_ball_x(x_position), .old_ball_y(y_position), .player_x(240), .player_y(team1_ver_pos), .old_ball_dir_x(x_dir), .old_ball_dir_y(y_dir),
								.new_ball_x(red_ver_pos_x), .new_ball_y(red_ver_pos_y), .new_ball_dir_x(red_ver_dir_x), .new_ball_dir_y(red_ver_dir_y));
	player_ball_collider  red_hor_collider (.old_ball_x(x_position), .old_ball_y(y_position), .player_x(240), .player_y(team1_ver_pos), .old_ball_dir_x(x_dir), .old_ball_dir_y(y_dir),
								.new_ball_x(red_hor_pos_x), .new_ball_y(red_hor_pos_y), .new_ball_dir_x(red_hor_dir_x), .new_ball_dir_y(red_hor_dir_y));

	reg state;
	
	parameter dead  = 1'b0;
	parameter alive = 1'b1;
	
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
		end else if (inside_blue_goal) begin
			state <= dead;
			red_score_up <= ~red_score_up;
		end else if (inside_red_goal) begin
		  state <= dead;
		  blue_score_up <= ~blue_score_up;
		end else if (game_initiated == 1) begin
			state <= alive;
		end
	end
	
	always @(posedge clk) begin
		
		if (state == dead) begin
			x_position <= 400;
			y_position <= 275;
		end else if (state == alive && counter == 'd28) begin
			x_position <= x_position + x_dir;
			y_position <= y_position + y_dir;
		end
		
		// wall collisions
		if ((y_position) < (36 + BALL_RADIUS)) begin // top wall
			y_dir <= - y_dir;
			y_position <= y_position + 5;
		end else if ((y_position) > (510 - BALL_RADIUS)) begin // bottom wall
			y_dir <= - y_dir;
			y_position <= y_position - 5;
		end else if ((x_position) < (150 + BALL_RADIUS)) begin // left wall
			x_dir <= - x_dir;
			x_position <= x_position + 5;
		end else if (x_position > (660 - BALL_RADIUS)) begin // right wall
			x_dir <= - x_dir;
			x_position <= x_position - 5;
		end
		
		if ((((y_position - team1_ver_pos)**2)+((x_position - 240)**2) < touching_player)) begin // blue ver player
			x_position <= blue_ver_pos_x;
			y_position <= blue_ver_pos_y;
			x_dir      <= blue_ver_dir_x;
			y_dir      <= blue_ver_dir_y;
		end
		
		if ((((y_position - team2_ver_pos)**2)+((x_position - 560)**2) < touching_player)) begin // blue ver player
			x_position <= red_ver_pos_x;
			y_position <= red_ver_pos_y;
			x_dir      <= red_ver_dir_x;
			y_dir      <= red_ver_dir_y;
		end
		
		if ((((y_position - 380)**2)+((x_position - team1_hor_pos)**2) < touching_player)) begin // blue ver player
			x_position <= blue_hor_pos_x;
			y_position <= blue_hor_pos_y;
			x_dir      <= blue_hor_dir_x;
			y_dir      <= blue_hor_dir_y;
		end
		
		if ((((y_position - 180)**2)+((x_position - team2_hor_pos)**2) < touching_player)) begin // blue ver player
			x_position <= red_hor_pos_x;
			y_position <= red_hor_pos_y;
			x_dir      <= red_hor_dir_x;
			y_dir      <= red_hor_dir_y;
		end
	end
endmodule