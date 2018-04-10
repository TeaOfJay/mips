module ifid(


input[15:0] q_nextpc,
input[15:0] q_instr,

input flush,

input clk,
input rst,

output[15:0] d_nextpc,
output[15:0] d_instr
	);


dff_16bit dff_pc(    .q(q_nextpc), .d(d_nextpc), .wen(write enable), .clk(clk), .rst(rst));
dff_16bit dff_instr( .q(q_instr) , .d(d_instr) , .wen(write enable), .clk(clk), .rst(rst));



endmodule // ifid