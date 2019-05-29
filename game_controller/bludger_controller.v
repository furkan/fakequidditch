/*module bludger_controller( input clk,


)
	always @ (posedge clk) begin
	if ((team1_vu_button ==1) && (team1_vd_button ==1) && (team2_vu_button ==1) && (team2_vd_button==1)) begin
			state_blugger = initial_blugger;
	end else if ( (team1_vu_button == 0 )|| (team1_vd_button == 0)|| (team2_vu_button == 0) || (team2_vd_button == 0)) begin
		if(((36+BALL_RADIUS)<(y_blugger)<(510-BALL_RADIUS)) || ((150+BALL_RADIUS)<(x_blugger)<(680-BALL_RADIUS))) begin
		state_blugger =active_blugger;
	end
	end else begin
		state_blugger= boundary_bludger;
	/*//lower boundry
				if ((y_position == 510-BALL_RADIUS ) && (ball_dir_y == y_down ) ) begin
				ball_dir_y <= y_up;
				ball_dir_x <= ball_dir_x;
				end
				//upper boundry
				else if ((y_position < 36 + BALL_RADIUS) && (ball_dir_y == y_up)) begin
				ball_dir_y <= y_down;
				ball_dir_x <= ball_dir_x;
				end 
				// left boundry condition
				else if((x_position < 150 + BALL_RADIUS) && (ball_dir_x== x_left) ) begin
				ball_dir_y <= ball_dir_y;
				ball_dir_x <= x_right;
				end 
				// right boundary condition
				else if((x_position > 680 - BALL_RADIUS) && (ball_dir_x == x_right)) begin
				ball_dir_x <= x_left;
				ball_dir_y <= ball_dir_y;
				end
				if (PLAYER_RADIUS+
	end */
