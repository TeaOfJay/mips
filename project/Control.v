module Control(input clk, input rst, input [15:0] instr, output [3:0] opcode, output Data_Mem_en, output Data_Mem_wr, output [3:0] DstReg, output WriteReg);

//////
//EX
//////

assign opcode = instr[15:12];


//////
//MEM
//////

//Data_Mem_en, Data_Mem_wr
assign Data_Mem_en = (opcode[3:1] == 3'b100) ? 1'b1 : 1'b0;
assign Data_Mem_wr = (opcode == 4'b1001) ? 1'b1 : 1'b0;

//////
//WB
//////

//DstReg, WriteReg
assign DstReg = instr[11:8];
assign WriteReg = ((opcode == 4'b1001) | (opcode == 4'b1100) | (opcode == 4'b1101) | (opcode == 4'b1111)) ? 1'b0 : 1'b1;

endmodule
