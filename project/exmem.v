module exmem(input clk, input rst, input exmem_en, input d_hlt, input d_from_mem, input d_Data_Mem_en, input d_Data_Mem_wr, input d_WriteReg, input [3:0] d_DstReg, input [15:0] d_Data_Mem_In, input [15:0] d_Data_Mem_Addr, input [15:0] d_DstData, output q_from_mem, output q_Data_Mem_en, output q_hlt, output q_Data_Mem_wr, output q_WriteReg, output [3:0] q_DstReg, output [15:0] q_Data_Mem_In, output [15:0] q_Data_Mem_Addr, output [15:0] q_DstData);

output q_from_mem, output q_Data_Mem_en, output q_hlt, output q_Data_Mem_wr, output q_WriteReg, output [3:0] q_DstReg, output [15:0] q_Data_Mem_In, output [15:0] q_Data_Mem_Addr, output [15:0] q_DstData);

wire f_fmem, f_en, f_wr, f_wreg;

//flush assumes flush signal
assign q_Data_Mem_en = (flush) ? 0 : f_en;
assign q_Data_Mem_wr = (flush) ? 0 : f_wr;
assign q_WriteReg = (flush) ? 0 : f_wreg;
assign q_from_mem = (flush) ? 0 : f_fmem; //is this a control signal??

dff Data_Mem_en(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_Data_Mem_en), .q(f_en));
dff Data_Mem_wr(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_Data_Mem_wr), .q(f_wr));
dff WriteReg(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_WriteReg), .q(f_wreg));
dff_4bit DstReg(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_DstReg), .q(q_DstReg));
dff_16bit Data_Mem_In(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_Data_Mem_In), .q(q_Data_Mem_In));
dff_16bit Data_Mem_Addr(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_Data_Mem_Addr), .q(q_Data_Mem_Addr));
dff_16bit DstData(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_DstData), .q(q_DstData));
dff from_mem(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_from_mem), .q(f_fmem));
dff hlt(.clk(clk), .rst(rst), .wen(exmem_en), .d(d_hlt), .q(q_hlt));




endmodule
