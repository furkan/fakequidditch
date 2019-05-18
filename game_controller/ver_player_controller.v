module ver_player_controller #(
	parameter PLAYER_RADIUS,		// 35 px works
	parameter INITIAL_VER_POS,		// 'd200 works
	parameter MOVEMENT_FREQUENCY	// inversely proportinal to speed ('d200000 works)
)
(	input clk,
	input vu_button,
	input vd_button,
	output reg [9:0] ver_pos
);

	// Vertical player movements
	reg [1:0] ver_state;
	
	parameter float = 'd0;
	parameter    up = 'd1;
	parameter  down = 'd2;

	integer up_button_counter, down_button_counter;
	
	initial begin 
		ver_state         = float;
		ver_pos = INITIAL_VER_POS;
		up_button_counter   =   0;
		down_button_counter =   0;
	end

	// State transitions

	always @(posedge clk) begin
		if (vu_button == vd_button) begin
			ver_state = float;
		end else if (vu_button == 0) begin
			ver_state = up;
		end else begin
			ver_state = down;
		end
	end
	
	always @(posedge clk) begin
		if (vu_button == 0 && up_button_counter < MOVEMENT_FREQUENCY) begin
			up_button_counter <= up_button_counter + 'd1;
		end else begin
			up_button_counter <= 0;
		end
		
		if (vd_button == 0 && down_button_counter < MOVEMENT_FREQUENCY) begin
			down_button_counter <= down_button_counter + 'd1;
		end else begin
			down_button_counter <= 0;
		end
	end

	// State machine

	always @(posedge clk) begin
		case (ver_state)
			float: begin
				ver_pos <= ver_pos;
			end
			up: begin
				if (ver_pos > (36 + PLAYER_RADIUS) && up_button_counter == 'd98) ver_pos <= ver_pos - 1;
			end
			down: begin
				if (ver_pos < (510 - PLAYER_RADIUS) && down_button_counter == 'd98) ver_pos <= ver_pos + 1;
			end
		endcase
	end

endmodule