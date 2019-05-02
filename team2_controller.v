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

initial begin 
	ver_state = float;
	team2_ver_pos <= 'd240;
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

// State machine

always @(posedge clk) begin
	case (ver_state)
		float: begin
			team2_ver_pos <= team2_ver_pos;
		end
		up: begin
			if (team2_ver_pos > 20) team2_ver_pos <= team2_ver_pos - 5;
		end
		down: begin
			if (team2_ver_pos < 460) team2_ver_pos <= team2_ver_pos + 5;
		end
	endcase
end

endmodule