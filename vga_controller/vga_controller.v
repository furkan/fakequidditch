module vga_controller(
	input wire [9:0] current_line,
	input wire [9:0] current_pixel,
	input wire [9:0] team1_ver_pos,
	input wire [9:0] team2_ver_pos,

	output hor_sync,
	output ver_sync,
	output reg [7:0] red,
	output reg [7:0] green,
	output reg [7:0] blue
);

	assign hor_sync = (current_pixel > 95) ? 1'b1 : 1'b0;
	assign ver_sync = (current_line > 1)  ? 1'b1 : 1'b0;


	always begin
		if (current_pixel < 784 && current_pixel > 143 && current_line < 515 && current_line > 34) begin
			if (((current_line - team1_ver_pos)**2) + ((current_pixel - 50)**2) > 175)  red = 8'b11111111;
			else  red = 8'b0;
			if (((current_line - team1_ver_pos)**2) + ((current_pixel - 50)**2) > 175 && ((current_line - team2_ver_pos)**2) + ((current_pixel - 590)**2) > 175) green = 8'b11111111;
			else green = 8'b0;
			if (((current_line - team2_ver_pos)**2) + ((current_pixel - 590)**2) > 175)  blue = 8'b11111111;
			else blue = 8'b0;
		end else begin
			red   = 8'b0;
			green = 8'b0;
			blue  = 8'b0;
		end
	end
endmodule
