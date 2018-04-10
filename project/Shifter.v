module Shifter (Shift_Out, Shift_In, Shift_Val, Mode);
input signed [15:0] Shift_In; //This is the number to perform shift operation on

input [3:0] Shift_Val; //Shift amount (used to shift the ?Shift_In?)
input  [1:0] Mode; // To indicate SLL or SRA; 00:SLL 01:SRA 10: ROR
output reg signed [15:0] Shift_Out; //Shifter value

always @* begin
	case(Mode)
	2'b00 : begin
		case(Shift_Val)
			4'h1 	: Shift_Out = {Shift_In[14:0], 1'b0};
			4'h2 	: Shift_Out = {Shift_In[13:0], {2{1'b0}}};
			4'h3 	: Shift_Out = {Shift_In[12:0], {3{1'b0}}};
			4'h4 	: Shift_Out = {Shift_In[11:0], {4{1'b0}}};
			4'h5 	: Shift_Out = {Shift_In[10:0], {5{1'b0}}};
			4'h6 	: Shift_Out = {Shift_In[9:0], {6{1'b0}}};
			4'h7 	: Shift_Out = {Shift_In[8:0], {7{1'b0}}};
			4'h8 	: Shift_Out = {Shift_In[7:0], {8{1'b0}}};
			4'h9 	: Shift_Out = {Shift_In[6:0], {9{1'b0}}};
			4'hA 	: Shift_Out = {Shift_In[5:0], {10{1'b0}}};
			4'hB 	: Shift_Out = {Shift_In[4:0], {11{1'b0}}};
			4'hC 	: Shift_Out = {Shift_In[3:0], {12{1'b0}}};
			4'hD 	: Shift_Out = {Shift_In[2:0], {13{1'b0}}};
			4'hE	: Shift_Out = {Shift_In[1:0], {14{1'b0}}};
			4'hF	: Shift_Out = {Shift_In[0], {15{1'b0}}};
			default	: Shift_Out = Shift_In;
		endcase
	end
	2'b01 : begin
		case(Shift_Val)
			4'h1 	: Shift_Out = {Shift_In[15], Shift_In[15:1]};
			4'h2 	: Shift_Out = {{2{Shift_In[15]}}, Shift_In[15:2]};
			4'h3 	: Shift_Out = {{3{Shift_In[15]}}, Shift_In[15:3]};
			4'h4 	: Shift_Out = {{4{Shift_In[15]}}, Shift_In[15:4]};
			4'h5 	: Shift_Out = {{5{Shift_In[15]}}, Shift_In[15:5]};
			4'h6 	: Shift_Out = {{6{Shift_In[15]}}, Shift_In[15:6]};
			4'h7 	: Shift_Out = {{7{Shift_In[15]}}, Shift_In[15:7]};
			4'h8 	: Shift_Out = {{8{Shift_In[15]}}, Shift_In[15:8]};
			4'h9 	: Shift_Out = {{9{Shift_In[15]}}, Shift_In[15:9]};
			4'hA 	: Shift_Out = {{10{Shift_In[15]}}, Shift_In[15:10]};
			4'hB 	: Shift_Out = {{11{Shift_In[15]}}, Shift_In[15:11]};
			4'hC 	: Shift_Out = {{12{Shift_In[15]}}, Shift_In[15:12]};
			4'hD 	: Shift_Out = {{13{Shift_In[15]}}, Shift_In[15:13]};
			4'hE	: Shift_Out = {{14{Shift_In[15]}}, Shift_In[15:14]};
			4'hF	: Shift_Out = {{16{Shift_In[15]}}};
			default	: Shift_Out = Shift_In;
		endcase
	end
	2'b10 : begin
		case(Shift_Val)
			4'h1 	: Shift_Out = {Shift_In[0], Shift_In[15:1]};
			4'h2 	: Shift_Out = {Shift_In[1:0], Shift_In[15:2]};
			4'h3 	: Shift_Out = {Shift_In[2:0], Shift_In[15:3]};
			4'h4 	: Shift_Out = {Shift_In[3:0], Shift_In[15:4]};
			4'h5 	: Shift_Out = {Shift_In[4:0], Shift_In[15:5]};
			4'h6 	: Shift_Out = {Shift_In[5:0], Shift_In[15:6]};
			4'h7 	: Shift_Out = {Shift_In[6:0], Shift_In[15:7]};
			4'h8 	: Shift_Out = {Shift_In[7:0], Shift_In[15:8]};
			4'h9 	: Shift_Out = {Shift_In[8:0], Shift_In[15:9]};
			4'hA 	: Shift_Out = {Shift_In[9:0], Shift_In[15:10]};
			4'hB 	: Shift_Out = {Shift_In[10:0], Shift_In[15:11]};
			4'hC 	: Shift_Out = {Shift_In[11:0], Shift_In[15:12]};
			4'hD 	: Shift_Out = {Shift_In[12:0], Shift_In[15:13]};
			4'hE	: Shift_Out = {Shift_In[13:0], Shift_In[15:14]};
			4'hF	: Shift_Out = {Shift_In[14:0], Shift_In[15]};
			default	: Shift_Out = Shift_In;
		endcase
	end
	default : Shift_Out = Shift_In;
	endcase
end

endmodule
