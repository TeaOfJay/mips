module ifid(input clk, input rst, input flush, input ifid_en, input [15:0] d_nextpc, input [15:0] d_instr, output q_flush, output [15:0] q_nextpc, output [15:0] q_instr);


dff_16bit dff_pc(.q(q_nextpc), .d(d_nextpc), .wen(ifid_en), .clk(clk), .rst(rst));
dff_16bit dff_instr(.q(q_instr), .d(d_instr), .wen(ifid_en), .clk(clk), .rst(rst));
dff dff_flush(.q(q_flush), .d(flush), .wen(ifid_en), .clk(clk), .rst(rst));



endmodule
