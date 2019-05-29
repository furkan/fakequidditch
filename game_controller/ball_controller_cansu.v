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

//	input [9:0] team1_hor_pos,

	input [9:0] team2_ver_pos,
// team2_ver_player_hor_pos = 560

//	input [9:0] team2_hor_pos,

	input team1_vu_button,
	input team1_vd_button,
	input team2_vu_button,
	input team2_vd_button,
	
	output reg score_to_team1,
	output reg score_to_team2,
	output reg [9:0] x_position,
	output reg [9:0] y_position,
	output reg [9:0] x_blugger,
	output reg [9:0] y_blugger,
	output reg game_on
);

	/*reg [1:0] ball_dir_x; 
	
	parameter x_right = 'd0;
	parameter x_left = 'd1;
	
	reg [1:0] ball_dir_y;
	parameter y_up ='d0;
	parameter y_down = 'd1; */
	
	reg[2:0] ball_dir;
	parameter north ='d0;
	parameter south  ='d1;
	parameter east 	='d2;
	parameter west  ='d3;
	parameter southwest ='d4;
	parameter southeast ='d5;
	parameter northeast ='d6;
	parameter northwest ='d7;
 
	integer ball_collution;
	integer a;
	integer inside_goal = (GOAL_RADIUS - BALL_RADIUS) ** 2;
	
	integer cansu;

	reg [1:0] state;
	
	parameter beginning   = 'd0;
	parameter active      = 'd1;
	
	reg [1:0] state_blugger;
	
	parameter initial_blugger ='d0;
	parameter active_blugger ='d1;
	
	
	integer counter;
	
	initial begin 
		state          = beginning;
		counter        =    0;
		x_position     =  463;
		y_position     =  275;
		score_to_team1 =    0;
		score_to_team2 =    0;
		ball_dir 		= southwest;
		ball_collution = 0;
		cansu				= 1;
		game_on        = 0;
		
		//x_positions = {10'b0 + 'd463, 10'b0 + 'd463, 10'b0 + 463};
		//y_positions = {10'b0 + 'd275, 10'b0 + 'd275, 10'b0 + 275};
	
		//x_blugger = ;
		//y_blugger = ;
	end

	always @(posedge clk) begin
		if (counter < MOVEMENT_FREQUENCY) begin
			counter <= counter + 'd1;
		end else begin
			counter <= 0;
		end
	end 
	
	// ball movement freely and at the boundries cansu
	always @(posedge clk) begin
		if ((team1_vu_button ==1) && (team1_vd_button ==1) && (team2_vu_button ==1) && (team2_vd_button==1)&& (cansu ==1)) begin
				state = beginning;
		end else if ((((y_position-450)**2)+((x_position-300)**2) < inside_goal) // BLUE GOAL 1
					|| (((y_position-450)**2)+((x_position-400)**2) < inside_goal) // BLUE GOAL 2
					|| (((y_position-450)**2)+((x_position-500)**2) < inside_goal) // BLUE GOAL 3
			) begin
				state = beginning;
				cansu=1;
				//score_to_team2 <= ((score_to_team2) +1);
		end else if ((((y_position-100)**2)+((x_position-300)**2) < inside_goal) // RED  GOAL 1
					|| (((y_position-100)**2)+((x_position-400)**2) < inside_goal) // RED  GOAL 2
					|| (((y_position-100)**2)+((x_position-500)**2) < inside_goal) // RED  GOAL 3
			) begin
				state = beginning;
				cansu=1;
				score_to_team1 <= ((score_to_team1)+1);
