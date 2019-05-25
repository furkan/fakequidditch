/*module board #( parameter x_position, 
parameter y_position, 
parameter GOAL_RADIUS,
parameter BALL_RADIUS
)
(
input clk, 
output reg [9:0] team1_vu_button,
output reg [9:0] team1_vd_button,
output reg [9:0] team2_vu_button,
output reg [9:0] team2_vd_button,
output reg [9:0] score_to_team1, 
output reg [9:0] score_to_team2
);
integer inside_goal = (GOAL_RADIUS - BALL_RADIUS) ** 2;
integer minute ='d3;
integer second_lsb ='d0;
integer second_msb ='d0;

reg [1:0] state;
	
	parameter beginning   = 'd0;
	parameter active      = 'd1;
	

// Score counter
	always @ (posedge clk) begin
	if ((((y_position-450)**2)+((x_position-300)**2) < inside_goal) // BLUE GOAL 1
				|| (((y_position-450)**2)+((x_position-400)**2) < inside_goal) // BLUE GOAL 2
				|| (((y_position-450)**2)+((x_position-500)**2) < inside_goal) // BLUE GOAL 3
		) begin
			state = beginning;
			score_to_team2 <= ((score_to_team2) +1);
	end
	else if ((((y_position-100)**2)+((x_position-300)**2) < inside_goal) // RED  GOAL 1
				|| (((y_position-100)**2)+((x_position-400)**2) < inside_goal) // RED  GOAL 2
				|| (((y_position-100)**2)+((x_position-500)**2) < inside_goal) // RED  GOAL 3
		) begin
			state = beginning;
			score_to_team1 <= ((score_to_team1)+1);
			end
	end
// Displaying scores of each team
//always @ (posedge clk) begin

//end
// Remaining Time calculation
always @ (posedge clk) begin
	if ((minute > 0) &&(second_msb==0)&& (second_lsb ==0)) begin
	minute <= minute -1;
	second_lsb <= 9;
	second_msb <= 5;
	end
	else if ((minute >0) &&(second_msb>0)&& (second_lsb ==0)) begin
	second_lsb <=9;
	second_msb <= second_msb -1;
	minute <= minute;
	end
	else if ((minute >0) &&(second_msb > 0)&& (second_lsb >0)) begin
	minute <= minute;
	second_msb <= second_msb;
	second_lsb <= second_lsb-1;
	end
	else if ((minute == 0) &&(second_msb==0)&& (second_lsb ==0)) begin
	minute <= 0;
	second_lsb <= 0;
	second_msb <= 0;
	team1_vu_button <= 1;
	team1_vd_button <= 1;
	team2_vu_button <=1;
	team2_vd_button <= 1;
	end
end
// Remaining time displaying
always @(posedge clk) begin
case (minute)
0: begin
s1= (y==245) && (700<x<710);
s2= (x==700) && (245<y<255);
s3= (x==700) && (255<y<265);
s4= (y== 265)&& (700<x<710);
s5= (x==710) && (255<y265);
s6= (x==710) && (245<y<255);
s7= 0;
end
1: begin
s1= (y==245) && (700<x<710);
s2= (x==700) && (245<y<255);
s3= 0;
s4= 0;
s5= 0;
s6= 0;
s7= 0;
end
2: begin
s1= (y==245) && (700<x<710);
s2= 0;
s3= (x==700) && (255<y<265);
s4= (y== 265)&& (700<x<710);
s5= 0;
s6= (x==710) && (245<y<255);
s7= (y==255) && (700<x<710);
end
3: begin
s1= (y==245) && (700<x<710);
s2=0;
s3=0;
s4= (y== 265)&& (700<x<710);
s5= (x==710) && (255<y265);
s6= (x==710) && (245<y<255);
s7= (y==255) && (700<x<710);
end
endcase
case(second_msb) begin
0: begin
s1= (720<x<730) && (y==245);
s2= (x==720) && (245<y<255);
s3= (x=720) && (255<y<265);
s4= (720<x<730) && (y==265);
s5= (255<y<265) && (x==730);
s6= (x==730) && (245<y<255);
s7= 0;
end
1: begin
s1= 
s2=
s3=
s4=
s5=
s6=
s7=
end
2: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
3: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
4: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
5: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
endcase
case(second_lsb)
0: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
1: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
2: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
3: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
4: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
5: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
6: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
7: begin
s1=
s2=
s3=
s4=
s5=
s6=
s7=
end
8: begin
	s1=
	s2=
	s3=
	s4=
	s5=
	s6=
	s7=
end
9: begin
	s1=
	s2=
	s3=
	s4=
	s5=
	s6=
	s7=
end

endcase
end
	endmodule */