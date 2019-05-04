module team2_controller (clk, team2_vu_button, team2_vd_button, team2_ver_pos);
	input clk;
	input team2_vu_button;
	input team2_vd_button;
	output reg [9:0] team2_ver_pos;

	// Vertical player movements
	reg [1:0] ver_state;

	parameter float = 'd0;
	parameter    up = 'd1;
	parameter  down = 'd2;

	integer up_button_counter, down_button_counter;
	
	initial begin 
		ver_state           = float;
		team2_ver_pos       = 'd300;
		up_button_counter   =     0;
		down_button_counter =     0;
	end

	// State transitions

	always @(posedge clk) begin
		if (team2_vu_button == team2_vd_button) begin
			ver_state = float;
		end else if (team2_vu_button == 0) begin
			ver_state = up;
		end else begin
			ver_state = down;
		end
	end
	
	always @(posedge clk) begin
		if (team2_vu_button == 0 && up_button_counter < 'd100000) begin
			up_button_counter <= up_button_counter + 'd1;
		end else begin
			up_button_counter <= 0;
		end
		
		if (team2_vd_button == 0 && down_button_counter < 'd100000) begin
			down_button_counter <= down_button_counter + 'd1;
		end else begin
			down_button_counter <= 0;
		end
	end

	// State machine

	always @(posedge clk) begin
		case (ver_state)
			float: begin
				team2_ver_pos <= team2_ver_pos;
			end
			up: begin
				if (team2_ver_pos > 62 && up_button_counter == 'd98) team2_ver_pos <= team2_ver_pos - 1;
			end
			down: begin
				if (team2_ver_pos < 485 && down_button_counter == 'd98) team2_ver_pos <= team2_ver_pos + 1;
			end
		endcase
	end

endmodule