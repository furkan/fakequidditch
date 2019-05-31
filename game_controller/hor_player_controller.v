module hor_player_controller #(
	parameter PLAYER_RADIUS,		// 25 px works
	parameter INITIAL_HOR_POS,		// 
	parameter VER_POS,
	parameter MOVEMENT_FREQUENCY,	// inversely proportinal to speed ('d200000 works)
	parameter BLOCKING_BALL_X
)
(	input clk,

	input hl_button,
	input hr_button,
	
	input [9:0] BLOCKING_BALL_Y,
	
	output reg [9:0] hor_pos
);

	// Horizontal player movements
	reg [1:0] hor_state;
	
	parameter float = 'd0;
	parameter  left = 'd1;
	parameter right = 'd2;
	
	reg can_move_left, can_move_right;
	
	integer left_button_counter, right_button_counter;
	
	initial begin 
		hor_state         = float;
		hor_pos = INITIAL_HOR_POS;
		left_button_counter  =   0;
		right_button_counter =   0;
		can_move_left        =   1;
		can_move_right       =   1;
	end

	// State transitions

	always @(posedge clk) begin
		if (hl_button == hr_button) begin
			hor_state = float;
		end else if (hl_button == 0) begin
			hor_state = left;
		end else begin
			hor_state = right;
		end
	end
	
	always @(posedge clk) begin
		if (hl_button == 0 && left_button_counter < MOVEMENT_FREQUENCY) begin
			left_button_counter <= left_button_counter + 'd1;
		end else begin
			left_button_counter <= 0;
		end
		
		if (hr_button == 0 && right_button_counter < MOVEMENT_FREQUENCY) begin
			right_button_counter <= right_button_counter + 'd1;
		end else begin
			right_button_counter <= 0;
		end
	end
	
	always @(posedge clk) begin
		case (hor_state)
			float: begin
				hor_pos <= hor_pos;
			end
			left: begin
				if (hor_pos > (144 + PLAYER_RADIUS) && left_button_counter  == 'd98 && can_move_left  == 1) hor_pos <= hor_pos - 1;
			end
			right: begin
				if (hor_pos < (660 - PLAYER_RADIUS) && right_button_counter == 'd98 && can_move_right == 1) hor_pos <= hor_pos + 1;
			end
		endcase
	end
	
	always @(posedge clk) begin
		if ((VER_POS - BLOCKING_BALL_Y)**2 + (hor_pos - BLOCKING_BALL_X)**2 < (PLAYER_RADIUS + PLAYER_RADIUS + 2)**2) begin
			if (hor_pos > BLOCKING_BALL_X) begin
				can_move_left  <= 0;
			end else begin
				can_move_right <= 0;
			end			
		end else begin
			can_move_left  <= 1;
			can_move_right <= 1;
		end
	end

endmodule