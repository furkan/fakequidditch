module bludger_controller #(
	parameter PLAYER_RADIUS,
	parameter BALL_RADIUS,
	parameter MOVEMENT_FREQUENCY
)
(
	input clk,
	
	input game_initiated,
	
	input blue_ver_clean,
	input blue_hor_clean,
	input  red_ver_clean,
	input  red_hor_clean,
	
	input [9:0] team1_ver_pos, // 240
	input [9:0] team2_ver_pos, // 560
	input [9:0] team1_hor_pos, // 370
	input [9:0] team2_hor_pos, // 180
	
	output reg signed [10:0] x_position,
	output reg signed [10:0] y_position,
	
	output reg blue_ver_bludged,
	output reg blue_hor_bludged,
	output reg  red_ver_bludged,
	output reg  red_hor_bludged
);

	reg signed [4:0] x_dir, y_dir;
	
	integer counter;
	integer touching_player = (PLAYER_RADIUS + BALL_RADIUS + 2) ** 2;
	wire random;
	
	assign random = (team1_hor_pos + team2_hor_pos + team1_ver_pos + team2_ver_pos + x_position + y_position) % 2;
	
	reg state;
	
	parameter dead  = 1'b0;
	parameter alive = 1'b1;
	
	initial begin 
		state      = dead;
		counter    =    0;
		x_position =  450;
		y_position =  275;
		x_dir      =    2;
		y_dir      =    2;
	end
	
	always @(posedge clk) begin
		if (counter < MOVEMENT_FREQUENCY) begin
			counter <= counter + 'd1;
		end else begin
			counter <= 0;
		end
	end
	
	always @(posedge clk) begin
		if (game_initiated == 1) begin
			state <= alive;
		end
	end
	
	always @(posedge clk) begin
	
		if (blue_ver_clean == 1) blue_ver_bludged <= 0;
		if (blue_hor_clean == 1) blue_hor_bludged <= 0;
		if (red_ver_clean  == 1) red_ver_bludged <= 0;
		if (red_hor_clean  == 1) red_hor_bludged <= 0;
		
		if (state == dead) begin
			x_position <= 450;
			y_position <= 275;
		end else if (state == alive && counter == 'd28) begin
			x_position <= x_position + x_dir;
			y_position <= y_position + y_dir;
		end
		
		// wall collisions
		if ((y_position) < (36 + BALL_RADIUS)) begin // top wall
			y_dir <= - y_dir;
			y_position <= y_position + 5;
			if (random == 1) x_dir <= -x_dir;
		end else if ((y_position) > (510 - BALL_RADIUS)) begin // bottom wall
			y_dir <= - y_dir;
			y_position <= y_position - 5;
			if (random == 1) x_dir <= -x_dir;
		end else if ((x_position) < (150 + BALL_RADIUS)) begin // left wall
			x_dir <= - x_dir;
			x_position <= x_position + 5;
			if (random == 1) y_dir <= -y_dir;
		end else if (x_position > (660 - BALL_RADIUS)) begin // right wall
			x_dir <= - x_dir;
			x_position <= x_position - 5;
			if (random == 1) y_dir <= -y_dir;
		end
		
		// ball collisions blue vertical
		if ((((y_position - team1_ver_pos)**2)+((x_position - 240)**2) < touching_player)) begin
			blue_ver_bludged <= 1;
			if (x_position > 240 + 32) begin // east side
				x_dir <= - x_dir;
				x_position <= x_position + 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (x_position < 240 - 32) begin // west side
				x_dir <= - x_dir;
				x_position <= x_position - 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (y_position > team1_ver_pos + 32) begin // south side
				y_dir <= - y_dir;
				y_position <= y_position + 5;
				if (random == 1) x_dir <= -x_dir;
			end else if (y_position < team1_ver_pos - 32) begin // north side
				y_dir <= - y_dir;
				y_position <= y_position - 5;
				if (random == 1) x_dir <= -x_dir;
			end else begin
				if ((x_position > 240) && (y_position < team1_ver_pos)) begin // northeast side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position + 5;
					y_position <= y_position - 5;
				end else if ((x_position > 240) && (y_position > team1_ver_pos)) begin // southeast side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position + 5;
					y_position <= y_position + 5;
				end else if ((x_position < 240) && (y_position > team1_ver_pos)) begin // southwest side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position - 5;
					y_position <= y_position + 5;
				end else if ((x_position < 240) && (y_position < team1_ver_pos)) begin // northwest side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position - 5;
					y_position <= y_position - 5;
				end
			end
		end
		
		// ball collisions blue horizontal
		if ((((y_position - 370)**2)+((x_position - team1_hor_pos)**2) < touching_player)) begin
			blue_hor_bludged <= 1;
			if (x_position > team1_hor_pos + 32) begin // east side
				x_dir <= - x_dir;
				x_position <= x_position + 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (x_position < team1_hor_pos - 32) begin // west side
				x_dir <= - x_dir;
				x_position <= x_position - 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (y_position > 370 + 32) begin // south side
				y_dir <= - y_dir;
				y_position <= y_position + 5;
				if (random == 1) x_dir <= -x_dir;
			end else if (y_position < 370 - 32) begin // north side
				y_dir <= - y_dir;
				y_position <= y_position - 5;
				if (random == 1) x_dir <= -x_dir;
			end else begin
				if ((x_position > team1_hor_pos) && (y_position < 370)) begin // northeast side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position + 5;
					y_position <= y_position - 5;
				end else if ((x_position > team1_hor_pos) && (y_position > 370)) begin // southeast side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position + 5;
					y_position <= y_position + 5;
				end else if ((x_position < team1_hor_pos) && (y_position > 370)) begin // southwest side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position - 5;
					y_position <= y_position + 5;
				end else if ((x_position < team1_hor_pos) && (y_position < 370)) begin // northwest side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position - 5;
					y_position <= y_position - 5;
				end
			end
		end
		
		// ball collisions red vertical
		if ((((y_position - team2_ver_pos)**2)+((x_position - 560)**2) < touching_player)) begin
			red_ver_bludged <= 1;
			if (x_position > 560 + 32) begin // east side
				x_dir <= - x_dir;
				x_position <= x_position + 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (x_position < 560 - 32) begin // west side
				x_dir <= - x_dir;
				x_position <= x_position - 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (y_position > team2_ver_pos + 32) begin // south side
				y_dir <= - y_dir;
				y_position <= y_position + 5;
				if (random == 1) x_dir <= -x_dir;
			end else if (y_position < team2_ver_pos - 32) begin // north side
				y_dir <= - y_dir;
				y_position <= y_position - 5;
				if (random == 1) x_dir <= -x_dir;
			end else begin
				if ((x_position > 560) && (y_position < team2_ver_pos)) begin // northeast side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position + 5;
					y_position <= y_position - 5;
				end else if ((x_position > 560) && (y_position > team2_ver_pos)) begin // southeast side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position + 5;
					y_position <= y_position + 5;
				end else if ((x_position < 560) && (y_position > team2_ver_pos)) begin // southwest side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position - 5;
					y_position <= y_position + 5;
				end else if ((x_position < 560) && (y_position < team2_ver_pos)) begin // northwest side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position - 5;
					y_position <= y_position - 5;
				end
			end
		end
		
		// ball collisions red horizontal
		if ((((y_position - 180)**2)+((x_position - team2_hor_pos)**2) < touching_player)) begin
			red_hor_bludged <= 1;
			if (x_position > team2_hor_pos + 32) begin // east side
				x_dir <= - x_dir;
				x_position <= x_position + 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (x_position < team2_hor_pos - 32) begin // west side
				x_dir <= - x_dir;
				x_position <= x_position - 5;
				if (random == 1) y_dir <= -y_dir;
			end else if (y_position > 180 + 32) begin // south side
				y_dir <= - y_dir;
				y_position <= y_position + 5;
				if (random == 1) x_dir <= -x_dir;
			end else if (y_position < 180 - 32) begin // north side
				y_dir <= - y_dir;
				y_position <= y_position - 5;
				if (random == 1) x_dir <= -x_dir;
			end else begin
				if ((x_position > team2_hor_pos) && (y_position < 180)) begin // northeast side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position + 5;
					y_position <= y_position - 5;
				end else if ((x_position > team2_hor_pos) && (y_position > 180)) begin // southeast side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position + 5;
					y_position <= y_position + 5;
				end else if ((x_position < team2_hor_pos) && (y_position > 180)) begin // southwest side
					x_dir <= y_dir;
					y_dir <= x_dir;
					x_position <= x_position - 5;
					y_position <= y_position + 5;
				end else if ((x_position < team2_hor_pos) && (y_position < 180)) begin // northwest side
					x_dir <= -y_dir;
					y_dir <= -x_dir;
					x_position <= x_position - 5;
					y_position <= y_position - 5;
				end
			end
		end		
	end
endmodule