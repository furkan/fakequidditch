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
	
	//output reg score_to_team1,
	//output reg score_to_team2,
	output reg [9:0] x_position,
	output reg [9:0] y_position,
	output reg game_on
);

	reg[1:0] ball_dir_x;
	parameter x_right ='d0;
	parameter x_left ='d1;
	
	reg [1:0] ball_dir_y;
	parameter y_up ='d2;
	parameter y_down ='d3;
	
	integer ball_collution;
	integer a;
	integer inside_goal = (GOAL_RADIUS - BALL_RADIUS) ** 2;
	
	integer cansu;

	reg [1:0] state;
	
	parameter beginning   = 'd0;
	parameter active      = 'd1;

	
	integer counter;
	
	initial begin 
		state          = beginning;
		counter        =    0;
		x_position     =  463;
		y_position     =  275;
		//score_to_team1 =    0;
		//score_to_team2 =    0;
		ball_dir_x 		= x_left;
		ball_dir_y     = y_down;
		ball_collution = 0;
		cansu				= 1;
		game_on        = 0;
	
	end
   // counter for the ball position change
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
				//Fscore_to_team1 <= ((score_to_team1)+1);
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
		ball_dir_x      = x_left;
		ball_dir_y      = y_down;
	end
	active : begin
	         //lower boundary
				if ((y_position > 510 - BALL_RADIUS ) && (ball_dir_y == y_down) ) begin
					ball_dir_x <= ball_dir_x;
					ball_dir_y <= y_up ;
				end
			
				//upper boundary
				
				else if ((y_position < 36 + BALL_RADIUS) && (ball_dir_y == y_up)) begin
					ball_dir_x <= ball_dir_x;
					ball_dir_y <= y_down ;
				end 
		
				// left boundary condition
				else if((x_position < 150 + BALL_RADIUS) && (ball_dir_x == x_left  ) ) begin
					ball_dir_y <= ball_dir_y;
					ball_dir_x <= x_right;
				end
			   
				// right boundary condition
				else if((x_position > 661 - BALL_RADIUS) && (ball_dir_x == x_right)) begin
					ball_dir_x <= x_left;
					ball_dir_y <= ball_dir_y;
				end
			
// ball movement freely
			  else  begin
						ball_collution = 0;
					if ((ball_dir_y == y_down)&& (counter == 'd98)) begin
						y_position <= y_position +1;
					end
					if ( (ball_dir_y == y_up) && (counter == 'd98)) begin
						
						y_position <= y_position - 1;
					end if ((ball_dir_x == x_right) && (counter == 'd98)) begin
						x_position <= x_position - 1;
						
					end if ((ball_dir_x == x_left) && (counter == 'd98)) begin 
						x_position <= x_position + 1;
						
					end
				
				   end 
					
      end
		endcase 
	end
	
endmodule
