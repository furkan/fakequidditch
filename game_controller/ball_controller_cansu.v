module ball_controller_cansu #(
	parameter PLAYER_RADIUS,		// 35 px works
	parameter BALL_RADIUS,
	parameter GOAL_RADIUS,
	parameter MOVEMENT_FREQUENCY	// inversely proportinal to speed ('d200000 works)
)
(
	input clk,
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
	output reg [18:0] x_position,
	output reg [18:0] y_position,
	output reg [9:0] x_blugger,
	output reg [9:0] y_blugger
);

	/*reg [1:0] ball_dir_x; 
	
	parameter x_right = 'd0;
	parameter x_left = 'd1;
	
	reg [1:0] ball_dir_y;
	parameter y_up ='d0;
	parameter y_down = 'd1; */
	
	reg[4:0] ball_dir_state;
	parameter north          =  'd0;	// north
	parameter northeastnorth =  'd1;	// northeastnorth
	parameter northeast      =  'd2;	// northeast
	parameter northeasteast  =  'd3;	// northeasteast
	parameter east           =  'd4;	// east
	parameter southeasteast  =  'd5;	// southeasteast
	parameter southeast      =  'd6;	// southeast
	parameter southeastsouth =  'd7;	// southeastsouth
	parameter south          =  'd8;	// south
	parameter southwestsouth =  'd9;	// southwestsouth
	parameter southwest      = 'd10;	// southwest
	parameter southwestwest  = 'd11;	// southwestwest
	parameter west           = 'd12;	// west
	parameter northwestwest  = 'd13;	// northwestwest
	parameter northwest      = 'd14;	// northwest
	parameter northwestnorth = 'd15;	// northwestnorth
	
	// ball directions
	
	reg [9:0] cos22_50 = 10'b0_011000100;
	reg [9:0] cos45_00 = 10'b0_101101010;
	reg [9:0] cos67_50 = 10'b0_111011001;
	
	// polygon corner x positions: PLAYER_RADIUS * cos(a)
	
	reg [9:0] cos11_25 = 10'b0_111110110;
	reg [9:0] cos33_75 = 10'b0_110101001;
	reg [9:0] cos56_25 = 10'b0_100011100;
	reg [9:0] cos78_75 = 10'b0_001100011;
	
	reg signed [9:0] ball_dir_x;
	reg signed [9:0] ball_dir_y;
	
	integer ball_collission;
	integer inside_goal = (GOAL_RADIUS - BALL_RADIUS) ** 2;
	
	integer idle;

	reg [1:0] state;
	
	parameter beginning   = 'd0;
	parameter active      = 'd1;
	
	reg [1:0] state_blugger;
	
	parameter initial_blugger ='d0;
	parameter active_blugger ='d1;
	
	reg [30:0] x_positions;
	reg [30:0] y_positions;
	integer counter;
	
	initial begin 
		state          = beginning;
		counter        =    0;
		x_position     =  463;
		y_position     =  275;
		score_to_team1 =    0;
		score_to_team2 =    0;
		ball_dir_state = southeasteast;
		ball_collission = 0;
		idle				= 1;
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
		if ((team1_vu_button ==1) && (team1_vd_button ==1 && (team2_vu_button ==1) && (team2_vd_button==1))&& idle ==1) begin
			state = beginning;
		end
		else if ((((y_position-450)**2)+((x_position-300)**2) < inside_goal) // BLUE GOAL 1
					|| (((y_position-450)**2)+((x_position-400)**2) < inside_goal) // BLUE GOAL 2
					|| (((y_position-450)**2)+((x_position-500)**2) < inside_goal) // BLUE GOAL 3
		) begin
			state = beginning;
			idle=1;
			//score_to_team2 <= ((score_to_team2) +1);
		end
		else if ((((y_position-100)**2)+((x_position-300)**2) < inside_goal) // RED  GOAL 1
					|| (((y_position-100)**2)+((x_position-400)**2) < inside_goal) // RED  GOAL 2
					|| (((y_position-100)**2)+((x_position-500)**2) < inside_goal) // RED  GOAL 3
		) begin
			state = beginning;
			idle=1;
			//score_to_team1 <= ((score_to_team1)+1);
		end	
		else begin
			state = active;
			idle =0;
		end
	end 
			
	//cansu 
	always @(posedge clk) begin
		case (state)
			beginning : begin
				x_position = 463;
				y_position = 275;
			end
			active : begin
			
			// upper and lower boundaries
				if ((y_position > 510 - BALL_RADIUS ) || (y_position < 36 + BALL_RADIUS)) begin 
					ball_dir_state <= 'd8 - ball_dir_state;
				end
			// right and left boundaries
				else if((x_position < 150 + BALL_RADIUS) || (x_position > 680 - BALL_RADIUS) ) begin 
						ball_dir_state <= -ball_dir_state;
				end
				
			// collision with team1 vertical player
				else if ((((team1_ver_pos) - (y_position))**2 + (240 - x_position)**2 < (((BALL_RADIUS)+(PLAYER_RADIUS)+1)**2)) && ball_collission == 0 ) begin
					
					ball_collission = 1;
					
						// east wall
					if ((x_position - 240 > (PLAYER_RADIUS + BALL_RADIUS) * cos11_25) && ball_dir_state > 'd8) begin
						if (ball_dir_state > 'd8) begin
							ball_dir_state <= -ball_dir_state;
						end
					end 
					
					else if (x_position - 240 > (PLAYER_RADIUS + BALL_RADIUS) * cos33_75) begin
						// northeasteast wall
						if (y_position > team1_ver_pos && ball_dir_state > 'd7) begin
							ball_dir_state <= 'd14 - ball_dir_state;
						end
						// southeasteast wall
						if (y_position < team1_ver_pos && (ball_dir_state > 'd9 || ball_dir_state == 'd0)) begin
							ball_dir_state <= 'd2 - ball_dir_state;
						end 
					end 
					
					else if (x_position - 240 > (PLAYER_RADIUS + BALL_RADIUS) * cos56_25) begin
						// northeast wall
						if (y_position > team1_ver_pos && (ball_dir_state + 'd1 > 'd7)) begin
							ball_dir_state <= 'd12 - ball_dir_state;
						end
						// southeast wall
						if (y_position < team1_ver_pos && ((ball_dir_state - 'd1 > 'd9) || (ball_dir_state - 'd1 == 'd0))) begin
							ball_dir_state <= 'd4 - ball_dir_state;
						end						
					end
					
					else if (x_position - 240 > (PLAYER_RADIUS + BALL_RADIUS) * cos78_75) begin
						// northeastnorth wall
						if (y_position > team1_ver_pos && (ball_dir_state + 'd2 > 'd7)) begin
							ball_dir_state <= 'd10 - ball_dir_state;
						end
						// southeastsouth wall
						if (y_position < team1_ver_pos && ((ball_dir_state - 'd2 > 'd9) || (ball_dir_state - 'd2 == 'd0))) begin
							ball_dir_state <= 'd6 - ball_dir_state;
						end
					end
					
					else if (240-x_position < (PLAYER_RADIUS + BALL_RADIUS) * cos78_75) begin
						// north wall
						if (y_position > team1_ver_pos && (ball_dir_state + 'd3 > 'd7)) begin
							ball_dir_state <= 'd8 - ball_dir_state;
						end
						// south wall
						if (y_position < team1_ver_pos && ((ball_dir_state - 'd3 > 'd9) || (ball_dir_state - 'd3 == 'd0))) begin
							ball_dir_state <= 'd8 - ball_dir_state;
						end
					end
					
					else if (240-x_position < (PLAYER_RADIUS + BALL_RADIUS) * cos56_25) begin
						// northwestnorth wall
						if (y_position > team1_ver_pos && (ball_dir_state + 'd4 > 'd7)) begin
							ball_dir_state <= 'd6 - ball_dir_state;
						end
						// southwestsouth wall
						if (y_position < team1_ver_pos && ((ball_dir_state - 'd4 > 'd9) || (ball_dir_state - 'd4 == 'd0))) begin
							ball_dir_state <= 'd10 - ball_dir_state;
						end
					end
					
					else if (240-x_position < (PLAYER_RADIUS + BALL_RADIUS) * cos33_75) begin
						// northwest wall
						if (y_position > team1_ver_pos && (ball_dir_state + 'd5 > 'd7)) begin
							ball_dir_state <= 'd4 - ball_dir_state;
						end
						// southwest wall
						if (y_position < team1_ver_pos && ((ball_dir_state - 'd5 > 'd9) || (ball_dir_state - 'd5 == 'd0))) begin
							ball_dir_state <= 'd12 - ball_dir_state;
						end
					end
					
					else if (240-x_position < (PLAYER_RADIUS + BALL_RADIUS) * cos11_25) begin
						// northwestwest wall
						if (y_position > team1_ver_pos && (ball_dir_state + 'd6 > 'd7)) begin
							ball_dir_state <= 'd2 - ball_dir_state;
						end
						// southwestwest wall
						if (y_position < team1_ver_pos && ((ball_dir_state - 'd6 > 'd9) || (ball_dir_state - 'd6 == 'd0))) begin
							ball_dir_state <= 'd14 - ball_dir_state;
						end
					end
					
					else begin
						if (ball_dir_state < 'd8) begin
							ball_dir_state <= -ball_dir_state;
						end
					end 
			end
		
			//ball movement
			else begin
			ball_collission = 0;
				if (counter == 'd98) begin
					x_position <= x_position + ball_dir_x;
					y_position <= y_position + ball_dir_y;
				end
			end
			
		end
	
		endcase 
	end  
	
	always begin
		case (ball_dir_state)
			north: begin
				ball_dir_x <= 'd0;
				ball_dir_y <= -'d1;
			end
			northeastnorth: begin
				ball_dir_x <= cos67_50;
				ball_dir_y <= -cos22_50;
			end
			northeast: begin
				ball_dir_x <= cos45_00;
				ball_dir_y <= -cos45_00;
			end
			northeasteast: begin
				ball_dir_x <= cos22_50;
				ball_dir_y <= -cos67_50;
			end
			east: begin
				ball_dir_x <= 'd1;
				ball_dir_y <= 'd0;
			end
			southeasteast: begin
				ball_dir_x <= cos22_50;
				ball_dir_y <= cos67_50;
			end
			southeast: begin
				ball_dir_x <= cos45_00;
				ball_dir_y <= cos45_00;
			end
			southeastsouth: begin
				ball_dir_x <= cos67_50;
				ball_dir_y <= cos22_50;
			end
			south: begin
				ball_dir_x <= 'd0;
				ball_dir_y <= 'd1;
			end
			southwestsouth: begin
				ball_dir_x <= -cos67_50;
				ball_dir_y <= cos22_50;
			end
			southwest: begin
				ball_dir_x <= -cos45_00;
				ball_dir_y <= cos45_00;
			end
			southwestwest: begin
				ball_dir_x <= -cos22_50;
				ball_dir_y <= cos67_50;
			end
			west: begin
				ball_dir_x <= -'d1;
				ball_dir_y <= 'd0;
			end
			northwestwest: begin
				ball_dir_x <= -cos22_50;
				ball_dir_y <= -cos67_50;
			end
			northwest: begin
				ball_dir_x <= -cos45_00;
				ball_dir_y <= -cos45_00;
			end
			northwestnorth: begin
				ball_dir_x <= -cos67_50;
				ball_dir_y <= -cos22_50;
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