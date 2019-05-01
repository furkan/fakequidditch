module fakequidditch (clk);
	
	input         clk;
	wire       clk_en;
	parameter div = 2; // <-- divide 50 MHz by this
	
	wire move_down;
	reg  next_line;
	
	wire [9:0]  instant_line;
	wire [9:0] instant_pixel;
	
	reg [9:0]  current_line;
	reg [9:0] current_pixel;
	
	wire  hor_sync;
	wire  ver_sync;
	wire [3:0]   red;
	wire [3:0] green;
	wire [3:0]  blue;
	
	clock_divider cd (clk, div, clk_en);
	
	vga_horizontal vga_hor (clk_en, move_down, instant_pixel);
	
	vga_vertical vga_ver (clk_en, next_line, instant_line);
	
	vga_controller vga_cont (current_line, current_pixel, hor_sync, ver_sync, red, green, blue);
	
	always begin
		next_line <= move_down;
		current_line <= instant_line;
		current_pixel <= instant_pixel;
	end
	
endmodule