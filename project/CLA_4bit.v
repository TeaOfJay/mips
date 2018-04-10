module CLA_4bit(input [3:0] In1, input [3:0] In2, input cin, output [3:0] Out, output Prop, output Gen, output cout);
    	wire g0, g1, g2, g3, p0, p1, p2, p3, c0, c1, c2, c3;
	
	//Generate
	and a0(g0, In1[0], In2[0]);
	and a1(g1, In1[1], In2[1]);
	and a2(g2, In1[2], In2[2]);
	and a3(g3, In1[3], In2[3]);

	//Propagate
	xor x0(p0, In1[0], In2[0]);
	xor x1(p1, In1[1], In2[1]);
	xor x2(p2, In1[2], In2[2]);
	xor x3(p3, In1[3], In2[3]);

    	assign c0 = cin;
  	assign c1 = g0 | (p0 & c0);
    	assign c2 = g1 | (p1 & g0) | (p1 & p0 & c0);
   	assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c0);
  	assign cout = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) |(p3 & p2 & p1 & p0 & c0);
   	
	//Calculate sum
	xor sum_x0(Out[0], p0, c0);
	xor sum_x1(Out[1], p1, c1);
	xor sum_x2(Out[2], p2, c2);
	xor sum_x3(Out[3], p3, c3);
    
	//4bit Propagate
    	assign Prop = p3 & p2 & p1 & p0;
	//4bit Gen
    	assign Gen = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);

endmodule
