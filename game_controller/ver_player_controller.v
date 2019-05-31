module ver_player_controller #(
	parameter PLAYER_RADIUS,		// 25 px works
	parameter INITIAL_VER_POS,		// 'd200 works
	parameter HOR_POS,
	parameter MOVEMENT_FREQUENCY,	// inversely proportinal to speed ('d200000 works)
	parameter TOP_BOUNDARY,
	parameter BOT_BOUNDARY,
	parameter BLOCKING_BALL_Y
)
(	input clk,

	input bludged,

	input vu_button,
	input vd_button,

	input [9:0] BLOCKING_BALL_X,
	
	output reg [9:0] ver_pos,
	
	output reg clean_bludge,
	output reg [3:0] bludge_time
);

	// Vertical player movements
	reg [1:0] ver_state;
	
	parameter float = 'd0;
	parameter    up = 'd1;
	parameter  down = 'd2;
	
	reg can_move_up, can_move_down;

	integer up_button_counter, down_button_counter;
	integer counter_clk;
	
	initial begin 
		counter_clk         =   0;
		ver_state           = float;
		ver_pos = INITIAL_VER_POS;
		up_button_counter   =   0;
		down_button_counter =   0;
		can_move_up         =   1;
		can_move_down       =   1;
		bludge_time         =  10;
		clean_bludge        =   0;
	end
	
	always @(posedge clk) begin
		if (bludged == 1) begin
			if ((counter_clk == 49999999) && bludge_time != 0) begin
				counter_clk <= 'd0;
				bludge_time <= bludge_time - 'd1;
				clean_bludge <= 0;
			end else if (bludge_time == 0) begin
				clean_bludge <= 1;
				counter_clk <= 'd0;
			end else begin
				counter_clk <= counter_clk + 'd1;
			end
		end else begin
			bludge_time <= 10;
			clean_bludge <= 0;
		end
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

	always @(posedge clk) begin
		case (ver_state)
			float: begin
				ver_pos <= ver_pos;
			end
			up: begin
				if (ver_pos > (TOP_BOUNDARY + PLAYER_RADIUS) && up_button_counter   == 'd98 && can_move_up == 1) ver_pos <= ver_pos - 1;
			end
			down: begin
				if (ver_pos < (BOT_BOUNDARY - PLAYER_RADIUS) && down_button_counter == 'd98 && can_move_down == 1) ver_pos <= ver_pos + 1;
			end
		endcase
	end
	
	always @(posedge clk) begin
		if (bludged == 1) begin
			can_move_up   <= 0;
			can_move_down <= 0;
		end else if ((ver_pos - BLOCKING_BALL_Y)**2 + (HOR_POS - BLOCKING_BALL_X)**2 < (PLAYER_RADIUS + PLAYER_RADIUS + 2)**2) begin
			if (ver_pos > BLOCKING_BALL_Y) begin
				can_move_up   <= 0;
			end else begin
				can_move_down <= 0;
			end			
		end else begin
			can_move_up   <= 1;
			can_move_down <= 1;
		end
	end

endmodule