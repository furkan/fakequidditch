
module ball_controller_cansu #(
	parameter PLAYER_RADIUS,		// 35 px works
	parameter BALL_RADIUS,
	parameter GOAL_RADIUS,
	parameter MOVEMENT_FREQUENCY	// inversely proportinal to speed ('d200000 works)
)
(
	input clk,
	
	input game_over,
	
//	input [9:0] x_position,
//	input [9:0] y_position,

	input [9:0] team1_ver_pos,
// team1_ver_player_hor_pos = 240

	input [9:0] team1_hor_pos,

	input [9:0] team2_ver_pos,
// team2_ver_player_hor_pos = 560

	input [9:0] team2_hor_pos,

	input team1_vu_button,
	input team1_vd_button,
	input team2_vu_button,
	input team2_vd_button,
	
	input team1_hl_button,
	input team1_hr_button,
	input team2_hl_button,
	input team2_hr_button,
	
/*	output reg score_to_team1,
	output reg score_to_team2,
*/
	output reg [9:0] x_position,
	output reg [9:0] y_position,
	/*
	output reg [9:0] x_blugger,
	output reg [9:0] y_blugger,
	*/
	output reg game_on
);

	reg[2:0] ball_dir;
	parameter southwest ='d0;
	parameter southeast ='d1;
	parameter northeast ='d2;
	parameter northwest ='d3;
 
	integer ball_collution;
	
	integer inside_goal = (GOAL_RADIUS - BALL_RADIUS) ** 2;
	
	integer cansu;

	reg [2:0] state;
	
	parameter beginning   = 'd0;
	parameter active      = 'd1;
	//parameter boundary_ball ='d2;

	integer counter;
	
	initial begin 
		state          = beginning;
		counter        =    0;
		x_position     =  463;
		y_position     =  275;
/*		score_to_team1 =    0;
		score_to_team2 =    0;
	*/	ball_dir 		= southwest;
		ball_collution = 0;
		cansu				= 1;
		game_on        = 0;
	
	end
   // counter for the ball position change
	/*always @(posedge clk) begin
		if (counter < MOVEMENT_FREQUENCY) begin
			counter <= counter + 'd1;
		end else begin
			counter <= 0;
		end
	end */
	
	// states
	always @(posedge clk) begin
		if ((team1_vu_button ==1) && (team1_vd_button ==1) && (team2_vu_button ==1) && (team2_vd_button==1)&& (team1_hr_button ==1) && (team1_hr_button ==1) && (team2_hr_button ==1) && (team2_hl_button ==1) &&(cansu ==1)) begin
				state = beginning;
		end else if ((((y_position-450)**2)+((x_position-300)**2) < inside_goal) // BLUE GOAL 1
					|| (((y_position-450)**2)+((x_position-400)**2) < inside_goal) // BLUE GOAL 2
					|| (((y_position-450)**2)+((x_position-500)**2) < inside_goal) // BLUE GOAL 3
			) begin
				state = beginning;
				cansu=1;
	//			score_to_team2 <= ((score_to_team2) +1);
		end else if ((((y_position-100)**2)+((x_position-300)**2) < inside_goal) // RED  GOAL 1
					|| (((y_position-100)**2)+((x_position-400)**2) < inside_goal) // RED  GOAL 2
					|| (((y_position-100)**2)+((x_position-500)**2) < inside_goal) // RED  GOAL 3
			) begin
				state = beginning;
				cansu=1;
				end
	//			score_to_team1 <= ((score_to_team1)+1);
	//	end else if (game_over == 1) begin
		//	state = beginning;
		//	cansu = 1;
	//end else if ((y_position < 510 - BALL_RADIUS ) && ((y_position > 36 + BALL_RADIUS)) && ((x_position > 150 + BALL_RADIUS) && (ball_dir==east )) && ((x_position < 661 - BALL_RADIUS)) && (collide=0)) begin
			//state = active;
			//cansu =0;
			//game_on <= 1;
		/*end
		else begin
		state = boundary_ball;
		collide 
		end 
		else  if ((y_position < 510 - BALL_RADIUS ) && ((y_position > 36 + BALL_RADIUS)) && ((x_position > 150 + BALL_RADIUS) && (ball_dir==east )) && ((x_position < 661 - BALL_RADIUS)) && (collide=0)) begin
			state = active;
			cansu =0;
			game_on <= 1;
	end */
	else  begin
			state = active;
			cansu =0;
			game_on <= 1;
	end 
	end
	//29.05.2019 @21.52 added
	always @(posedge clk) begin
	//lower boundary
				if ((y_position > 510 - BALL_RADIUS ) && (ball_dir== southeast ) ) begin
					ball_dir <= northeast;
				end
				 if ((y_position > 510 - BALL_RADIUS ) && (ball_dir== southwest ) ) begin
					ball_dir <= northwest;
				end
				
				//upper boundary
					
				else if ((y_position < 36 + BALL_RADIUS) && (ball_dir == northeast)) begin
					ball_dir <= southeast;
				end 
				else if ((y_position < 36 + BALL_RADIUS) && (ball_dir == northwest)) begin
					ball_dir <= southwest;
				end 
				// left boundary condition
				
			    if((x_position < 150 + BALL_RADIUS) && (ball_dir==northeast ) ) begin
					ball_dir <= northwest;
				end 
			    if((x_position < 150 + BALL_RADIUS) && (ball_dir==southeast ) ) begin
					ball_dir <= southwest;
				end 	
				// right boundary condition
				
				 if((x_position > 661 - BALL_RADIUS) && (ball_dir == northwest)) begin
					ball_dir <= northeast;
				end
				 if((x_position > 661 - BALL_RADIUS) && (ball_dir == southwest)) begin
					ball_dir <= southeast;
				end
