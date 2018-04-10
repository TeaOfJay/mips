module Flags(output [2:0] flags, input clk, input rst, input wen, input [2:0] New_Flags);

dff Z(.q(flags[2]), .d(New_Flags[2]), .wen(wen), .clk(clk), .rst(rst));
dff V(.q(flags[1]), .d(New_Flags[1]), .wen(wen), .clk(clk), .rst(rst)); // flags[2] = Z; flags[1] = V; flags[0] = N
dff N(.q(flags[0]), .d(New_Flags[0]), .wen(wen), .clk(clk), .rst(rst));



endmodule
