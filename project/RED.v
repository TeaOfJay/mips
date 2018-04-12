module RED(input [15:0] In1, input [15:0] In2, output [15:0] Out);
	wire g0, g1, g2, g3, gx, gy, gz, p0, p1, p2, p3, px, py, pz, carry0, carry1, carry2, carry3, c0, c1, c2, c3, cout0, cout1, cout2, cout3, coutx, couty, coutz, s0, s1, s2, sx0, sx1, sy0, sy1, sz1;
	wire [3:0] sum0, sum1, sum2, sum3, sumx, sumy, sumz;

	CLA_4bit CLA0(.In1(In1[3:0]), .In2(In2[3:0]), .cin(1'b0), .Out(sum0), .Prop(p0), .Gen(g0), .cout(cout0));
	CLA_4bit CLA1(.In1(In1[7:4]), .In2(In2[7:4]), .cin(1'b0), .Out(sum1), .Prop(p1), .Gen(g1), .cout(cout1));
	CLA_4bit CLA2(.In1(In1[11:8]), .In2(In2[11:8]), .cin(1'b0), .Out(sum2), .Prop(p2), .Gen(g2), .cout(cout2));
	CLA_4bit CLA3(.In1(In1[15:12]), .In2(In2[15:12]), .cin(1'b0), .Out(sum3), .Prop(p3), .Gen(g3), .cout(cout3));

	CLA_4bit CLAx(.In1(sum0), .In2(sum1), .cin(1'b0), .Out(sumx), .Prop(px), .Gen(gx), .cout(coutx));
	CLA_4bit CLAy(.In1(sum2), .In2(sum3), .cin(1'b0), .Out(sumy), .Prop(py), .Gen(gy), .cout(couty));
	CLA_4bit CLAz(.In1(sumx), .In2(sumy), .cin(1'b0), .Out(sumz), .Prop(pz), .Gen(gz), .cout(coutz));

	assign carry0 = (In1[3] & In2[3]) ? 0 : 1;
	assign carry1 = (In1[7] & In2[7]) ? 0 : 1;
	assign carry2 = (In1[11] & In2[11]) ? 0 : 1;
	assign carry3 = (In1[15] & In2[15]) ? 0 : 1;

	CSA csaX(.x(carry0), .y(carry1), .z(carry2), .s0(sx0), .s1(sx1));
	CSA csaY(.x(carry3), .y(coutx), .z(couty), .s0(sy0), .s1(sy1));
	CSA csaZ(.x(sx0), .y(coutz), .z(sy0), .s0(s0), .s1(sz1));
	CSA csaF(.x(sx1), .y(sy1), .z(sz1), .s0(s1), .s1(s2));

	assign Out = {{10{~s2}}, s1, s0, sumz};


endmodule
