module cpu(input clk, input rst_n, output hlt, output [15:0] pc);
wire [15:0] next_address; //pc that is actually loaded
wire [15:0] new_pc;  //pc generated from branch instructions
wire [15:0] address_inc; //Incremented pc
wire pc_wen; // Program Counter Write Enable
wire [15:0] Instr_Data_In;  //Placeholder; Won't be used
wire [15:0] Instr; //Instruction most recently loaded from memory
wire Instr_En; // Instruction read enable
wire [3:0] opcode; // 4 bit opcode determining function
wire [3:0] Rs, Rt, Rd, imm, offset; // Carry the different register and offset values from the instruction
wire [7:0] Load_Imm; // Immediate value for LHB and LLB instructions
wire [8:0] Branch_Imm; // Immediate value for branching
wire [2:0] condition; // Condition code for branching
wire WriteReg; // Controls when registers can be written
wire [15:0] DstData, SrcData1, SrcData2;  // Data being written into and read from the registers
wire invert; // Bit controlling whether or not 2nd operand of CLA gets inverted for subtraction
wire [15:0] Rt_add; // Value of 2nd operand of CLA after either being inverted or left alone
wire [15:0] CLA_Sum; // Sum of the Carry Look-Ahead Adder
wire overflow, address_overflow; // Overflow signals of the two adders
wire [2:0] flags, New_Flags; // Current flag values and new flag values to be loaded at next rising clock edge
wire Z, V, N; // Individual flags to be set then concatenated into New_Flags
wire flag_wen; // Controls when the flags can be written to
wire [15:0] PADDSB_Sum; // Sum of the PADDSB function
wire [15:0] Shift_Out; // Output of any shifting function
wire [15:0] Red_Out; // Output of the RED function
wire [15:0] XOR_Out; // Output of the XOR function
wire [15:0] ALU_In1, ALU_In2; // Inputs to the CLA
wire [15:0] Data_Mem_Out, Data_Mem_In, Data_Mem_Addr; // Data Memory output, input, and address of where to either store or read from
wire [3:0] DstReg; // Register to store into
wire [3:0] SrcReg1, SrcReg2; //Two inputs to the Register File
wire [15:0] Load_Byte; //Output of the LHB and LLB Instructions
wire Data_Mem_en, Data_Mem_wr; // Data memory enable and write enable
wire Error_dont_care; // Error signal coming from the PADDSB function that was originally implemented in an earlier homework and we do not care about here
wire BR_Offset_overflow; // Error of overflow that will not happen
wire [15:0] BR_Offset; // Offset for calculation of Branch to register in order to be able to reuse the pc control module
wire [8:0] branch;  // Offset for branching, can be BR_Offset for branch to register or Branch_Imm for regular branch

