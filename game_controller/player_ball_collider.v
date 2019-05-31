module ball_collider (
	input wire [10:0]    old_ball_x,
	input wire [10:0]    old_ball_y,
	input wire  [9:0]      player_x,
	input wire  [9:0]      player_y,
	input wire [10:0] old_ball_dir_x,
	input wire [10:0] old_ball_dir_y,
	
	output reg signed [10:0] new_ball_x,
	output reg signed [10:0] new_ball_y,
	output reg signed [10:0] new_ball_dir_x,
	output reg signed [10:0] new_ball_dir_y
);

	reg signed [10:0] m, b, x_bef, y_bef, x_aft, y_aft;
	
	always begin
		m = (old_ball_y - player_y) / (old_ball_x - player_x);
		b = old_ball_y - m * old_ball_x;
		x_bef = old_ball_x - old_ball_dir_x;
		y_bef = old_ball_y - old_ball_dir_y;
		x_aft = (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) - x_bef;
		y_aft = m * (2 * x_bef + (2*m) * (y_bef - b)) / (1 + m ** 2) + 2 * b - x_bef;
		
		new_ball_dir_x = x_aft - old_ball_x;
		new_ball_dir_y = y_aft - old_ball_y;
		new_ball_x = x_aft;
		new_ball_y = y_aft;
	end
	
endmodule