/*		end else if (game_over == 1) begin
			state = beginning;
			cansu = 1;
*/		end else begin
			state = active;
			cansu =0;
			game_on <= 1;
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
	         //lower boundary
				if ((y_position > 510 - BALL_RADIUS ) && (ball_dir== southeast ) ) begin
					ball_dir <= northeast;
				end
				else if ((y_position > 510 - BALL_RADIUS ) && (ball_dir== southwest ) ) begin
					ball_dir <= northwest;
				end
				else if ((y_position > 510 - BALL_RADIUS ) && (ball_dir== south ) ) begin
					ball_dir <= north;
				end
				//upper boundary
				else if ((y_position < 36 + BALL_RADIUS) && (ball_dir == north)) begin
					ball_dir <= south;
				end 
				else if ((y_position < 36 + BALL_RADIUS) && (ball_dir == northeast)) begin
					ball_dir <= southeast;
				end 
				else if ((y_position < 36 + BALL_RADIUS) && (ball_dir == northwest)) begin
					ball_dir <= southwest;
				end 
				// left boundary condition
				else if((x_position < 150 + BALL_RADIUS) && (ball_dir==east ) ) begin
					ball_dir <= west;
				end
			   else if((x_position < 150 + BALL_RADIUS) && (ball_dir==northeast ) ) begin
					ball_dir <= northwest;
				end 
			   else if((x_position < 150 + BALL_RADIUS) && (ball_dir==southeast ) ) begin
					ball_dir <= southwest;
				end 	
				// right boundary condition
				else if((x_position > 661 - BALL_RADIUS) && (ball_dir == west)) begin
					ball_dir <= east;
				end
				else if((x_position > 661 - BALL_RADIUS) && (ball_dir == northwest)) begin
					ball_dir <= northeast;
				end
				else if((x_position > 661 - BALL_RADIUS) && (ball_dir == southwest)) begin
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
					else if ((240-x_position)<=12 && (ball_dir == southwest)&& (((team1_ver_pos)- y_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					else if ((240-x_position)<=12 && (ball_dir == south)&& (((team1_ver_pos)- y_position))<28) begin
						ball_dir <= north;
						y_position <= y_position-1;
					end 
					// ball collides to player 1 from wall_2
				   else if (13<(240-x_position)<28 && (ball_dir == northwest)&& (12<((team1_ver_pos)- y_position)) < 28) begin
						ball_dir <= northeast;
						x_position <= x_position-3;
						y_position <= y_position -3;
					end 
					else if ((12<(240-x_position)<28) && (ball_dir == southwest) && (12<(team1_ver_pos)-(y_position) < 28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 
					// ball collides to player1 from wall_3
					else if (((240-x_position)<=12) && (ball_dir == southwest) && ((y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end
				   else if (((240-x_position)<=12) && (ball_dir == northwest) && ((y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 	
					else if (((240-x_position)<=12) && (ball_dir == west) && ((y_position)-(team1_ver_pos)<=28)) begin
						ball_dir <= east;
						x_position <= x_position -1;
						
					end
				   // ball collides to player1 from wall_4
					else if ((12<(240-x_position)<28) && (ball_dir == northwest) && (11<(y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end
				   else if ((12<(240-x_position)<28) && (ball_dir == northeast) && (11<(y_position)-(team1_ver_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 	
			      
					// ball collides to player1 from wall_5
					else if (((x_position-240)<=12) && (ball_dir == northwest) && (((y_position)-(team1_ver_pos)<28))) begin
						ball_dir <= southeast;
						x_position <= x_position-1;
						y_position <= y_position +1;
					end
					else if (((x_position-240)<=12) && (ball_dir == northwest) && (((y_position)-(team1_ver_pos)<28))) begin
						ball_dir <= southwest;
						x_position <= x_position+1;
						y_position <= y_position +1;
					end
			else if (((x_position-240)<=12) && (ball_dir == north) && (((y_position)-(team1_ver_pos)<28))) begin
						ball_dir <= south;
						
						y_position <= y_position +1;
					end
					//ball collides to player1 from wall6
					else if ((12<(x_position-240)<28) && (ball_dir == southeast) && ((12<((y_position)-(team1_ver_pos)))<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					else if ((12<((x_position)-240)<28) && (ball_dir == northeast) && (12<((y_position)-(team1_ver_pos)))< 28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end
					// ball collides to player1 from wall_7
					else if (((x_position-240)<= 12) && (ball_dir == northeast) && ((((team1_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					else if ((((x_position)-240)<12) && (ball_dir == southeast) && ((((team1_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					else if (((x_position-240)<= 12) && (ball_dir == east) && ((((team1_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= west;
						x_position <= x_position +1;
					
					end 
			// ball collides to player 1 from wall_8
		         else if ((12<(x_position-240)<28) && (ball_dir == southeast) && ((12<(team1_ver_pos)-(y_position)))<28) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 
					else if ((12<((x_position)-240)<28) && (ball_dir == southwest) && ((12<(team1_ver_pos)-(y_position)))<28) begin
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
					else if ((x_position-560)<=12 && (ball_dir == southeast) && (((team2_ver_pos)-y_position))<28) begin
						ball_dir <= northeast;
						x_position <= x_position-1;
						y_position <= y_position -1;
					end 
					else if ((560-x_position)<=12 && (ball_dir == southwest)&& (((team2_ver_pos)- y_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					else if ((x_position-560)<=12 && (ball_dir == southwest)&& (((team2_ver_pos)- y_position))<28) begin
						ball_dir <= northwest;
						x_position <= x_position+1;
						y_position <= y_position-1;
					end 
					else if ((560-x_position)<=12 && (ball_dir == south)&& (((team2_ver_pos)- y_position))<28) begin
						ball_dir <= north;
						y_position <= y_position-1;
					end 
					else if ((x_position-560)<=12 && (ball_dir == south)&& (((team2_ver_pos)- y_position))<28) begin
						ball_dir <= north;
						y_position <= y_position-1;
					end 
					// ball collides to player 1 from wall_2
				   else if (12<(560-x_position)<28 && (ball_dir == northwest)&& (12<((team2_ver_pos)- y_position)) < 28) begin
						ball_dir <= northeast;
						x_position <= x_position-3;
						y_position <= y_position -3;
					end 
					else if ((11<(560-x_position)<28) && (ball_dir == southwest) && (12<(team2_ver_pos)-(y_position) < 28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end 
					// ball collides to player1 from wall_3
					else if (((560-x_position)<=12) && (ball_dir == southwest) && ((y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= southeast;
						x_position <= x_position -1;
						y_position <= y_position +1;
					end
				   else if (((560-x_position)<=12) && (ball_dir == northwest) && ((y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 	
					else if (((560-x_position)<=12) && (ball_dir == west) && ((y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= east;
						x_position <= x_position -1;
						
					end
				   // ball collides to player1 from wall_4
					else if ((11<(560-x_position)<28) && (ball_dir == northwest) && (12<(y_position)-(team2_ver_pos)<28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end
				   else if ((12<(560-x_position)<28) && (ball_dir == northeast) && (12<(y_position)-(team2_ver_pos)<28)) begin
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
					else if (((x_position-560)<=12) && (ball_dir == northwest) && (((y_position)-(team2_ver_pos)<28))) begin
						ball_dir <= southwest;
						x_position <= x_position+1;
						y_position <= y_position +1;
					end
			else if (((x_position-560)<=12) && (ball_dir == north) && (((y_position)-(team2_ver_pos)<28))) begin
						ball_dir <= south;
						
						y_position <= y_position +1;
					end
					//ball collides to player1 from wall6
					else if ((12<=(x_position-560)<28) && (ball_dir == southeast) && ((12<((y_position)-(team2_ver_pos)))<28)) begin
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
					else if (((x_position-560)<= 12) && (ball_dir == northeast) && ((((team2_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					else if ((((x_position)-560)<12) && (ball_dir == southeast) && ((((team2_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
						y_position <= y_position +1;
					end 
					else if (((x_position-560)< 12) && (ball_dir == east) && ((((team2_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= west;
						x_position <= x_position +1;
						end
					else if (((x_position-560)< 12) && (ball_dir == southeast) && ((((team2_ver_pos)-(y_position)))< 28)) begin
						ball_dir <= southwest;
						x_position <= x_position +1;
					end 
			// ball collides to player 1 from wall_8
		         else if ((12<(x_position-560)<28) && (ball_dir == southeast) && ((12<(team2_ver_pos)-(y_position)))<28) begin
						ball_dir <= northeast;
						x_position <= x_position -1;
						y_position <= y_position -1;
					end 
					else if ((12<((x_position)-560)<28) && (ball_dir == southwest) && ((12<(team2_ver_pos)-(y_position)))<28) begin
						ball_dir <= northwest;
						x_position <= x_position +1;
						y_position <= y_position -1;
					end 
					end
	//ball movement
					else  begin
						ball_collution = 0;
					if ((ball_dir == south)&& (counter == 'd98)) begin
						y_position <= y_position +1;
					end
					else if ( (ball_dir == north) && (counter == 'd98)) begin
						
						y_position <= y_position - 1;
					end else if ((ball_dir == east) && (counter == 'd98)) begin
						x_position <= x_position - 1;
						
					end else if ((ball_dir == west) && (counter == 'd98)) begin 
						x_position <= x_position + 1;
						
					end
						else if ( (ball_dir == northeast) && (counter == 'd98)) begin
						x_position <= x_position -1;
						y_position <= y_position -1;
					end else if ((ball_dir == northwest) && (counter == 'd98)) begin
						x_position <= x_position + 1;
						y_position <= y_position - 1;
					end else if ((ball_dir == southwest) && (counter == 'd98)) begin 
						x_position <= x_position + 1;
						y_position <= y_position +1;
					
					end else if ((ball_dir == southeast) && (counter == 'd98)) begin 
						x_position <= x_position - 1;
						y_position <= y_position +1;
					end
				   end //for else
					
	end
	endcase 
	end
	// bluger
	/*always @ (posedge clk) begin
	if ((team1_vu_button ==1) && (team1_vd_button ==1) && (team2_vu_button ==1) && (team2_vd_button==1)) begin
			state_blugger = initial_blugger;
		end else if ( (team1_vu_button == 0 )|| (team1_vd_button == 0)|| (team2_vu_button == 0) || (team2_vd_button == 0)) begin
		state_blugger =active_blugger;
			//lower boundry
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

endmodule