module vga_horizontal (clk, next_line, current_pixel);

	input clk;
	output reg next_line;
	output reg [9:0] current_pixel;
	
	always @(posedge clk) begin
	
		if (current_pixel < 799) begin
			current_pixel <= current_pixel + 1;
			next_line <= 0;
		end else begin
			current_pixel <=0;
			next_line <= 1;
		end
	end
	
endmodule