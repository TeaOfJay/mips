module dff_3bit(output [2:0] q, input [2:0] d, input wen, input clk, input rst);
dff dff0(.q(q[0]), .d(d[0]), .wen(wen), .clk(clk), .rst(rst));
dff dff1(.q(q[1]), .d(d[1]), .wen(wen), .clk(clk), .rst(rst));
dff dff2(.q(q[2]), .d(d[2]), .wen(wen), .clk(clk), .rst(rst));

endmodule
