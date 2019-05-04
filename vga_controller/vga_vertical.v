module vga_vertical (
	input clk,
	input next_line,
	output reg [9:0] y
);

	initial begin
		y = 0;
	end

	always @(posedge clk) begin
		if (next_line == 1) begin
			if (y < 524) begin
				y <= y + 1;
			end else begin
				y <= 0;
			end
		end
	end

endmodule