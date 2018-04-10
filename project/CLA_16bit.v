module CLA_16bit(input [15:0] In1, input [15:0] In2, input cin, output [15:0] Sum, output Ov);
	wire g0, g1, g2, g3, p0, p1, p2, p3, c0, c1, c2, c3, cout0, cout1, cout2, cout3;
	wire [3:0] sum0, sum1, sum2, sum3;
	wire [15:0] Int_Sum;

	CLA_4bit CLA0(.In1(In1[3:0]), .In2(In2[3:0]), .cin(c0), .Out(Int_Sum[3:0]), .Prop(p0), .Gen(g0), .cout(cout0));
	CLA_4bit CLA1(.In1(In1[7:4]), .In2(In2[7:4]), .cin(c1), .Out(Int_Sum[7:4]), .Prop(p1), .Gen(g1), .cout(cout1));
	CLA_4bit CLA2(.In1(In1[11:8]), .In2(In2[11:8]), .cin(c2), .Out(Int_Sum[11:8]), .Prop(p2), .Gen(g2), .cout(cout2));
	CLA_4bit CLA3(.In1(In1[15:12]), .In2(In2[15:12]), .cin(c3), .Out(Int_Sum[15:12]), .Prop(p3), .Gen(g3), .cout(cout3));
	assign c0 = cin;
  	assign c1 = g0 | (p0 & c0);
    	assign c2 = g1 | (p1 & g0) | (p1 & p0 & c0);
   	assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c0);
  	assign Ov = (In1[15] & In2[15] & (~Int_Sum[15]))	? 1 :
		    ((~In1[15]) & (~In2[15]) & (Int_Sum[15]))	? 1 : 0;


	assign Sum = (In1[15] & In2[15] & (~Int_Sum[15]))	? 16'h8000 :
		     ((~In1[15]) & (~In2[15]) & (Int_Sum[15]))	? 16'h7FFF : Int_Sum;



endmodule
