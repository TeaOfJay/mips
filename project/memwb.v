module memwb(input clk, input rst, input memwb_en, input d_hlt, input d_from_mem, input d_WriteReg, input [3:0] d_DstReg, input [15:0] d_MemData, input [15:0] d_DstData, output q_hlt, output q_from_mem, output q_WriteReg, output [3:0] q_DstReg, output [15:0] q_MemData, output [15:0] q_DstData);


//flush assumes flush signal
assign q_WriteReg = (flush) ? 0 : f_wreg;


output q_hlt, output q_from_mem, output q_WriteReg, output [3:0] q_DstReg, output [15:0] q_MemData, output [15:0] q_DstData);


dff Data_Mem_en(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_Data_Mem_en), .q(q_Data_Mem_en));
dff Data_Mem_wr(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_Data_Mem_wr), .q(q_Data_Mem_wr));
dff WriteReg(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_WriteReg), .q(q_WriteReg)); //change to f_wreg?
dff_4bit DstReg(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_DstReg), .q(q_DstReg));
dff from_mem(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_from_mem), .q(q_from_mem));
dff_16bit MemData(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_MemData), .q(q_MemData));
dff_16bit DstData(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_DstData), .q(q_DstData));
dff hlt(.clk(clk), .rst(rst), .wen(memwb_en), .d(d_hlt), .q(q_hlt));



endmodule
