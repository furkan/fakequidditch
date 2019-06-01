module player_ball_collider (
	input wire [18:0]    old_ball_x,
	input wire [18:0]    old_ball_y,
	input wire  [9:0]      player_x,
	input wire  [9:0]      player_y,
	input wire [18:0] old_ball_dir_x,
	input wire [18:0] old_ball_dir_y,
	
	output reg signed [18:0] new_ball_x,
	output reg signed [18:0] new_ball_y,
	output reg signed [18:0] new_ball_dir_x,
	output reg signed [18:0] new_ball_dir_y
);

	always begin
		new_ball_x = (((2 * (old_ball_x - old_ball_dir_x) + (2 * ((old_ball_y - player_y) / (old_ball_x - player_x)) * ((old_ball_y - old_ball_dir_y) - (old_ball_y - ((old_ball_y - player_y) / (old_ball_x - player_x)) * old_ball_x)))) / (1 + ((old_ball_y - player_y) / (old_ball_x - player_x)) ** 2)) - (old_ball_x - old_ball_dir_x));
		new_ball_y = (((old_ball_y - player_y) / (old_ball_x - player_x)) * ((2 * (old_ball_x - old_ball_dir_x) + (2 * ((old_ball_y - player_y) / (old_ball_x - player_x)) * ((old_ball_y - old_ball_dir_y) - (old_ball_y - ((old_ball_y - player_y) / (old_ball_x - player_x)) * old_ball_x)))) / (1 + ((old_ball_y - player_y) / (old_ball_x - player_x)) ** 2)) + (2 * (old_ball_y - ((old_ball_y - player_y) / (old_ball_x - player_x)) * old_ball_x)) - (old_ball_y - old_ball_dir_y));
		new_ball_dir_x = (new_ball_x - old_ball_x);
		new_ball_dir_y = (new_ball_y - old_ball_y);
	end
	
endmodule
