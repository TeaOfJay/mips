module PSA_16bit (Sum, Error, A, B);
input [15:0] A, B; //Input values
output [15:0] Sum; //sum output
output Error; //To indicate overflows

wire [3:0] ae_sum, bf_sum, cg_sum, dh_sum, ae_val, bf_val, cg_val, dh_val;
wire ae_ov, bf_ov, cg_ov, dh_ov;

addsub_4bit dh(.Sum(dh_sum), .Ovfl(dh_ov), .A(A[3:0]), .B(B[3:0]), .sub(1'b0)); //Add least significant half-byte
addsub_4bit cg(.Sum(cg_sum), .Ovfl(cg_ov), .A(A[7:4]), .B(B[7:4]), .sub(1'b0)); //Add second half-byte
addsub_4bit bf(.Sum(bf_sum), .Ovfl(bf_ov), .A(A[11:8]), .B(B[11:8]), .sub(1'b0)); //Add third half-byte
addsub_4bit ae(.Sum(ae_sum), .Ovfl(ae_ov), .A(A[15:12]), .B(B[15:12]), .sub(1'b0)); //Add most significant half-byte


assign Error = (dh_ov | cg_ov | bf_ov | ae_ov); //If any of the additions overflowed

assign ae_val = (A[15] & B[15] & ae_ov) 	? 4'b1000 :
		((~A[15]) & (~B[15]) & ae_ov) 	? 4'b0111 : ae_sum;

assign bf_val = (A[11] & B[11] & bf_ov) 	? 4'b1000 :
		((~A[11]) & (~B[11]) & bf_ov)	? 4'b0111 : bf_sum;

assign cg_val = (A[7] & B[7] & cg_ov) 		? 4'b1000 :
		((~A[7]) & (~B[7]) & cg_ov) 	? 4'b0111 : cg_sum;

assign dh_val = (A[3] & B[3] & dh_ov) 		? 4'b1000 :
		((~A[3]) & (~B[3]) & dh_ov)	? 4'b0111 : dh_sum;

assign Sum = {ae_val, bf_val, cg_val, dh_val};

endmodule
