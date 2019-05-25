module vga_controller #(
	parameter PLAYER_RADIUS,		// 25 px
	parameter GOAL_RADIUS,			// 40 px
	parameter BALL_RADIUS			//  5 px
)
(	input clk,
	input vga_clk,
//	input wire [9:0] y,
//	input wire [9:0] x,
	input wire [9:0] team1_ver_pos,
	input wire [9:0] team2_ver_pos,

	input wire [18:0] ball_x,
	input wire [18:0] ball_y,

	input [7:0] left_seconds,


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

	parameter MINUTE_POSITION_X = 680;
	parameter MINUTE_POSITION_Y = 275;

	parameter SECOND_TENS_POSITION_X = 720;
	parameter SECOND_TENS_POSITION_Y = 275;

	parameter SECOND_ONES_POSITION_X = 760;
	parameter SECOND_ONES_POSITION_Y = 275;

	reg next_line;
	reg [9:0] x;
	reg [9:0] y;

	wire [3:0] left_minute;
	wire [3:0] left_second_tens;
	wire [3:0] left_second_ones;

	assign left_minute = left_seconds / 60;
	assign left_second_tens = (left_seconds % 60) / 10;
	assign left_second_ones = (left_seconds % 60) % 10;

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
//		if (x < 784 && x > 143 && y < 515 && y > 34) begin		// the active region
		if (x < 684 && x > 143 && y < 515 && y > 34) begin		// field
			if (
				((y - ball_y)**2) + ((x - ball_x)**2) < BALL_RADIUS ** 2  // BALL
			) red = 8'b00000000;
			else if (
				((y - team1_ver_pos)**2) + ((x - 240)**2) > PLAYER_RADIUS ** 2 // BLUE VER PLAYER

				&& (   (((y-BLUE_GOAL1_Y)**2)+((x-BLUE_GOAL1_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-BLUE_GOAL1_Y)**2)+((x-BLUE_GOAL1_X)**2) < (GOAL_RADIUS - 2)**2)   ) // BLUE GOAL 1

				&& (   (((y-BLUE_GOAL2_Y)**2)+((x-BLUE_GOAL2_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-BLUE_GOAL2_Y)**2)+((x-BLUE_GOAL2_X)**2) < (GOAL_RADIUS - 2)**2)   ) // BLUE GOAL 2

				&& (   (((y-BLUE_GOAL3_Y)**2)+((x-BLUE_GOAL3_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-BLUE_GOAL3_Y)**2)+((x-BLUE_GOAL3_X)**2) < (GOAL_RADIUS - 2)**2)   ) // BLUE GOAL 3
				) red = 8'b11111111;
			else  red = 8'b00000000;
			if (
				((y - team1_ver_pos)**2) + ((x - 240)**2) > PLAYER_RADIUS ** 2    // BLUE VER PLAYER
				&& ((y - team2_ver_pos)**2) + ((x - 560)**2) > PLAYER_RADIUS ** 2 // RED  VER PLAYER

				&& (   (((y-BLUE_GOAL1_Y)**2)+((x-BLUE_GOAL1_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-BLUE_GOAL1_Y)**2)+((x-BLUE_GOAL1_X)**2) < (GOAL_RADIUS - 2)**2)   ) // BLUE GOAL 1

				&& (   (((y-BLUE_GOAL2_Y)**2)+((x-BLUE_GOAL2_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-BLUE_GOAL2_Y)**2)+((x-BLUE_GOAL2_X)**2) < (GOAL_RADIUS - 2)**2)   ) // BLUE GOAL 2

				&& (   (((y-BLUE_GOAL3_Y)**2)+((x-BLUE_GOAL3_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-BLUE_GOAL3_Y)**2)+((x-BLUE_GOAL3_X)**2) < (GOAL_RADIUS - 2)**2)   ) // BLUE GOAL 3

				&& (   (((y-RED_GOAL1_Y)**2)+((x-RED_GOAL1_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-RED_GOAL1_Y)**2)+((x-RED_GOAL1_X)**2) < (GOAL_RADIUS - 2)**2)   ) // RED  GOAL 1

				&& (   (((y-RED_GOAL2_Y)**2)+((x-RED_GOAL2_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-RED_GOAL2_Y)**2)+((x-RED_GOAL2_X)**2) < (GOAL_RADIUS - 2)**2)   ) // RED  GOAL 2

				&& (   (((y-RED_GOAL3_Y)**2)+((x-RED_GOAL3_X )**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-RED_GOAL3_Y)**2)+((x-RED_GOAL3_X )**2) < (GOAL_RADIUS - 2)**2)   ) // RED  GOAL 3
				)	green = 8'b11111111;
			else green = 8'b00000000;
			if (((y - team2_ver_pos)**2) + ((x - 560)**2) > PLAYER_RADIUS ** 2 // RED VER PLAYER

				&& (   (((y-RED_GOAL1_Y)**2)+((x-RED_GOAL1_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-RED_GOAL1_Y)**2)+((x-RED_GOAL1_X)**2) < (GOAL_RADIUS - 2)**2)   ) // RED  GOAL 1

				&& (   (((y-RED_GOAL2_Y)**2)+((x-RED_GOAL2_X)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-RED_GOAL2_Y)**2)+((x-RED_GOAL2_X)**2) < (GOAL_RADIUS - 2)**2)   ) // RED  GOAL 2

				&& (   (((y-RED_GOAL3_Y)**2)+((x-RED_GOAL3_X )**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-RED_GOAL3_Y)**2)+((x-RED_GOAL3_X )**2) < (GOAL_RADIUS - 2)**2)   ) // RED  GOAL 3
				)  blue = 8'b11111111;
			else blue = 8'b00000000;

		end else if (x < 666 && x > 664 && y < 515 && y > 34) begin // separator between field and board
			red   = 8'b00000000;
			green = 8'b00000000;
			blue  = 8'b00000000;
		end
		end else if (x < 784 && x > 665 && y < 515 && y > 34) begin // board
			red   = 8'b10000000;
			green = 8'b11111111;
			blue  = 8'b10101010;

			if (!(left_minute == 'd1 || left_minute == 'd4)) begin
				if ((y <= MINUTE_POSITION_Y - 28 && y >= MINUTE_POSITION_Y - 32) && (x <= MINUTE_POSITION_X + 12 && x >= MINUTE_POSITION_X - 12)) begin
					red   = 8'b00000000;
					green = 8'b00000000;
					blue  = 8'b00000000;
				end
			end if (!(left_minute == 'd5 || left_minute == 'd6')) begin
				if ((y <= MINUTE_POSITION_Y - 3 && y >= MINUTE_POSITION_Y - 27) && (x <= MINUTE_POSITION_X + 17 && x >= MINUTE_POSITION_X + 13)) begin
					red   = 8'b00000000;
					green = 8'b00000000;
					blue  = 8'b00000000;
				end
			end if (!(left_minute == 'd2)) begin
				if ((y <= MINUTE_POSITION_Y + 27 && y >= MINUTE_POSITION_Y + 3) && (x <= MINUTE_POSITION_X + 17 && x >= MINUTE_POSITION_X + 13)) begin
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
				if ((y <= MINUTE_POSITION_Y + 27 && y >= MINUTE_POSITION_Y + 3) && (x <= MINUTE_POSITION_X - 17 && x >= MINUTE_POSITION_X + 13)) begin
					red   = 8'b00000000;
					green = 8'b00000000;
					blue  = 8'b00000000;
				end
			end if (!(left_minute == 'd1 || left_minute == 'd2 || left_minute == 'd3 || left_minute == 'd7)) begin
				if ((y <= MINUTE_POSITION_Y + 27 && y >= MINUTE_POSITION_Y + 3) && (x <= MINUTE_POSITION_X - 13 && x >= MINUTE_POSITION_X - 17)) begin
					red   = 8'b00000000;
					green = 8'b00000000;
					blue  = 8'b00000000;
				end
			end if (!(left_minute == 'd0 || left_minute == 'd1 || left_minute == 'd7)) begin
				if ((y <= MINUTE_POSITION_Y + 2 && y >= MINUTE_POSITION_Y - 2) && (x <= MINUTE_POSITION_X + 12 && x >= MINUTE_POSITION_X - 12)) begin
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
			end if (!(left_second_tens == 'd5 || left_second_tens == 'd6')) begin
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
				if ((y <= SECOND_TENS_POSITION_Y + 27 && y >= SECOND_TENS_POSITION_Y + 3) && (x <= SECOND_TENS_POSITION_X - 17 && x >= SECOND_TENS_POSITION_X + 13)) begin
					red   = 8'b00000000;
					green = 8'b00000000;
					blue  = 8'b00000000;
				end
			end if (!(left_second_tens == 'd1 || left_second_tens == 'd2 || left_second_tens == 'd3 || left_second_tens == 'd7)) begin
				if ((y <= SECOND_TENS_POSITION_Y + 27 && y >= SECOND_TENS_POSITION_Y + 3) && (x <= SECOND_TENS_POSITION_X - 13 && x >= SECOND_TENS_POSITION_X - 17)) begin
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
			end if (!(left_second_ones == 'd5 || left_second_ones == 'd6')) begin
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
				if ((y <= SECOND_ONES_POSITION_Y + 27 && y >= SECOND_ONES_POSITION_Y + 3) && (x <= SECOND_ONES_POSITION_X - 17 && x >= SECOND_ONES_POSITION_X + 13)) begin
					red   = 8'b00000000;
					green = 8'b00000000;
					blue  = 8'b00000000;
				end
			end if (!(left_second_ones == 'd1 || left_second_ones == 'd2 || left_second_ones == 'd3 || left_second_ones == 'd7)) begin
				if ((y <= SECOND_ONES_POSITION_Y + 27 && y >= SECOND_ONES_POSITION_Y + 3) && (x <= SECOND_ONES_POSITION_X - 13 && x >= SECOND_ONES_POSITION_X - 17)) begin
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

		end else begin				// outside the active region
			red   = 8'b00000000;
			green = 8'b00000000;
			blue  = 8'b00000000;
		end
	end

/*	always @(posedge clk) begin
		if (x < 'd784 && x > 'd143 && y < 'd515 && y > 'd34) begin
			red   <= 8'b11111111;
			green <= 8'b11111111;
			blue  <= 8'b11111111;
		end else begin
			red   <= 8'b00000000;
			green <= 8'b00000000;
			blue  <= 8'b00000000;
		end
	end
*/
endmodule
