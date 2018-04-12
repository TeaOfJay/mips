module FA(A, B, CI, S, CO);

input A, B, CI;
output S, CO;
wire w0, w1, w2;

xor xor1(w0, A, B);
xor xor2(S, CI, w0);
and and1(w1, A, B);
and and2(w2, w0, CI);
or or1(CO, w1, w2);

endmodule
