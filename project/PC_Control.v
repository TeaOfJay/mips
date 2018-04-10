module PC_Control(input [2:0] C, input [8:0] I, input [2:0] F, input [15:0] PC_in, output [15:0] PC_out);

wire signed [15:0] I_signext;
wire signed [15:0] I_shft;
wire [15:0] sum;
wire co0, co1, co2, co3, co4, co5, co6, co7, co8, co9, co10, co11, co12, co13, co14, co15;


assign I_signext = {{7{I[8]}}, I[8:0]};

Shifter S0(.Shift_Out(I_shft), .Shift_In(I_signext), .Shift_Val(4'h1), .Mode(2'b00));

FA A0(.A(PC_in[0]), .B(I_shft[0]), .CI(1'b0), .S(sum[0]), .CO(co0));
FA A1(.A(PC_in[1]), .B(I_shft[1]), .CI(co0), .S(sum[1]), .CO(co1));
FA A2(.A(PC_in[2]), .B(I_shft[2]), .CI(co1), .S(sum[2]), .CO(co2));
FA A3(.A(PC_in[3]), .B(I_shft[3]), .CI(co2), .S(sum[3]), .CO(co3));
FA A4(.A(PC_in[4]), .B(I_shft[4]), .CI(co3), .S(sum[4]), .CO(co4));
FA A5(.A(PC_in[5]), .B(I_shft[5]), .CI(co4), .S(sum[5]), .CO(co5));
FA A6(.A(PC_in[6]), .B(I_shft[6]), .CI(co5), .S(sum[6]), .CO(co6));
FA A7(.A(PC_in[7]), .B(I_shft[7]), .CI(co6), .S(sum[7]), .CO(co7));
FA A8(.A(PC_in[8]), .B(I_shft[8]), .CI(co7), .S(sum[8]), .CO(co8));
FA A9(.A(PC_in[9]), .B(I_shft[9]), .CI(co8), .S(sum[9]), .CO(co9));
FA A10(.A(PC_in[10]), .B(I_shft[10]), .CI(co9), .S(sum[10]), .CO(co10));
FA A11(.A(PC_in[11]), .B(I_shft[11]), .CI(co10), .S(sum[11]), .CO(co11));
FA A12(.A(PC_in[12]), .B(I_shft[12]), .CI(co11), .S(sum[12]), .CO(co12));
FA A13(.A(PC_in[13]), .B(I_shft[13]), .CI(co12), .S(sum[13]), .CO(co13));
FA A14(.A(PC_in[14]), .B(I_shft[14]), .CI(co13), .S(sum[14]), .CO(co14));
FA A15(.A(PC_in[15]), .B(I_shft[15]), .CI(co14), .S(sum[15]), .CO(co15));

// Flag bits [Z, V, N]
assign PC_out = ((C == 3'b000) & (~F[2])) 	    ? sum  :  // Not Equal
		((C == 3'b001) & (F[2]))  	    ? sum  :  // Equal
		((C == 3'b010) & (~F[2]) & (~F[0])) ? sum  :  // Greater Than
		((C == 3'b011) & (F[0]))	    ? sum  :  // Less Than
		((C == 3'b100) & (F[2]))	    ? sum  :  // Equal or
		((C == 3'b100) & (~F[2]) & (~F[0])) ? sum  :  // Greater Than
		((C == 3'b101) & (F[2] | F[0]))	    ? sum  :  // Less than or Equal
		((C == 3'b110) & (F[1]))	    ? sum  :  // Overflow
		((C == 3'b111))			    ? sum  :  // Unconditional
						      PC_in;  // If conditions not met


endmodule
