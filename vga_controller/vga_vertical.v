module vga_vertical(clk, next_line, current_line);
	input clk;
	input next_line;
	output reg [9:0] current_line;
	
	always @(posedge clk) begin
		if (next_line == 1) begin
			if (current_line < 524) begin
				current_line <= current_line + 1;
			end else begin
				current_line <= 0;
			end
		end
	end
endmodule