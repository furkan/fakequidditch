module hor_player_controller #(
	parameter PLAYER_RADIUS,		// 25 px works
	parameter INITIAL_HOR_POS,		// 
	parameter MOVEMENT_FREQUENCY	// inversely proportinal to speed ('d200000 works)
)
(	input clk,
	input hl_button,
	input hr_button,
	output reg [9:0] hor_pos
);

	// Horizontal player movements
	reg [1:0] hor_state;
	
	parameter float = 'd0;
	parameter  left = 'd1;
	parameter right = 'd2;

	integer left_button_counter, right_button_counter;
	
	initial begin 
		hor_state         = float;
		hor_pos = INITIAL_HOR_POS;
		left_button_counter  =   0;
		right_button_counter =   0;
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
				if (hor_pos > (144 + PLAYER_RADIUS) && left_button_counter == 'd98) hor_pos <= hor_pos - 1;
			end
			right: begin
				if (hor_pos < (660 - PLAYER_RADIUS) && right_button_counter == 'd98) hor_pos <= hor_pos + 1;
			end
		endcase
	end

endmodule