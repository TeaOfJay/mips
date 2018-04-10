module pipeline(

input[15:0] pc_address,


input clk, 
input rst


output[15:0] next_pc,
	);

wire[15:0] instr_out, instr_in;
wire instr_en;

dff (q, d, wen, clk, rst);

///////////////////////////////////////////////////instr fetch (if)


memory1c imem(.data_out(instr_out), .data_in(instr_in), .addr(pc_address), .enable(instr_en), .wr(1'b0), .clk(clk), .rst(~rst_n)); // Instruction Memory

// CLA for incrementing the PC by 2
CLA_16bit PC_Add(.In1(pc_address), .In2(16'h0002), .cin(1'b0), .Sum(address_inc), .Ov(address_overflow));



//////////////////////////////////////////////////IFID
ifid ifid( .q_nextpc(q_nextpc),.q_instr(instr_out),      , clk, rst);
//////////////////////////////////////////////////instr decode (id)

assign opcode = instr[15:12];
assign rd = instr[11:8];
assign rs = instr[7:4];
assign rt = ((opcode == 4'b1000) | (opcode == 4'b1001)) ? instr[11:8] : instr[3:0];


assign dstreg = (opcode == 4'b1000) ? rt : rd;
assign srcreg1 = rs;
assign srcreg2 = (opcode[3:1] == 3'b101) ? rd : rt;
assign wreg = ((opcode == 4'b1001) | (opcode == 4'b1100) | (opcode == 4'b1101) | (opcode == 4'b1111)) ? 1'b0 : 1'b1;

assign dstdata = (opcode[3:1] == 3'b000) 				? CLA_Sum : //ADD/SUB
		 (opcode == 4'b0010)							? Red_Out : //RED
		 (opcode == 4'b0011)	 						? XOR_Out : //XOR
		 ((opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110))	? Shift_Out : //SLL/SRA/ROR
		 (opcode == 4'b0111)							? PADDSB_Sum : //PADDSB
		 (opcode[3:1] == 3'b100)						? dmem_out : //LW/SW is a don't care
		 (opcode[3:1] == 3'b101)						? Load_Byte : //LHB/LLB
		 (opcode[3:2] == 2'b11)							? address_inc : //PCS; other opcodes are don't cares

RegisterFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(srcreg1), .SrcReg2(srcreg2), .DstReg(dstreg), .WriteReg(wreg), .DstData(dstdata), .SrcData1(SrcData1), .SrcData2(SrcData2));
Shifter Shift(.Shift_Out(Shift_Out), .Shift_In(SrcData1), .Shift_Val(imm), .Mode(opcode[1:0]));
///////////////////////////////////////////////IDEX
idex idex();
///////////////////////////////////////////////execute (ex)

CLA_16bit ALU(.In1(ALU_In1), .In2(ALU_In2), .cin(invert), .Sum(CLA_Sum), .Ov(overflow));

////////////////////////////////////////////////MEMWB
memwb memwb(); 
////////////////////////////////////////////////memory (mem)
assign dmem_en = (opcode[3:1] == 3'b100) ? 1'b1 : 1'b0;
assign dmem_wr = (opcode == 4'b1001) ? 1'b1 : 1'b0;
assign dmem_in = SrcData2;
assign dmem_addr = CLA_Sum;

memory1c Dmem(.data_out(dmem_out), .data_in(dmem_in), .addr(dmem_addr), .enable(dmem_en), .wr(dmem_wr), .clk(clk), .rst(~rst_n));

////////////////////////////////////////////////EXMEM
exmem exmem(.q_data(), .d_data);







///////////////////////////////////////////////pipeline modules





assign imm = Instr[3:0];
assign Load_Imm = Instr[7:0];
assign offset = Instr[3:0];
assign Branch_Imm = Instr[8:0];
assign condition = Instr[11:9];



			


assign Load_Byte = (opcode[0]) ? ((SrcData2 & 16'hFF00) | Load_Imm) : 
				 ((SrcData2 & 16'h00FF) | {Load_Imm, {8{1'b0}}});

assign branch = (opcode[0]) ? BR_Offset[9:1] : Branch_Imm;



PC_Control Control(.C(condition), .I(branch), .F(flags), .PC_in(address_inc), .PC_out(new_pc));

assign ALU_In1 = (opcode[3]) ? (SrcData1 & 16'hFFFE) : SrcData1;
assign ALU_In2 = (opcode[3]) ? {{12{offset[3]}}, offset[2:0], 1'b0} : Rt_add;

// Carry Look-Ahead Adder ALU

assign Z = ((opcode[3:1] == 3'b000) & (~(|CLA_Sum))) 						 ? 1'b1 :
	   ((opcode == 4'b001) & (~(|XOR_Out)))							 ? 1'b1 :
	   (((opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110)) & (~(|Shift_Out))) ? 1'b1 : 1'b0;

assign N = (opcode[3:1] == 3'b000) ? CLA_Sum[15] : flags[0];
assign V = (opcode[3:1] == 3'b000) ? overflow	 : flags[1];

assign New_Flags = {Z, V, N};

assign flag_wen = (opcode[3:1] == 3'b000) | (opcode == 4'b001) | (opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110);


Flags flag(.flags(flags), .clk(clk), .rst(~rst_n), .wen(flag_wen), .New_Flags(New_Flags));


// CLA for Branch to Register instruction
CLA_16bit BR_Offset_Calc(.In1(SrcData1), .In2(~address_inc), .cin(1'b1), .Sum(BR_Offset), .Ov(BR_Offset_overflow));

// RED function
RED red(.In1(SrcData1), .In2(SrcData2), .Out(Red_Out));

// XOR function
XOR_16bit xor16(.A(SrcData1), .B(SrcData2), .X(XOR_Out));







//hazard






endmodule // pipeline
