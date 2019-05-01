module clock_divider (clk_in, division, clk_out);

input clk_in;
output reg clk_out = 0;

input wire [25:0] division;

integer counter_clk;

initial begin
	clk_out = 0;
	counter_clk = 0;
end

always @(posedge clk_in) begin

	if (counter_clk == division - 'd1) begin
	   counter_clk <= 'd0;
		clk_out <= 1;
	end else begin
		counter_clk <= counter_clk + 'd1;
		clk_out <= 0;
	end
end

endmodule