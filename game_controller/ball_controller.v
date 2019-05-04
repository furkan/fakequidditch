module ball_controller (
	input clk,
	input [9:0] x_position,
	input [9:0] y_position
);

	reg [30:0] x_positions;
	reg [30:0] y_positions;
	
	initial begin
		x_positions = {10'b0 + 'd463, 10'b0 + 'd463, 10'b0 + 463};
		y_positions = {10'b0 + 'd275, 10'b0 + 'd275, 10'b0 + 275};
	end
	
	always @(posedge clk) begin
		x_positions <= x_positions << 'd10 + x_position;
		y_positions <= y_positions << 'd10 + y_position;
	end
	
	
	

endmodule