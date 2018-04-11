module idex(input clk, input rst, input idex_en, input d_Data_Mem_en, input d_Data_Mem_wr, input d_WriteReg, input [3:0] d_DstReg, input [3:0] d_opcode, input [15:0] d_SrcData1, input [15:0] d_SrcData2, input [3:0] d_SrcReg1, input [3:0] d_SrcReg2, input [3:0] d_imm, input [7:0] d_Load_Imm, input [3:0] d_offset, input [8:0] d_Branch_Imm, input [2:0] d_condition, output q_Data_Mem_en, output q_Data_Mem_wr, output q_WriteReg, output [3:0] q_DstReg, output [3:0] q_opcode, output [15:0] q_SrcData1, output [15:0] q_SrcData2, output [3:0] q_SrcReg1, output [3:0] q_SrcReg2, output [3:0] q_imm, output [7:0] q_Load_Imm, output [3:0] q_offset, output [8:0] q_Branch_Imm, output [2:0] q_condition); 

wire f_en, f_wr, f_wreg;


dff Data_Mem_en(.clk(clk), .rst(rst), .wen(idex_en), .d(d_Data_Mem_en), .q(f_en));
dff Data_Mem_wr(.clk(clk), .rst(rst), .wen(idex_en), .d(d_Data_Mem_wr), .q(f_wr));
dff WriteReg(.clk(clk), .rst(rst), .wen(idex_en), .d(d_WriteReg), .q(f_wreg));
dff_4bit DstReg(.clk(clk), .rst(rst), .wen(idex_en), .d(d_DstReg), .q(q_DstReg));
dff_4bit opcode(.clk(clk), .rst(rst), .wen(idex_en), .d(d_opcode), .q(q_opcode));
dff_16bit SrcData1(.clk(clk), .rst(rst), .wen(idex_en), .d(d_SrcData1), .q(q_SrcData1));
dff_16bit SrcData2(.clk(clk), .rst(rst), .wen(idex_en), .d(d_SrcData2), .q(q_SrcData2));
dff_4bit imm(.clk(clk), .rst(rst), .wen(idex_en), .d(d_imm), .q(q_imm));
dff_8bit Load_Imm(.clk(clk), .rst(rst), .wen(idex_en), .d(d_Load_Imm), .q(q_Load_Imm));
dff_4bit offset(.clk(clk), .rst(rst), .wen(idex_en), .d(d_offset), .q(q_offset));
dff_9bit Branch_Imm(.clk(clk), .rst(rst), .wen(idex_en), .d(d_Branch_Imm), .q(q_Branch_Imm));
dff_3bit condition(.clk(clk), .rst(rst), .wen(idex_en), .d(d_condition), .q(q_condition));
dff_4bit SrcReg1(.clk(clk), .rst(rst), .wen(idex_en), .d(d_SrcReg1), .q(q_SrcReg1));
dff_4bit SrcReg2(.clk(clk), .rst(rst), .wen(idex_en), .d(d_SrcReg2), .q(q_SrcReg2));



//flush assumes flush signal


assign q_Data_Mem_en = (flush) ? 0 : f_en;
assign q_Data_Mem_wr = (flush) ? 0 : f_wr;
assign q_WriteReg = (flush) ? 0 : f_wreg;

endmodule
