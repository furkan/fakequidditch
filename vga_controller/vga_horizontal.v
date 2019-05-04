module vga_horizontal (
	input clk,
	output reg next_line,
	output reg [9:0] x
);

	initial begin
		x = 0;
		next_line = 0;
	end
	
	always @(posedge clk) begin
		if (x < 799) begin
			x <= x + 1;
			next_line <= 0;
		end else begin
			x <= 0;
			next_line <= 1;
		end
	end

endmodule