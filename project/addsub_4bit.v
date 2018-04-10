module addsub_4bit(Sum, Ovfl, A, B, sub);
input signed [3:0] A, B; //Input values
input sub; //add-sub indicator
output signed [3:0] Sum; //sum output
output Ovfl; //To indicate overflow

wire signed [3:0] B_Comp;
wire cout0, cout1, cout2, cout3;

assign B_Comp = (sub) ? (~B) + 1 : B; //Invert B if subtracting

//Four Instantiations of Full Adders
FA A0(.A(A[0]), .B(B_Comp[0]), .CI(1'b0), .S(Sum[0]), .CO(cout0));
FA A1(.A(A[1]), .B(B_Comp[1]), .CI(cout0), .S(Sum[1]), .CO(cout1));
FA A2(.A(A[2]), .B(B_Comp[2]), .CI(cout1), .S(Sum[2]), .CO(cout2));
FA A3(.A(A[3]), .B(B_Comp[3]), .CI(cout2), .S(Sum[3]), .CO(cout3));

assign both_pos = ~A[3] & ~B_Comp[3];	// both operands to adder were positive
assign both_neg = A[3] & B[3];
assign Ovfl = (both_pos & Sum[3] & ~sub) || (both_neg & ~Sum[3] & ~sub) || (~A[3] & B[3] & sub & Sum[3]) || (A[3] & ~B[3] & sub & ~Sum[3]);

endmodule
