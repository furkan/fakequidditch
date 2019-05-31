module vga_controller #(
	parameter PLAYER_RADIUS,		// 25 px
	parameter GOAL_RADIUS,			// 40 px
	parameter BALL_RADIUS,     	//  5 px
	parameter BLUDGER_RADIUS		//  5 px
)
(	input clk,
	input vga_clk,
	
	input wire [9:0] team1_ver_pos,
	input wire [9:0] team2_ver_pos,
	input wire [9:0] team1_hor_pos,
	input wire [9:0] team2_hor_pos,

	input wire [10:0] ball_x,
	input wire [10:0] ball_y,
	
	input wire [10:0] ball_x,
	input wire [10:0] ball_y,

	input [7:0] left_seconds,

	input [6:0] team1_score,
	input [6:0] team2_score,
	
	output wire hor_sync,
	output wire ver_sync,
	output reg [7:0] red,
	output reg [7:0] green,
	output reg [7:0] blue
);

	assign hor_sync = (x  > 95) ? 1'b1 : 1'b0;
	assign ver_sync = (y  >  1) ? 1'b1 : 1'b0;

	parameter BLUE_GOAL1_X = 300;
	parameter BLUE_GOAL1_Y = 450;
	parameter BLUE_GOAL2_X = 400;
	parameter BLUE_GOAL2_Y = 450;
	parameter BLUE_GOAL3_X = 500;
	parameter BLUE_GOAL3_Y = 450;

	parameter RED_GOAL1_X  = 300;
	parameter RED_GOAL1_Y  = 100;
	parameter RED_GOAL2_X  = 400;
	parameter RED_GOAL2_Y  = 100;
	parameter RED_GOAL3_X  = 500;
	parameter RED_GOAL3_Y  = 100;
	
	wire blue_goals, red_goals, blue_players, red_players, ball, border, half_line;
	
	assign blue_goals = (
		   ((((y-BLUE_GOAL1_Y)**2)+((x-BLUE_GOAL1_X)**2) < (GOAL_RADIUS + 2)**2)
		 && (((y-BLUE_GOAL1_Y)**2)+((x-BLUE_GOAL1_X)**2) > (GOAL_RADIUS - 2)**2))
		 ||((((y-BLUE_GOAL2_Y)**2)+((x-BLUE_GOAL2_X)**2) < (GOAL_RADIUS + 2)**2)
		 && (((y-BLUE_GOAL2_Y)**2)+((x-BLUE_GOAL2_X)**2) > (GOAL_RADIUS - 2)**2))
		 ||((((y-BLUE_GOAL3_Y)**2)+((x-BLUE_GOAL3_X)**2) < (GOAL_RADIUS + 2)**2)
		 && (((y-BLUE_GOAL3_Y)**2)+((x-BLUE_GOAL3_X)**2) > (GOAL_RADIUS - 2)**2))) ? 1: 0; // b
		 
	assign red_goals = (
		   ((((y-RED_GOAL1_Y)**2)+((x-RED_GOAL1_X)**2) < (GOAL_RADIUS + 2)**2)
		 && (((y-RED_GOAL1_Y)**2)+((x-RED_GOAL1_X)**2) > (GOAL_RADIUS - 2)**2))
		 ||((((y-RED_GOAL2_Y)**2)+((x-RED_GOAL2_X)**2) < (GOAL_RADIUS + 2)**2)
		 && (((y-RED_GOAL2_Y)**2)+((x-RED_GOAL2_X)**2) > (GOAL_RADIUS - 2)**2))
		 ||((((y-RED_GOAL3_Y)**2)+((x-RED_GOAL3_X)**2) < (GOAL_RADIUS + 2)**2)
		 && (((y-RED_GOAL3_Y)**2)+((x-RED_GOAL3_X)**2) > (GOAL_RADIUS - 2)**2))) ? 1 : 0; // r
		 
	assign blue_players =(
	      (((y - team1_ver_pos)**2) + ((x - 240)**2) < PLAYER_RADIUS ** 2)
		 ||(((y - 380)**2) + ((x - team1_hor_pos)**2) < PLAYER_RADIUS ** 2)) ? 1 : 0; // b
		 
	assign red_players =(
	      (((y - team2_ver_pos)**2) + ((x - 560)**2) < PLAYER_RADIUS ** 2)
		 ||(((y - 180)**2) + ((x - team2_hor_pos)**2) < PLAYER_RADIUS ** 2)) ? 1 : 0; // r
		 
	assign ball = (((y - ball_y)**2) + ((x - ball_x)**2) < BALL_RADIUS ** 2) ? 1 : 0; // rb
	
	assign bludger = (((y - bludger_y)**2) + ((x - bludger_x)**2) < BLUDGER_RADIUS ** 2) ? 1 : 0; // rg
	
	assign border = (x == 144 || x == 659 || y == 35 || y == 513) ? 1 : 0; // rgb
	
	assign half_line = (y == 275) ? 1 : 0; // rgb
		

	parameter MINUTE_POSITION_X = 680;
	parameter MINUTE_POSITION_Y = 275;

	parameter SECOND_TENS_POSITION_X = 728;
	parameter SECOND_TENS_POSITION_Y = 275;

	parameter SECOND_ONES_POSITION_X = 765;
	parameter SECOND_ONES_POSITION_Y = 275;
	
	parameter BLUE_SCORE_TENS_POSITION_X = 676;
	parameter BLUE_SCORE_TENS_POSITION_Y = 100;
	
	parameter BLUE_SCORE_ONES_POSITION_X = 698;
	parameter BLUE_SCORE_ONES_POSITION_Y = 100;
	
	parameter RED_SCORE_TENS_POSITION_X = 738;
	parameter RED_SCORE_TENS_POSITION_Y = 100;
	
	parameter RED_SCORE_ONES_POSITION_X = 762;
	parameter RED_SCORE_ONES_POSITION_Y = 100;

	reg next_line;
	reg [9:0] x;
	reg [9:0] y;

	wire [3:0] left_minute;
	wire [3:0] left_second_tens;
	wire [3:0] left_second_ones;
	
	wire [3:0] blue_score_tens;
	wire [3:0] blue_score_ones;
	wire [3:0] red_score_tens;
	wire [3:0] red_score_ones;

	assign left_minute = left_seconds / 60;
	assign left_second_tens = (left_seconds % 60) / 10;
	assign left_second_ones = (left_seconds % 60) % 10;
	
	assign blue_score_tens = (team1_score / 2) / 10;
	assign blue_score_ones = (team1_score / 2) % 10;
	assign red_score_tens  = (team2_score / 2) / 10;
	assign red_score_ones  = (team2_score / 2) % 10;

	initial begin
		x = 0;
		y = 0;
		next_line = 0;
	end

	always @(posedge clk) begin
		if (vga_clk==1) begin
			if (x < 799) begin
				x <= x + 1;
				next_line <= 0;
			end else begin
				x <= 0;
				next_line <= 1;
			end
		end
	end

	always @(posedge clk) begin
		if (vga_clk) begin
			if (next_line == 1) begin
				if (y < 524) begin
					y <= y + 1;
				end else begin
					y <= 0;
				end
			end
		end
	end

	always @(posedge clk) begin
		if (x < 784 && x > 143 && y < 515 && y > 34) begin		// the active region
		
			if (x < 660) begin		// field
				if (red_goals || red_players || border || half_line || ball) red = 8'b11111111;
				else red = 8'b00000000;
				if (blue_goals || blue_players || border || half_line || ball) blue = 8'b11111111;
				else blue = 8'b00000000;
				if (border || half_line) green = 8'b11111111;
				else green = 8'b00000000;
				
			end else if (x == 660) begin // separator between field and board // unnecessary else block
				red   = 8'b00000000;
				green = 8'b00000000;
				blue  = 8'b00000000;
				
			end else begin // board
				red   = 8'b10000000;
				green = 8'b11111111;
				blue  = 8'b10101010;
				
				// minute second separator
				if ((x <= 706 && x>= 702 && y <= 277 && y >= 273) || (x <= 706 && x>= 702 && y <= 267 && y >= 263)) begin
					red   = 8'b00000000;
					green = 8'b00000000;
					blue  = 8'b00000000;
				end
				
				// score team separator
				if ((y <= 100 + 1) && (y >= 100 - 1) && x >= 711 && x<= 725) begin
					blue  = 16 * (726 - x) + 15;
					red   = 16 * (x - 710) + 15;
					green = 8'b00000000;
				end				
				
				if (!(left_minute == 'd1 || left_minute == 'd4)) begin
					if ((y <= (MINUTE_POSITION_Y - 28) && y >= (MINUTE_POSITION_Y - 32)) && (x <= (MINUTE_POSITION_X + 12) && x >= (MINUTE_POSITION_X - 12))) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_minute == 'd5 || left_minute == 'd6)) begin
					if (((y <= MINUTE_POSITION_Y - 3) && y >= (MINUTE_POSITION_Y - 27)) && ((x <= (MINUTE_POSITION_X + 17)) && x >= (MINUTE_POSITION_X + 13))) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_minute == 'd2)) begin
					if (((y <= MINUTE_POSITION_Y + 27) && (y >= MINUTE_POSITION_Y + 3)) && (x <= MINUTE_POSITION_X + 17 && x >= MINUTE_POSITION_X + 13)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_minute == 'd1 || left_minute == 'd4 || left_minute == 'd7)) begin
					if ((y <= MINUTE_POSITION_Y + 32 && y >= MINUTE_POSITION_Y + 28) && (x <= MINUTE_POSITION_X + 12 && x >= MINUTE_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if ((left_minute == 'd0 || left_minute == 'd2 || left_minute == 'd6 || left_minute == 'd8)) begin
					if ((y <= MINUTE_POSITION_Y + 27 && y >= MINUTE_POSITION_Y + 3) && (x <= MINUTE_POSITION_X - 13 && x >= MINUTE_POSITION_X - 17)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_minute == 'd1 || left_minute == 'd2 || left_minute == 'd3 || left_minute == 'd7)) begin
					if ((y <= (MINUTE_POSITION_Y - 3) && y >= (MINUTE_POSITION_Y - 27)) && (x <= (MINUTE_POSITION_X - 13) && x >= (MINUTE_POSITION_X - 17))) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_minute == 'd0 || left_minute == 'd1 || left_minute == 'd7)) begin
					if ((y <= (MINUTE_POSITION_Y + 2) && y >= (MINUTE_POSITION_Y - 2)) && (x <= MINUTE_POSITION_X + 12 && x >= MINUTE_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end

				if (!(left_second_tens == 'd1 || left_second_tens == 'd4)) begin
					if ((y <= SECOND_TENS_POSITION_Y - 28 && y >= SECOND_TENS_POSITION_Y - 32) && (x <= SECOND_TENS_POSITION_X + 12 && x >= SECOND_TENS_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_tens == 'd5 || left_second_tens == 'd6)) begin
					if ((y <= SECOND_TENS_POSITION_Y - 3 && y >= SECOND_TENS_POSITION_Y - 27) && (x <= SECOND_TENS_POSITION_X + 17 && x >= SECOND_TENS_POSITION_X + 13)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_tens == 'd2)) begin
					if ((y <= SECOND_TENS_POSITION_Y + 27 && y >= SECOND_TENS_POSITION_Y + 3) && (x <= SECOND_TENS_POSITION_X + 17 && x >= SECOND_TENS_POSITION_X + 13)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_tens == 'd1 || left_second_tens == 'd4 || left_second_tens == 'd7)) begin
					if ((y <= SECOND_TENS_POSITION_Y + 32 && y >= SECOND_TENS_POSITION_Y + 28) && (x <= SECOND_TENS_POSITION_X + 12 && x >= SECOND_TENS_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if ((left_second_tens == 'd0 || left_second_tens == 'd2 || left_second_tens == 'd6 || left_second_tens == 'd8)) begin
					if ((y <= SECOND_TENS_POSITION_Y + 27 && y >= SECOND_TENS_POSITION_Y + 3) && (x <= SECOND_TENS_POSITION_X - 13 && x >= SECOND_TENS_POSITION_X - 17)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_tens == 'd1 || left_second_tens == 'd2 || left_second_tens == 'd3 || left_second_tens == 'd7)) begin
					if ((y <= SECOND_TENS_POSITION_Y - 3 && y >= SECOND_TENS_POSITION_Y - 27) && (x <= SECOND_TENS_POSITION_X - 13 && x >= SECOND_TENS_POSITION_X - 17)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_tens == 'd0 || left_second_tens == 'd1 || left_second_tens == 'd7)) begin
					if ((y <= SECOND_TENS_POSITION_Y + 2 && y >= SECOND_TENS_POSITION_Y - 2) && (x <= SECOND_TENS_POSITION_X + 12 && x >= SECOND_TENS_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end

				if (!(left_second_ones == 'd1 || left_second_ones == 'd4)) begin
					if ((y <= SECOND_ONES_POSITION_Y - 28 && y >= SECOND_ONES_POSITION_Y - 32) && (x <= SECOND_ONES_POSITION_X + 12 && x >= SECOND_ONES_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_ones == 'd5 || left_second_ones == 'd6)) begin
					if ((y <= SECOND_ONES_POSITION_Y - 3 && y >= SECOND_ONES_POSITION_Y - 27) && (x <= SECOND_ONES_POSITION_X + 17 && x >= SECOND_ONES_POSITION_X + 13)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_ones == 'd2)) begin
					if ((y <= SECOND_ONES_POSITION_Y + 27 && y >= SECOND_ONES_POSITION_Y + 3) && (x <= SECOND_ONES_POSITION_X + 17 && x >= SECOND_ONES_POSITION_X + 13)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_ones == 'd1 || left_second_ones == 'd4 || left_second_ones == 'd7)) begin
					if ((y <= SECOND_ONES_POSITION_Y + 32 && y >= SECOND_ONES_POSITION_Y + 28) && (x <= SECOND_ONES_POSITION_X + 12 && x >= SECOND_ONES_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if ((left_second_ones == 'd0 || left_second_ones == 'd2 || left_second_ones == 'd6 || left_second_ones == 'd8)) begin
					if ((y <= SECOND_ONES_POSITION_Y + 27 && y >= SECOND_ONES_POSITION_Y + 3) && (x <= SECOND_ONES_POSITION_X - 13 && x >= SECOND_ONES_POSITION_X - 17)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_ones == 'd1 || left_second_ones == 'd2 || left_second_ones == 'd3 || left_second_ones == 'd7)) begin
					if ((y <= SECOND_ONES_POSITION_Y - 3 && y >= SECOND_ONES_POSITION_Y - 27) && (x <= SECOND_ONES_POSITION_X - 13 && x >= SECOND_ONES_POSITION_X - 17)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(left_second_ones == 'd0 || left_second_ones == 'd1 || left_second_ones == 'd7)) begin
					if ((y <= SECOND_ONES_POSITION_Y + 2 && y >= SECOND_ONES_POSITION_Y - 2) && (x <= SECOND_ONES_POSITION_X + 12 && x >= SECOND_ONES_POSITION_X - 12)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end
				
				if (!(blue_score_tens == 'd1 || blue_score_tens == 'd4)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y - 17 && y >= BLUE_SCORE_TENS_POSITION_Y - 19) && (x <= BLUE_SCORE_TENS_POSITION_X + 7 && x >= BLUE_SCORE_TENS_POSITION_X - 7)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_tens == 'd5 || blue_score_tens == 'd6)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y - 2 && y >= BLUE_SCORE_TENS_POSITION_Y - 16) && (x <= BLUE_SCORE_TENS_POSITION_X + 10 && x >= BLUE_SCORE_TENS_POSITION_X + 8)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_tens == 'd2)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y + 16 && y >= BLUE_SCORE_TENS_POSITION_Y + 2) && (x <= BLUE_SCORE_TENS_POSITION_X + 10 && x >= BLUE_SCORE_TENS_POSITION_X + 8)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_tens == 'd1 || blue_score_tens == 'd4 || blue_score_tens == 'd7)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y + 19 && y >= BLUE_SCORE_TENS_POSITION_Y + 17) && (x <= BLUE_SCORE_TENS_POSITION_X + 7 && x >= BLUE_SCORE_TENS_POSITION_X - 7)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if ((blue_score_tens == 'd0 || blue_score_tens == 'd2 || blue_score_tens == 'd6 || blue_score_tens == 'd8)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y + 16 && y >= BLUE_SCORE_TENS_POSITION_Y + 2) && (x <= BLUE_SCORE_TENS_POSITION_X - 8 && x >= BLUE_SCORE_TENS_POSITION_X - 10)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_tens == 'd1 || blue_score_tens == 'd2 || blue_score_tens == 'd3 || blue_score_tens == 'd7)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y - 2 && y >= BLUE_SCORE_TENS_POSITION_Y - 16) && (x <= BLUE_SCORE_TENS_POSITION_X - 8 && x >= BLUE_SCORE_TENS_POSITION_X - 10)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_tens == 'd0 || blue_score_tens == 'd1 || blue_score_tens == 'd7)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y + 1 && y >= BLUE_SCORE_TENS_POSITION_Y - 1) && (x <= BLUE_SCORE_TENS_POSITION_X + 7 && x >= BLUE_SCORE_TENS_POSITION_X - 7)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end
				
				if (!(blue_score_ones == 'd1 || blue_score_ones == 'd4)) begin
					if ((y <= BLUE_SCORE_ONES_POSITION_Y - 17 && y >= BLUE_SCORE_ONES_POSITION_Y - 19) && (x <= BLUE_SCORE_ONES_POSITION_X + 7 && x >= BLUE_SCORE_ONES_POSITION_X - 7)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_ones == 'd5 || blue_score_ones == 'd6)) begin
					if ((y <= BLUE_SCORE_ONES_POSITION_Y - 2 && y >= BLUE_SCORE_ONES_POSITION_Y - 16) && (x <= BLUE_SCORE_ONES_POSITION_X + 10 && x >= BLUE_SCORE_ONES_POSITION_X + 8)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_ones == 'd2)) begin
					if ((y <= BLUE_SCORE_ONES_POSITION_Y + 16 && y >= BLUE_SCORE_ONES_POSITION_Y + 2) && (x <= BLUE_SCORE_ONES_POSITION_X + 10 && x >= BLUE_SCORE_ONES_POSITION_X + 8)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_ones == 'd1 || blue_score_ones == 'd4 || blue_score_ones == 'd7)) begin
					if ((y <= BLUE_SCORE_ONES_POSITION_Y + 19 && y >= BLUE_SCORE_ONES_POSITION_Y + 17) && (x <= BLUE_SCORE_ONES_POSITION_X + 7 && x >= BLUE_SCORE_ONES_POSITION_X - 7)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if ((blue_score_ones == 'd0 || blue_score_ones == 'd2 || blue_score_ones == 'd6 || blue_score_ones == 'd8)) begin
					if ((y <= BLUE_SCORE_ONES_POSITION_Y + 16 && y >= BLUE_SCORE_ONES_POSITION_Y + 2) && (x <= BLUE_SCORE_ONES_POSITION_X - 8 && x >= BLUE_SCORE_ONES_POSITION_X - 10)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_ones == 'd1 || blue_score_ones == 'd2 || blue_score_ones == 'd3 || blue_score_ones == 'd7)) begin
					if ((y <= BLUE_SCORE_ONES_POSITION_Y - 2 && y >= BLUE_SCORE_ONES_POSITION_Y - 16) && (x <= BLUE_SCORE_ONES_POSITION_X - 8 && x >= BLUE_SCORE_ONES_POSITION_X - 10)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end if (!(blue_score_ones == 'd0 || blue_score_ones == 'd1 || blue_score_ones == 'd7)) begin
					if ((y <= BLUE_SCORE_ONES_POSITION_Y + 1 && y >= BLUE_SCORE_ONES_POSITION_Y - 1) && (x <= BLUE_SCORE_ONES_POSITION_X + 7 && x >= BLUE_SCORE_ONES_POSITION_X - 7)) begin
						red   = 8'b00000000;
						green = 8'b00000000;
						blue  = 8'b11111111;
					end
				end
				
				if (!(red_score_tens == 'd1 || red_score_tens == 'd4)) begin
					if ((y <= RED_SCORE_TENS_POSITION_Y - 17 && y >= RED_SCORE_TENS_POSITION_Y - 19) && (x <= RED_SCORE_TENS_POSITION_X + 7 && x >= RED_SCORE_TENS_POSITION_X - 7)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_tens == 'd5 || red_score_tens == 'd6)) begin
					if ((y <= RED_SCORE_TENS_POSITION_Y - 2 && y >= RED_SCORE_TENS_POSITION_Y - 16) && (x <= RED_SCORE_TENS_POSITION_X + 10 && x >= RED_SCORE_TENS_POSITION_X + 8)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_tens == 'd2)) begin
					if ((y <= RED_SCORE_TENS_POSITION_Y + 16 && y >= RED_SCORE_TENS_POSITION_Y + 2) && (x <= RED_SCORE_TENS_POSITION_X + 10 && x >= RED_SCORE_TENS_POSITION_X + 8)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_tens == 'd1 || red_score_tens == 'd4 || red_score_tens == 'd7)) begin
					if ((y <= RED_SCORE_TENS_POSITION_Y + 19 && y >= RED_SCORE_TENS_POSITION_Y + 17) && (x <= RED_SCORE_TENS_POSITION_X + 7 && x >= RED_SCORE_TENS_POSITION_X - 7)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if ((red_score_tens == 'd0 || red_score_tens == 'd2 || red_score_tens == 'd6 || red_score_tens == 'd8)) begin
					if ((y <= BLUE_SCORE_TENS_POSITION_Y + 16 && y >= RED_SCORE_TENS_POSITION_Y + 2) && (x <= RED_SCORE_TENS_POSITION_X - 8 && x >= RED_SCORE_TENS_POSITION_X - 10)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_tens == 'd1 || red_score_tens == 'd2 || red_score_tens == 'd3 || red_score_tens == 'd7)) begin
					if ((y <= RED_SCORE_TENS_POSITION_Y - 2 && y >= RED_SCORE_TENS_POSITION_Y - 16) && (x <= RED_SCORE_TENS_POSITION_X - 8 && x >= RED_SCORE_TENS_POSITION_X - 10)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_tens == 'd0 || red_score_tens == 'd1 || red_score_tens == 'd7)) begin
					if ((y <= RED_SCORE_TENS_POSITION_Y + 1 && y >= RED_SCORE_TENS_POSITION_Y - 1) && (x <= RED_SCORE_TENS_POSITION_X + 7 && x >= RED_SCORE_TENS_POSITION_X - 7)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end
				
				if (!(red_score_ones == 'd1 || red_score_ones == 'd4)) begin
					if ((y <= RED_SCORE_ONES_POSITION_Y - 17 && y >= RED_SCORE_ONES_POSITION_Y - 19) && (x <= RED_SCORE_ONES_POSITION_X + 7 && x >= RED_SCORE_ONES_POSITION_X - 7)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_ones == 'd5 || red_score_ones == 'd6)) begin
					if ((y <= RED_SCORE_ONES_POSITION_Y - 2 && y >= RED_SCORE_ONES_POSITION_Y - 16) && (x <= RED_SCORE_ONES_POSITION_X + 10 && x >= RED_SCORE_ONES_POSITION_X + 8)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_ones == 'd2)) begin
					if ((y <= RED_SCORE_ONES_POSITION_Y + 16 && y >= RED_SCORE_ONES_POSITION_Y + 2) && (x <= RED_SCORE_ONES_POSITION_X + 10 && x >= RED_SCORE_ONES_POSITION_X + 8)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_ones == 'd1 || red_score_ones == 'd4 || red_score_ones == 'd7)) begin
					if ((y <= RED_SCORE_ONES_POSITION_Y + 19 && y >= RED_SCORE_ONES_POSITION_Y + 17) && (x <= RED_SCORE_ONES_POSITION_X + 7 && x >= RED_SCORE_ONES_POSITION_X - 7)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if ((red_score_ones == 'd0 || red_score_ones == 'd2 || red_score_ones == 'd6 || red_score_ones == 'd8)) begin
					if ((y <= RED_SCORE_ONES_POSITION_Y + 16 && y >= RED_SCORE_ONES_POSITION_Y + 2) && (x <= RED_SCORE_ONES_POSITION_X - 8 && x >= RED_SCORE_ONES_POSITION_X - 10)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_ones == 'd1 || red_score_ones == 'd2 || red_score_ones == 'd3 || red_score_ones == 'd7)) begin
					if ((y <= RED_SCORE_ONES_POSITION_Y - 2 && y >= RED_SCORE_ONES_POSITION_Y - 16) && (x <= RED_SCORE_ONES_POSITION_X - 8 && x >= RED_SCORE_ONES_POSITION_X - 10)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end if (!(red_score_ones == 'd0 || red_score_ones == 'd1 || red_score_ones == 'd7)) begin
					if ((y <= RED_SCORE_ONES_POSITION_Y + 1 && y >= RED_SCORE_ONES_POSITION_Y - 1) && (x <= RED_SCORE_ONES_POSITION_X + 7 && x >= RED_SCORE_ONES_POSITION_X - 7)) begin
						red   = 8'b11111111;
						green = 8'b00000000;
						blue  = 8'b00000000;
					end
				end
			end	
		end else begin				// outside the active region
			red   = 8'b00000000;
			green = 8'b00000000;
			blue  = 8'b00000000;
		end
	end
endmodule