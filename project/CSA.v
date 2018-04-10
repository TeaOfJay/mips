module CSA(input x, input y, input z, output s0, output s1);
	assign s0 = x ^ y ^ z;
	assign s1 = (x & y) | (x & z) | (y & z);

endmodule
