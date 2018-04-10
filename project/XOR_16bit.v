module XOR_16bit(input [15:0] A, input [15:0] B, output [15:0] X);
xor x0(X[0], A[0], B[0]);
xor x1(X[1], A[1], B[1]);
xor x2(X[2], A[2], B[2]);
xor x3(X[3], A[3], B[3]);
xor x4(X[4], A[4], B[4]);
xor x5(X[5], A[5], B[5]);
xor x6(X[6], A[6], B[6]);
xor x7(X[7], A[7], B[7]);
xor x8(X[8], A[8], B[8]);
xor x9(X[9], A[9], B[9]);
xor x10(X[10], A[10], B[10]);
xor x11(X[11], A[11], B[11]);
xor x12(X[12], A[12], B[12]);
xor x13(X[13], A[13], B[13]);
xor x14(X[14], A[14], B[14]);
xor x15(X[15], A[15], B[15]);

endmodule
