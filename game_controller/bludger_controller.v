/*module bludger_controller( input clk,


)
reg [2:0]  state_blugger
parameter initial_blugger  = 'd0;
parameter active_blugger   = 'd1;
parameter boundary_blugger = 'd2;

reg [2:0] blugger_dir
parameter southwest ='d0;
parameter northwest ='d1;
parameter northeast ='d2;
parameter southeast ='d4;


always @ (posedge clk) begin
case (blugger_dir) begin

end
case (state_blugger) begin

active_blugger : begin
if (blugger_dir == southwest)
x_blugger <= x_blugger

end
end

end
endcase
	always @ (posedge clk) begin
	if ((team1_vu_button ==1) && (team1_vd_button ==1) && (team2_vu_button ==1) && (team2_vd_button==1) && ()) begin
			state_blugger = initial_blugger;
	end else if ( (team1_vu_button == 0 )|| (team1_vd_button == 0)|| (team2_vu_button == 0) || (team2_vd_button == 0)) begin
		if(((36+BALL_RADIUS)<(y_blugger)<(510-BALL_RADIUS)) || ((150+BALL_RADIUS)<(x_blugger)<(680-BALL_RADIUS))) begin
		state_blugger =active_blugger;
	end
	end else begin
		state_blugger= boundary_bludger;
	         //lower boundry
				if ((y_position > 510-BALL_RADIUS ) || (y_position > 36 + BALL_RADIUS) || (x_position > 150 + BALL_RADIUS) || (x_position > 680 - BALL_RADIUS)) begin
				ball_dir_y <= y_up;
				ball_dir_x <= ball_dir_x;
				end */
				