//ball player interactions
			//for team 1 vertical player
			 if ((((team1_ver_pos) - (y_position))**2 + (240 - x_position)**2 < (((BALL_RADIUS)+(PLAYER_RADIUS)+1)**2)) && ball_collution == 0 ) begin
					ball_collution =1;
					// ball collides to player1 from wall_1
					if ((240-x_position)<12 && (ball_dir == southeast) && (((team1_ver_pos)-y_position))<28) begin
						ball_dir <= northeast;
						x_position <= x_position-1;
						y_position <= y_position -1;
					end 
					 if ((240-x_position)<=12 && (ball_dir == southwest)&& (((team1_ver_pos)- y_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					
					// ball collides to player 1 from wall_2
				    if (13<(240-x_position)<28 && (ball_dir == northwest)&& (12<((team1_ver_pos)- y_position)) < 28) begin
						ball_dir <= northeast;
						x_position <= x_position-3;
						y_position <= y_position -3;
					end 
					 if ((12<(240-x_position)<28) && (ball_dir == southwest) && (12<(team1_ver_pos)-(y_position) < 28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 
					// ball collides to player1 from wall_3
					 if (((240-x_position)<=12) && (ball_dir == southwest) && ((y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end
				    if (((240-x_position)<=12) && (ball_dir == northwest) && ((y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 	
					
				   // ball collides to player1 from wall_4
					 if ((12<(240-x_position)<28) && (ball_dir == northwest) && (11<(y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end
				    if ((12<(240-x_position)<28) && (ball_dir == northeast) && (11<(y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 	
			      
					// ball collides to player1 from wall_5
					 if (((x_position-240)<=12) && (ball_dir == northwest) && (((y_position)-(team1_ver_pos)<28))) begin
						ball_dir <= southeast;
						x_position <= x_position-1;
						y_position <= y_position +1;
					end
					 if (((x_position-240)<=12) && (ball_dir == northwest) && (((y_position)-(team1_ver_pos)<28))) begin
						ball_dir <= southwest;
						x_position <= x_position+1;
						y_position <= y_position +1;
					end
			
					//ball collides to player1 from wall6
					 if ((12<(x_position-240)<28) && (ball_dir == southeast) && ((12<((y_position)-(team1_ver_pos)))<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					 if ((12<((x_position)-240)<28) && (ball_dir == northeast) && (12<((y_position)-(team1_ver_pos)))< 28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end
					// ball collides to player1 from wall_7
					 if (((x_position-240)<= 12) && (ball_dir == northeast) && ((((team1_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					 if ((((x_position)-240)<12) && (ball_dir == southeast) && ((((team1_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					
			// ball collides to player 1 from wall_8
		          if ((12<(x_position-240)<28) && (ball_dir == southeast) && ((12<(team1_ver_pos)-(y_position)))<28) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 
					 if ((12<((x_position)-240)<28) && (ball_dir == southwest) && ((12<(team1_ver_pos)-(y_position)))<28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					end
		//for team2 ver player	
			 else if ((((team2_ver_pos) - (y_position))**2 + (560 - x_position)**2 < (((BALL_RADIUS)+(PLAYER_RADIUS)+1)**2))&& (ball_collution== 0)) begin
				ball_collution =1;
			
					// ball collides to player1 from wall_1
					if ((560-x_position)<=12 && (ball_dir == southeast) && (((team2_ver_pos)-y_position))<28) begin
						ball_dir <= northeast;
						x_position <= x_position-1;
						y_position <= y_position -1;
					end 
					 if ((x_position-560)<=12 && (ball_dir == southeast) && (((team2_ver_pos)-y_position))<28) begin
						ball_dir <= northeast;
						x_position <= x_position-1;
						y_position <= y_position -1;
					end 
					 if ((560-x_position)<=12 && (ball_dir == southwest)&& (((team2_ver_pos)- y_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					 if ((x_position-560)<=12 && (ball_dir == southwest)&& (((team2_ver_pos)- y_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					 
					
					// ball collides to player 1 from wall_2
				    if (12<(560-x_position)<28 && (ball_dir == northwest)&& (12<((team2_ver_pos)- y_position)) < 28) begin
						ball_dir <= northeast;
						x_position <= x_position-3;
						y_position <= y_position -3;
					end 
					 if ((11<(560-x_position)<28) && (ball_dir == southwest) && (12<(team2_ver_pos)-(y_position) < 28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 
					// ball collides to player1 from wall_3
					 if (((560-x_position)<=12) && (ball_dir == southwest) && ((y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end
				   if (((560-x_position)<=12) && (ball_dir == northwest) && ((y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 	
					
				   // ball collides to player1 from wall_4
					 if ((11<(560-x_position)<28) && (ball_dir == northwest) && (12<(y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end
				    if ((12<(560-x_position)<28) && (ball_dir == northeast) && (12<(y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 	
			      
					// ball collides to player1 from wall_5
					else if (((x_position-560)<=12) && (ball_dir == northwest) && (((y_position)-(team2_ver_pos)<28))) begin
						ball_dir <= southeast;
						x_position <= x_position-1;
						y_position <= y_position +1;
					end
					 if (((x_position-560)<=12) && (ball_dir == northwest) && (((y_position)-(team2_ver_pos)<28))) begin
						ball_dir <= southwest;
						x_position <= x_position+1;
						y_position <= y_position +1;
					end
			
					//ball collides to player1 from wall6
					 if ((12<=(x_position-560)<28) && (ball_dir == southeast) && ((12<((y_position)-(team2_ver_pos)))<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					else if ((12<=((x_position)-560)<28) && (ball_dir == northeast) && (12<((y_position)-(team2_ver_pos)))< 28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end
					// ball collides to player1 from wall_7
					 if (((x_position-560)<= 12) && (ball_dir == northeast) && ((((team2_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					 if ((((x_position)-560)<12) && (ball_dir == southeast) && ((((team2_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					
					else if (((x_position-560)< 12) && (ball_dir == southeast) && ((((team2_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
					end 
			// ball collides to player 1 from wall_8
		          if ((12<(x_position-560)<28) && (ball_dir == southeast) && ((12<(team2_ver_pos)-(y_position)))<28) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 
					 if ((12<((x_position)-560)<28) && (ball_dir == southwest) && ((12<(team2_ver_pos)-(y_position)))<28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					end
		// for horizontal players
					//for team 1
					 if ((((team1_hor_pos) - (x_position))**2 + (380 - y_position)**2 < (((BALL_RADIUS)+(PLAYER_RADIUS)+1)**2)) && ball_collution == 0 ) begin
					ball_collution =1;
					// ball collides to player1 from wall_1
					if ((380-y_position)<12 && (ball_dir == southeast) && (((team1_hor_pos)-x_position))<28) begin
						ball_dir <= northeast;
						x_position <= x_position-1;
						y_position <= y_position -1;
					end 
					 if ((380-y_position)<=12 && (ball_dir == southwest)&& (((team1_hor_pos)- x_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					
					// ball collides to player 1 from wall_2
				   else if (13<(380-y_position)<28 && (ball_dir == northwest)&& (12<((team1_hor_pos)- x_position)) < 28) begin
						ball_dir <= northeast;
						x_position <= x_position-3;
						y_position <= y_position -3;
					end 
					 if ((12<(380-y_position)<28) && (ball_dir == southwest) && (12<(team1_hor_pos)-(x_position) < 28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 
					// ball collides to player1 from wall_3
					 if (((380-y_position)<=12) && (ball_dir == southwest) && ((x_position)-(team1_hor_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end
				    if (((380-y_position)<=12) && (ball_dir == northwest) && ((x_position)-(team1_hor_pos)<28)) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 	
					
				   // ball collides to player1 from wall_4
					 if ((12<(380-y_position)<28) && (ball_dir == northwest) && (11<(x_position)-(team1_hor_pos)<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end
				    if ((12<(380-y_position)<28) && (ball_dir == northeast) && (11<(x_position)-(team1_hor_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 	
			      
					// ball collides to player1 from wall_5
					else if (((y_position-380)<=12) && (ball_dir == northwest) && (((x_position)-(team1_hor_pos)<28))) begin
						ball_dir <= southeast;
						x_position <= x_position-1;
						y_position <= y_position +1;
					end
					 if (((y_position-380)<=12) && (ball_dir == northwest) && (((x_position)-(team1_hor_pos)<28))) begin
						ball_dir <= southwest;
						x_position <= x_position+1;
						y_position <= y_position +1;
					end
			
					//ball collides to player1 from wall6
					 if ((12<(y_position-380)<28) && (ball_dir == southeast) && ((12<((x_position)-(team1_hor_pos)))<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					 if ((12<((y_position)-380)<28) && (ball_dir == northeast) && (12<((x_position)-(team1_hor_pos)))< 28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end
					// ball collides to player1 from wall_7
					 if (((y_position-380)<= 12) && (ball_dir == northeast) && ((((team1_hor_pos)-(x_position)))< 28)) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					 if ((((y_position)-380)<12) && (ball_dir == southeast) && ((((team1_hor_pos)-(x_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					
			// ball collides to player 1 from wall_8
		         
					 if ((12<((y_position)-380)<28) && (ball_dir == southwest) && ((12<(team1_hor_pos)-(x_position)))<28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					end
		//for team2 ver player	
			 else if ((((team2_hor_pos) - (x_position))**2 + (180 - y_position)**2 < (((BALL_RADIUS)+(PLAYER_RADIUS)+1)**2))&& (ball_collution== 0)) begin
				ball_collution =1;
			
					// ball collides to player2 from wall_1
					if ((180-y_position)<=12 && (ball_dir == southeast) && (((team2_hor_pos)-x_position))<28) begin
						ball_dir <= northeast;
						x_position <= x_position-1;
						y_position <= y_position -1;
					end 
					 if ((180-y_position)<=12 && (ball_dir == southwest)&& (((team2_hor_pos)- x_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					
					// ball collides to player2 from wall_2
				    if (12<(180-y_position)<28 && (ball_dir == northwest)&& (12<((team2_hor_pos)- x_position)) < 28) begin
						ball_dir <= northeast;
						x_position <= x_position-3;
						y_position <= y_position -3;
					end 
					 if ((11<(180-y_position)<28) && (ball_dir == southwest) && (12<(team2_hor_pos)-(x_position) < 28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 
					// ball collides to player2 from wall_3
					 if (((180-y_position)<=12) && (ball_dir == southwest) && ((x_position)-(team2_hor_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end
				    if (((180-y_position)<=12) && (ball_dir == northwest) && ((x_position)-(team2_hor_pos)<28)) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 	
					
				   // ball collides to player2 from wall_4
					 if ((11<(180-y_position)<28) && (ball_dir == northwest) && (12<(x_position)-(team2_hor_pos)<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end
				    if ((12<(180-y_position)<28) && (ball_dir == northeast) && (12<(x_position)-(team2_hor_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 	
			      
					// ball collides to player2 from wall_5
					 if (((y_position-180)<=12) && (ball_dir == northwest) && (((x_position)-(team2_hor_pos)<28))) begin
						ball_dir <= southeast;
						x_position <= x_position-1;
						y_position <= y_position +1;
					end
					 if (((y_position-180)<=12) && (ball_dir == northwest) && (((x_position)-(team2_hor_pos)<28))) begin
						ball_dir <= southwest;
						x_position <= x_position+1;
						y_position <= y_position +1;
					end
					//ball collides to player2 from wall6
					 if ((12<=(y_position-180)<28) && (ball_dir == southeast) && ((12<((x_position)-(team2_hor_pos)))<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					 if ((12<=((y_position)-180)<28) && (ball_dir == northeast) && (12<((x_position)-(team2_hor_pos)))< 28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end
					// ball collides to player2 from wall_7
					 if (((y_position-180)<= 12) && (ball_dir == northeast) && ((((team2_hor_pos)-(x_position)))< 28)) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					 if ((((y_position)-180)<12) && (ball_dir == southeast) && ((((team2_hor_pos)-(x_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					
					 if (((y_position-180)< 12) && (ball_dir == southeast) && ((((team2_hor_pos)-(x_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
					end 
			// ball collides to player 2 from wall_8
		          if ((12<(y_position-180)<28) && (ball_dir == southeast) && ((12<(team2_hor_pos)-(x_position)))<28) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 
					 if ((12<((y_position)-180)<28) && (ball_dir == southwest) && ((12<(team2_hor_pos)-(x_position)))<28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					end 
	end
	//cansu 
	always @(posedge clk) begin
	case (state)
	beginning : begin
		x_position     <=  463;
		y_position     <=  275;
		ball_dir       = southwest;
	end
	active : begin
	         
	//ball movement
					
						ball_collution = 0;
				 //if (counter =='d98) begin
					if ( (ball_dir == northeast) ) begin
						x_position <= x_position -1;
						y_position <= y_position -1;
					end else if ((ball_dir == northwest) ) begin
						x_position <= x_position + 1;
						y_position <= y_position - 1;
					end else if ((ball_dir == southwest) ) begin 
						x_position <= x_position + 1;
						y_position <= y_position +1;
					
					end else if ((ball_dir == southeast)) begin 
						x_position <= x_position - 1;
						y_position <= y_position +1;
					end
				   end 
					//end
					
	
	endcase 
	end 
	

endmodule
