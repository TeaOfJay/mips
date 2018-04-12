module dff_4bit(output [3:0] q, input [3:0] d, input wen, input clk, input rst);
dff dff0(.q(q[0]), .d(d[0]), .wen(wen), .clk(clk), .rst(rst));
dff dff1(.q(q[1]), .d(d[1]), .wen(wen), .clk(clk), .rst(rst));
dff dff2(.q(q[2]), .d(d[2]), .wen(wen), .clk(clk), .rst(rst));
dff dff3(.q(q[3]), .d(d[3]), .wen(wen), .clk(clk), .rst(rst));

endmodule
