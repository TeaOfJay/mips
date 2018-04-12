module dff_9bit(output [8:0] q, input [8:0] d, input wen, input clk, input rst);
dff dff0(.q(q[0]), .d(d[0]), .wen(wen), .clk(clk), .rst(rst));
dff dff1(.q(q[1]), .d(d[1]), .wen(wen), .clk(clk), .rst(rst));
dff dff2(.q(q[2]), .d(d[2]), .wen(wen), .clk(clk), .rst(rst));
dff dff3(.q(q[3]), .d(d[3]), .wen(wen), .clk(clk), .rst(rst));
dff dff4(.q(q[4]), .d(d[4]), .wen(wen), .clk(clk), .rst(rst));
dff dff5(.q(q[5]), .d(d[5]), .wen(wen), .clk(clk), .rst(rst));
dff dff6(.q(q[6]), .d(d[6]), .wen(wen), .clk(clk), .rst(rst));
dff dff7(.q(q[7]), .d(d[7]), .wen(wen), .clk(clk), .rst(rst));
dff dff8(.q(q[8]), .d(d[8]), .wen(wen), .clk(clk), .rst(rst));

endmodule
