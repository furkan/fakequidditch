module vga_controller #(
	parameter PLAYER_RADIUS,		// 25 px
	parameter GOAL_RADIUS,			// 40 px
	parameter BALL_RADIUS			//  5 px
)
(	input clk,
	input wire [9:0] y,
	input wire [9:0] x,
	input wire [9:0] team1_ver_pos,
	input wire [9:0] team2_ver_pos,

	output wire hor_sync,
	output wire ver_sync,
	output reg [7:0] red,
	output reg [7:0] green,
	output reg [7:0] blue
);
	
	assign hor_sync = (x  > 95) ? 1'b1 : 1'b0;
	assign ver_sync = (y  >  1) ? 1'b1 : 1'b0;

	always @(posedge clk) begin
		if (x < 784 && x > 143 && y < 515 && y > 34) begin		// the active region
			if (
				((y - 275)**2) + ((x - 463)**2) < BALL_RADIUS ** 2
			) red = 8'b00000000;
			else if (
				((y - team1_ver_pos)**2) + ((x - 300)**2) > PLAYER_RADIUS ** 2
				&& (   (((y-450)**2)+((x-200)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-450)**2)+((x-200)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-330)**2)+((x-200)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-330)**2)+((x-200)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-210)**2)+((x-200)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-210)**2)+((x-200)**2) < (GOAL_RADIUS - 2)**2)   )
				) red = 8'b11111111;
			else  red = 8'b00000000;
			if (
				((y - team1_ver_pos)**2) + ((x - 300)**2) > PLAYER_RADIUS ** 2 
				&& ((y - team2_ver_pos)**2) + ((x - 600)**2) > PLAYER_RADIUS ** 2
				&& (   (((y-450)**2)+((x-200)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-450)**2)+((x-200)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-330)**2)+((x-200)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-330)**2)+((x-200)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-210)**2)+((x-200)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-210)**2)+((x-200)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-100)**2)+((x-700)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-100)**2)+((x-700)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-220)**2)+((x-700)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-220)**2)+((x-700)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-330)**2)+((x-700)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-330)**2)+((x-700)**2) < (GOAL_RADIUS - 2)**2)   )
				)	green = 8'b11111111;
			else green = 8'b00000000;
			if (((y - team2_ver_pos)**2) + ((x - 600)**2) > PLAYER_RADIUS ** 2
				&& (   (((y-100)**2)+((x-700)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-100)**2)+((x-700)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-220)**2)+((x-700)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-220)**2)+((x-700)**2) < (GOAL_RADIUS - 2)**2)   )
				&& (   (((y-330)**2)+((x-700)**2) > (GOAL_RADIUS + 2)**2)
				||     (((y-330)**2)+((x-700)**2) < (GOAL_RADIUS - 2)**2)   )
				)  blue = 8'b11111111;
			else blue = 8'b00000000;
		
		
		
		
		
		
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
