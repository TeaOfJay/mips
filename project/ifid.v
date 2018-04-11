module ifid(input clk, input rst, input flush, input ifid_en, input [15:0] d_nextpc, input [15:0] d_instr, output [15:0] q_nextpc, output [15:0] q_instr);

wire[15:0] f_instr;

dff_16bit dff_pc(.q(q_nextpc), .d(d_nextpc), .wen(ifid_en), .clk(clk), .rst(rst));
dff_16bit dff_instr(.q(f_instr), .d(d_instr), .wen(ifid_en), .clk(clk), .rst(rst));


//flush signal added
assign q_instr = (flush) ? 0 : f_instr;

endmodule