assign Instr_En = (~rst_n) ? 1'b0 : 1'b1; 
assign invert = (opcode == 4'b0001) ? 1'b1 : 1'b0; // Control signal for 2's complement when subtracting
assign Rt_add = invert ? ~SrcData2 : SrcData2; // 2's Complement when subtracting
assign next_address = ((opcode == 4'b1100) | (opcode == 4'b1101)) ? new_pc : address_inc; //Incremented PC or Branch

assign pc_wen = (rst_n | hlt) ? 1'b1 : 1'b0;
assign hlt = (opcode == 4'b1111);

dff_16bit program(.q(pc), .d(next_address), .wen(pc_wen), .clk(clk), .rst(~rst_n)); // 16 bit register to hold current pc value
memory1c Imem(.data_out(Instr), .data_in(Instr_Data_In), .addr(pc), .enable(Instr_En), .wr(1'b0), .clk(clk), .rst(~rst_n)); // Instruction Memory

assign opcode = Instr[15:12];
assign Rd = Instr[11:8];
assign Rs = Instr[7:4];
assign Rt = ((opcode == 4'b1000) | (opcode == 4'b1001)) ? Instr[11:8] : Instr[3:0];
assign imm = Instr[3:0];
assign Load_Imm = Instr[7:0];
assign offset = Instr[3:0];
assign Branch_Imm = Instr[8:0];
assign condition = Instr[11:9];
assign WriteReg = ((opcode == 4'b1001) | (opcode == 4'b1100) | (opcode == 4'b1101) | (opcode == 4'b1111)) ? 1'b0 : 1'b1;

assign DstData = (opcode[3:1] == 3'b000) 						? CLA_Sum : //ADD/SUB
		 (opcode == 4'b0010)							? Red_Out : //RED
		 (opcode == 4'b0011)	 						? XOR_Out : //XOR
		 ((opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110))	? Shift_Out : //SLL/SRA/ROR
		 (opcode == 4'b0111)							? PADDSB_Sum : //PADDSB
		 (opcode[3:1] == 3'b100)						? Data_Mem_Out : //LW/SW is a don't care
		 (opcode[3:1] == 3'b101)						? Load_Byte : //LHB/LLB
		 (opcode[3:2] == 2'b11)							? address_inc : //PCS; other opcodes are don't cares
											  16'hFFFF;

assign DstReg = (opcode == 4'b1000) ? Rt : Rd;
assign SrcReg1 = Rs;
assign SrcReg2 = (opcode[3:1] == 3'b101) ? Rd : Rt;

// Registers
RegisterFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(DstReg), .WriteReg(WriteReg), .DstData(DstData), .SrcData1(SrcData1), .SrcData2(SrcData2));

assign Data_Mem_en = (opcode[3:1] == 3'b100) ? 1'b1 : 1'b0;
assign Data_Mem_wr = (opcode == 4'b1001) ? 1'b1 : 1'b0;
assign Data_Mem_In = SrcData2;
assign Data_Mem_Addr = CLA_Sum;

// Data Memory
memory1c Dmem(.data_out(Data_Mem_Out), .data_in(Data_Mem_In), .addr(Data_Mem_Addr), .enable(Data_Mem_en), .wr(Data_Mem_wr), .clk(clk), .rst(~rst_n));

// PADDSB function
PSA_16bit PADDSB(.Sum(PADDSB_Sum), .Error(Error_dont_care), .A(SrcData1), .B(SrcData2));

// Shifting functions
Shifter Shift(.Shift_Out(Shift_Out), .Shift_In(SrcData1), .Shift_Val(imm), .Mode(opcode[1:0]));

assign Load_Byte = (opcode[0]) ? ((SrcData2 & 16'hFF00) | Load_Imm) : 
				 ((SrcData2 & 16'h00FF) | {Load_Imm, {8{1'b0}}});

assign branch = (opcode[0]) ? BR_Offset[9:1] : Branch_Imm;

// Branching functions
PC_Control Control(.C(condition), .I(branch), .F(flags), .PC_in(address_inc), .PC_out(new_pc));

assign ALU_In1 = (opcode[3]) ? (SrcData1 & 16'hFFFE) : SrcData1;
assign ALU_In2 = (opcode[3]) ? {{12{offset[3]}}, offset[2:0], 1'b0} : Rt_add;

// Carry Look-Ahead Adder ALU
CLA_16bit ALU(.In1(ALU_In1), .In2(ALU_In2), .cin(invert), .Sum(CLA_Sum), .Ov(overflow));

assign Z = ((opcode[3:1] == 3'b000) & (~(|CLA_Sum))) 						 ? 1'b1 :
	   ((opcode == 4'b001) & (~(|XOR_Out)))							 ? 1'b1 :
	   (((opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110)) & (~(|Shift_Out))) ? 1'b1 : 1'b0;

assign N = (opcode[3:1] == 3'b000) ? CLA_Sum[15] : flags[0];
assign V = (opcode[3:1] == 3'b000) ? overflow	 : flags[1];

assign New_Flags = {Z, V, N};

assign flag_wen = (opcode[3:1] == 3'b000) | (opcode == 4'b001) | (opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110);


// 3 bit Flag Register
Flags flag(.flags(flags), .clk(clk), .rst(~rst_n), .wen(flag_wen), .New_Flags(New_Flags));

// CLA for incrementing the PC by 2
CLA_16bit PC_Add(.In1(pc), .In2(16'h0002), .cin(1'b0), .Sum(address_inc), .Ov(address_overflow));

// CLA for Branch to Register instruction
CLA_16bit BR_Offset_Calc(.In1(SrcData1), .In2(~address_inc), .cin(1'b1), .Sum(BR_Offset), .Ov(BR_Offset_overflow));

// RED function
RED red(.In1(SrcData1), .In2(SrcData2), .Out(Red_Out));

// XOR function
XOR_16bit xor16(.A(SrcData1), .B(SrcData2), .X(XOR_Out));
endmodule
