module ball_controller #(
	parameter PLAYER_RADIUS,		// 35 px works
	parameter BALL_RADIUS,
	parameter GOAL_RADIUS,
	parameter MOVEMENT_FREQUENCY	// inversely proportinal to speed ('d200000 works)
)
(
	input clk,
	input game_on,
	input game_over,
	input [9:0] team1_ver_pos,
	input [9:0] team2_ver_pos,
	input [9:0] team1_hor_pos,
	input [9:0] team2_hor_pos,
	
	output reg [9:0] x_position,
	output reg [9:0] y_position
);

	reg signed [4:0] ball_dir_x, ball_dir_y;
	
	integer counter;
	integer inside_goal = (GOAL_RADIUS - BALL_RADIUS) ** 2;
	parameter max =28;
	parameter min=12;

	reg [2:0] state;
	
	parameter dead       = 'd0;
	parameter up_right   = 'd1;
	parameter up_left    = 'd2;
	parameter down_left  = 'd3;
	parameter down_right = 'd4;
	
	initial begin 
		state          = dead;
		counter        =    0;
		x_position     =  463;
		y_position     =  275;
	end
	
	always @(posedge clk) begin
		if (game_on == 1 && state == dead) begin
			state = down_right;
		end else if (
			      (((y_position-450)**2)+((x_position-300)**2) < inside_goal) // BLUE GOAL 1
				|| (((y_position-450)**2)+((x_position-400)**2) < inside_goal) // BLUE GOAL 2
				|| (((y_position-450)**2)+((x_position-500)**2) < inside_goal) // BLUE GOAL 3
		) begin
			state = dead;
			x_position <= 463;
		   y_position <= 275;
		end else if (
			      (((y_position-100)**2)+((x_position-300)**2) < inside_goal) // RED  GOAL 1
				|| (((y_position-100)**2)+((x_position-400)**2) < inside_goal) // RED  GOAL 2
				|| (((y_position-100)**2)+((x_position-500)**2) < inside_goal) // RED  GOAL 3
		) begin
		  state = dead; 
		  x_position <= 463;
		  y_position <= 275;
		  end
			
		//upper bound
		 else if ((y_position) < (36 + BALL_RADIUS)) begin
			if (state == up_left) begin
				state = down_left;
				 x_position <= x_position-1;
			 y_position <= y_position+1;
			end else begin
				state = down_right;
				 x_position <= x_position+1;
			 y_position <= y_position+1;
			end
			//lower bound
		 end else if ((y_position) > (510 - BALL_RADIUS)) begin
			if (state == down_left) begin
				state = up_left;
				 x_position <= x_position-1;
			 y_position <= y_position-1;
			end else begin
				state = up_right;
				 x_position <= x_position+1;
			 y_position <= y_position-1;
			end
			//left bound
		end else if ((x_position) < (150 + BALL_RADIUS)) begin
			if (state == down_left) begin
				state = down_right;
				 x_position <= x_position+1;
			 y_position <= y_position+1;
			end else begin
				state = up_right;
				 x_position <= x_position+1;
			 y_position <= y_position-1;
			end
			//right bound
		end else if (x_position > (660 - BALL_RADIUS)) begin
			if (state == down_right) begin
				state = down_left;
				 x_position <= x_position-1;
			 y_position <= y_position+1;
			end else begin
				state = up_left;
				 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		end
		
		// interaction with players & ball
		
			 // for team1 ver
		/*else if (((y_position - team1_ver_pos)**2 + (x_position - 240)**2)<(PLAYER_RADIUS+BALL_RADIUS+1)) begin
		// for wall 1
		if(((PLAYER_RADIUS + BALL_RADIUS +1)>(team1_ver_pos - y_position)> max)) begin
		   if(state == down_left) begin
			state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
			else begin
			 state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			end
		end
		//for wall 2
		 else if((min<(240-x_position)<max) && (min<(team1_ver_pos - y_position)<max)) begin
		   if(state == down_right) begin
			state = down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			state =up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 3
		 else if ((PLAYER_RADIUS +BALL_RADIUS +1) > (240 - x_position) > (max)) begin
		   if(state == down_right) begin
			 state= down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			 state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 4
		  else if(((min)<(240-x_position)< (max)) && (min<(y_position - team1_ver_pos)< (max))) begin
		    if(state==down_right) begin
			 state= down_left;
			  x_position <= x_position-1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state = up_left;
			  x_position <= x_position-1;
			 y_position <= y_position-1;
			 end
		  end
		// for wall 5
		  else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(y_position -team1_ver_pos) >(max)) begin
		    if(state==up_right) begin
			 state=down_right;
			  x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state=down_left;
			  x_position <= x_position-1;
			 y_position <= y_position+1;
			 end
		  end
		 // for wall 6
		  else if (((min) <(x_position-240)< (max)) && ( (min) <(y_position -team1_ver_pos)< (max))) begin
		    if(state==down_left) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
		  end
		// for wall 7
		else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(x_position-240)> (max)) begin
		    if(state==down_left) begin
		    state = down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else  begin
			 state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		end
		// for wall 8
		else if(((min)<(x_position-240)< (max)) && ((min) <(team1_ver_pos-y_position) < (max))) begin
		    if(state==down_left) begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
			 else begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		  end */
		  
		  // for team2 ver
		  else if (((y_position - team2_ver_pos)**2 + (x_position - 560)**2)<(PLAYER_RADIUS+BALL_RADIUS+1)) begin
		// for wall 1
		if(((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(team2_ver_pos - y_position)> (max)) begin
		   if(state == down_left) begin
			state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
			else begin
			state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			end
		end
		//for wall 2
		 else if (((min)<(560-x_position)<max) && ((min)<(team2_ver_pos - y_position)< (max))) begin
		   if(state == down_right) begin
			state =down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			state =up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 3
		 else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(560-x_position)> (max)) begin
		   if(state==down_right) begin
			state= down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 4
		  else if((min<(560-x_position)<max) && ((min)<(y_position - team2_ver_pos)<(max))) begin
		    if(state==down_right) begin
			 state= down_left;
			  x_position <= x_position-1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state = up_left;
			  x_position <= x_position-1;
			 y_position <= y_position-1;
			 end
		  end
		// for wall 5
		  else if(((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(y_position - team2_ver_pos)> (max)) begin
		    if(state==up_right) begin
			 state=down_right;
			  x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state=down_left;
			  x_position <= x_position-1;
			 y_position <= y_position+1;
			 end
		  end
		 // for wall 6
		  else if(((min)<(x_position-560)< (max)) && ((min)<(y_position - team2_ver_pos)< (max))) begin
		    if(state==down_left) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 if(state==up_left) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
		  end
		// for wall 7
		else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(x_position-560)> (max)) begin
		    if(state==down_left) begin
		    state = down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else  begin
			 state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		end
		// for wall 8
		else if((min<(x_position-560)< (max)) && ( (min) <(team2_ver_pos - y_position)< (max))) begin
		    if(state==down_left) begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
			 else begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		  end
		  
		  /*//for team1 hor
		  else if (((x_position - team1_hor_pos)**2 + (y_position - 380)**2)<(PLAYER_RADIUS+BALL_RADIUS+1)) begin
		// for wall 1
		 if(((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(380 - y_position)> (max)) begin
		   if(state ==down_left) begin
			state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
			else begin
			state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			end
		 end
		//for wall 2
		 else if(((min) <(team1_hor_pos - x_position)<max) && (min<(380-y_position)< (max))) begin
		   if(state == down_right) begin
			state =down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			state =up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 3
		 else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(team1_hor_pos - x_position)> (max)) begin
		   if(state==down_right) begin
			state= down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 4
		  else if(((min) <(team1_hor_pos - x_position)<max) && ((min) <(y_position - 380)< (max))) begin
		    if(state==down_right) begin
			 state= down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state = up_left;
			  x_position <= x_position-1;
			 y_position <= y_position-1;
			 end
		  end
		// for wall 5
		  else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>((y_position-380 )> (max))) begin
		    if(state==up_right) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state=down_left;
			 x_position <= x_position -1;
			 y_position <= y_position +1;
			 end
		  end
		 // for wall 6
		  else if (((min)<((x_position) -(team1_hor_pos))< (max)) && ((min) <(y_position - 380)< (max))) begin
		    if(state==down_left) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 if(state==up_left) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
		  end
		// for wall 7
		else if ((((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(x_position)-(team1_hor_pos))> (max)) begin
		    if(state==down_left) begin
		    state = down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else  begin
			 state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		end
		// for wall 8
		else if (((min)<((x_position) -(team1_hor_pos))< (max)) && ((min)<(380 - y_position)<(max))) begin
		    if(state==down_left) begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
			 else begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		 end
	 end
		  
		  //for team2 hor
		else if ((((x_position) - (team2_hor_pos))**2 + (y_position - 180)**2)<((PLAYER_RADIUS)+(BALL_RADIUS+1))) begin
		// for wall 1
		  if(((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(180 - y_position)> (max)) begin
		   if(state ==down_left) begin
			state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
			else begin
			state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			end
		end
		//for wall 2
		 else if (((min)<((team2_hor_pos) - (x_position))< (max)) && ((min)<(180 -y_position)<(max))) begin
		   if(state == down_right) begin
			state =down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			state =up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 3
		 else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>((team2_hor_pos)-(x_position))> (max)) begin
		   if(state==down_right) begin
			state= down_left;
			 x_position <= x_position-1;
			 y_position <= y_position+1;
			end
			else begin
			state = up_left;
			 x_position <= x_position-1;
			 y_position <= y_position-1;
			end
		 end
		// for wall 4
		  else if (((min)<((team2_hor_pos) - (x_position))<(max)) && ((min)<(y_position - 180)<(max))) begin
		    if(state==down_right) begin
			 state= down_left;
			  x_position <= x_position-1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state = up_left;
			  x_position <= x_position-1;
			 y_position <= y_position-1;
			 end
		  end
		// for wall 5
		  else if((((PLAYER_RADIUS)+(BALL_RADIUS)+1)>(y_position - 180)> (max))) begin
		    if(state==up_right) begin
			 state=down_right;
			  x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else begin
			 state=down_left;
			  x_position <= x_position-1;
			 y_position <= y_position+1;
			 end
		  end
		 // for wall 6
		  else if(((((min)<( (x_position)- (team2_hor_pos) )<(max)) && ((min)<(y_position - 180)<(max))))) begin
		    if(state==down_left) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 if(state==up_left) begin
			 state=down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
		  end
		// for wall 7
		else if (((PLAYER_RADIUS)+(BALL_RADIUS)+1)>((x_position) - (team2_hor_pos))> (max)) begin
		    if(state==down_left) begin
		    state = down_right;
			 x_position <= x_position+1;
			 y_position <= y_position+1;
			 end
			 else  begin
			 state = up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		end
		// for wall 8
		else if (((min) <(x_position-team2_hor_pos )< (max)) && ((min) <(180 -y_position)< (max))) begin
		    if(state==down_left) begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
			 else begin
			 state=up_right;
			 x_position <= x_position+1;
			 y_position <= y_position-1;
			 end
		  end
   end*/
	 else begin
	  if (counter =='d98) begin
		  if(state==up_right) begin
		  x_position <= x_position +1;
		  y_position <= y_position-1;
		  end
		  if (state==up_left) begin
		  x_position <= x_position -1;
		  y_position <= y_position-1;
		  end
		  if (state==down_left) begin
		  x_position <= x_position -1;
		  y_position <= y_position+1;
		  end
		  if (state==down_right) begin
		  x_position <= x_position +1;
		  y_position <= y_position +1;
		  end
		 end
		end
	end
	end
	always @(posedge clk) begin
		if (counter < MOVEMENT_FREQUENCY) begin
			counter <= counter + 'd1;
		end else begin
			counter <= 0;
		end
	end
	
	
endmodule