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

///////////////Pipelining wire additions//////////
wire flush, q_flush, ex_flush;

wire ifid_en;
wire [15:0] q_pc, q_instr, d_next_address;

wire Ctl_Data_Mem_en, Ctl_Data_Mem_wr, Ctl_WriteReg;
wire [3:0] Ctl_DstReg, Ctl_opcode, q_SrcReg1, q_SrcReg2;
wire [15:0] Data1, Data2;
wire [15:0] out_instr;

wire ex_Data_Mem_en, ex_Data_Mem_wr, ex_WriteReg;
wire PC_Ctl_flush;
wire [3:0] ex_DstReg, ex_opcode;
wire [3:0] q_imm, q_offset;
wire [2:0] q_condition;
wire [7:0] q_Load_Imm;
wire [8:0] q_Branch_Imm;
wire [15:0] q_SrcData1, q_SrcData2;

wire exmem_en, q_Data_Mem_en, q_Data_Mem_wr, mem_WriteReg, from_mem, mem_from_mem, exmem_Data_Mem_en, exmem_Data_Mem_wr, exmem_WriteReg;
wire [3:0] mem_DstReg;
wire [15:0] q_Data_Mem_In, q_Data_Mem_Addr, mem_DstData;

wire sub2_ov;
wire [15:0] q_Branch_Imm_sub2;

wire q_from_mem, memwb_en, q_WriteReg;
wire [3:0] q_DstReg;
wire [15:0] q_MemData, q_DstData;

wire [15:0] wb_data;

wire ex_hlt, mem_hlt;

wire next_stall, stall, inst_stall, data_stall;
wire ctrl_stall;
/////////////////////////////////////////////////

//////////////////////////////////////
assign ifid_en = (ctrl_stall) ? 1'b0 : 1'b1;
assign idex_en = (ctrl_stall) ? 1'b0 : 1'b1;
assign exmem_en = (ctrl_stall) ? 1'b0 : 1'b1;
assign memwb_en = (ctrl_stall) ? 1'b0 : 1'b1;

assign ctrl_stall = (stall | inst_stall | data_stall);
//////////////////////////////////////


assign Instr_En = (~rst_n) ? 1'b0 : 1'b1; 

assign next_address = ((ex_opcode[3:1] == 3'b110) & ~ex_flush) ? new_pc : address_inc; //Incremented PC or Branch.  THIS NEEDS TO BE FIGURED OUT FOR BRANCHES

assign pc_wen = (~rst_n | hlt | stall | inst_stall | data_stall) ? 1'b0 : 1'b1;

// 16 bit register to hold current pc value
dff_16bit program(.q(pc), .d(next_address), .wen(pc_wen), .clk(clk), .rst(~rst_n)); 

// instr cache
cache icache(
	.data_out(Instr),
	.data_in(Instr_Data_In), 
	.addr(pc), 
	.enable(Instr_En), 
	.wr(1'b0), 
	.clk(clk), 
	.rst(~rst_n),
	.busy(inst_stall) 
);


// IF/ID Pipeline Stage
ifid dff_ifid(.clk(clk), .rst(~rst_n), .flush(flush), .ifid_en(ifid_en), .q_flush(q_flush), .q_nextpc(q_pc), .q_instr(out_instr), .d_nextpc(pc), .d_instr(Instr));

assign q_instr = out_instr; //(stall) ? 16'h0000 : out_instr; //Create bubble upon stall

Control control(.clk(clk), .rst(~rst_n), .instr(q_instr), .opcode(Ctl_opcode), .Data_Mem_en(Ctl_Data_Mem_en), .Data_Mem_wr(Ctl_Data_Mem_wr), .DstReg(Ctl_DstReg), .WriteReg(Ctl_WriteReg));

assign Rd = q_instr[11:8];
assign Rs = q_instr[7:4];
assign Rt = ((Ctl_opcode == 4'b1000) | (Ctl_opcode == 4'b1001)) ? q_instr[11:8] : q_instr[3:0];
assign imm = q_instr[3:0];
assign Load_Imm = q_instr[7:0];
assign offset = q_instr[3:0];
assign Branch_Imm = q_instr[8:0];
assign condition = q_instr[11:9];

assign SrcReg1 = Rs;
assign SrcReg2 = (Ctl_opcode[3:1] == 3'b101) ? Rd : Rt;

// Registers
RegisterFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(q_DstReg), .WriteReg(q_WriteReg), .DstData(wb_data), .SrcData1(SrcData1), .SrcData2(SrcData2));

idex dff_idex(.clk(clk), .rst(~rst_n), .flush(flush), .d_flush(q_flush), .idex_en(idex_en), .d_Data_Mem_en(Ctl_Data_Mem_en), .d_Data_Mem_wr(Ctl_Data_Mem_wr), .d_WriteReg(Ctl_WriteReg), .d_DstReg(Ctl_DstReg), .d_opcode(Ctl_opcode), .d_SrcData1(SrcData1), .d_SrcData2(SrcData2), .d_SrcReg1(SrcReg1), .d_SrcReg2(SrcReg2), .d_imm(imm), .d_Load_Imm(Load_Imm), .d_offset(offset), .d_Branch_Imm(Branch_Imm), .d_condition(condition), .ex_flush(ex_flush), .q_Data_Mem_en(ex_Data_Mem_en), .q_Data_Mem_wr(ex_Data_Mem_wr), .q_WriteReg(ex_WriteReg), .q_DstReg(ex_DstReg), .q_opcode(ex_opcode), .q_SrcData1(q_SrcData1), .q_SrcData2(q_SrcData2), .q_SrcReg1(q_SrcReg1), .q_SrcReg2(q_SrcReg2), .q_imm(q_imm), .q_Load_Imm(q_Load_Imm), .q_offset(q_offset), .q_Branch_Imm(q_Branch_Imm), .q_condition(q_condition));

//Data Forwarding
assign Data1 = (mem_WriteReg & (mem_DstReg != 4'b0000) & (q_SrcReg1 == mem_DstReg) & mem_from_mem) 	? Data_Mem_Out : //Forward in mem stage after read from Dmem
	       (mem_WriteReg & (mem_DstReg != 4'b0000) & (q_SrcReg1 == mem_DstReg))			? mem_DstData  : //Forward in mem stage from calculation
	       (q_WriteReg & (q_DstReg != 4'b0000) & (q_SrcReg1 == q_DstReg)) 				? wb_data      : //Forward in wb stage
											  		  q_SrcData1;	 //No forward

assign Data2 = (mem_WriteReg & (mem_DstReg != 4'b0000) & (q_SrcReg2 == mem_DstReg) & mem_from_mem) 	? Data_Mem_Out : //Forward in mem stage after read from Dmem
	       (mem_WriteReg & (mem_DstReg != 4'b0000) & (q_SrcReg2 == mem_DstReg))			? mem_DstData  : //Forward in mem stage from calculation
	       (q_WriteReg & (q_DstReg != 4'b0000) & (q_SrcReg2 == q_DstReg)) 				? q_DstData    : //Forward in wb stage
											  		  q_SrcData2;    //No forward

//Pipeline Stall
assign next_stall = (stall)										? 1'b0 :
		    ((ex_Data_Mem_en & ~ex_Data_Mem_wr) & ((ex_DstReg == Rs) || (ex_DstReg == Rt)))	? 1'b1 :
													  1'b0;

dff dff_stall(.clk(clk), .rst(~rst_n), .wen(1'b1), .d(next_stall), .q(stall));

assign DstData = (ex_opcode[3:1] == 3'b000) 							? CLA_Sum : //ADD/SUB
		 (ex_opcode == 4'b0010)								? Red_Out : //RED
		 (ex_opcode == 4'b0011)	 							? XOR_Out : //XOR
		 ((ex_opcode == 4'b0100) | (ex_opcode == 4'b0101) | (ex_opcode == 4'b0110))	? Shift_Out : //SLL/SRA/ROR
		 (ex_opcode == 4'b0111)								? PADDSB_Sum : //PADDSB
		 (ex_opcode[3:1] == 3'b101)							? Load_Byte : //LHB/LLB
		 (ex_opcode[3:2] == 2'b11)							? address_inc : //PCS; other opcodes are don't cares
											  	16'hFFFF;

assign from_mem = (ex_opcode == 4'b1000);

assign ex_hlt = ((ex_opcode == 4'b1111) & ~ex_flush);

assign flush = (PC_Ctl_flush & (ex_opcode[3:1] == 3'b110) & ~ex_flush);

// PADDSB function
PSA_16bit PADDSB(.Sum(PADDSB_Sum), .Error(Error_dont_care), .A(Data1), .B(Data2));

// Shifting functions
Shifter Shift(.Shift_Out(Shift_Out), .Shift_In(Data1), .Shift_Val(q_imm), .Mode(ex_opcode[1:0]));

assign Load_Byte = (ex_opcode[0]) ? ((Data2 & 16'hFF00) | q_Load_Imm) : 
				 ((Data2 & 16'h00FF) | {q_Load_Imm, {8{1'b0}}});


CLA_16bit sub2(.In1({{7{q_Branch_Imm[8]}}, q_Branch_Imm}), .In2(16'hFFFE), .cin(1'b0), .Sum(q_Branch_Imm_sub2), .Ov(sub2_ov)); // Subtract two for branching

assign branch = (ex_opcode[0]) ? BR_Offset[9:1] : q_Branch_Imm_sub2;

// Branching functions
PC_Control pc_control(.C(q_condition), .I(branch), .F(flags), .PC_in(address_inc), .flush(PC_Ctl_flush), .PC_out(new_pc));

assign ALU_In1 = (ex_opcode[3]) ? (Data1 & 16'hFFFE) : Data1;
assign ALU_In2 = (ex_opcode[3]) ? {{12{q_offset[3]}}, q_offset[2:0], 1'b0} : Rt_add;

assign invert = (ex_opcode == 4'b0001) ? 1'b1 : 1'b0; // Control signal for 2's complement when subtracting
assign Rt_add = invert ? ~Data2 : Data2; // 2's Complement when subtracting

// Carry Look-Ahead Adder ALU
CLA_16bit ALU(.In1(ALU_In1), .In2(ALU_In2), .cin(invert), .Sum(CLA_Sum), .Ov(overflow));

assign Z = ((ex_opcode[3:1] == 3'b000) & (~(|CLA_Sum))) 						  ? 1'b1 :
	   ((ex_opcode == 4'b001) & (~(|XOR_Out)))							  ? 1'b1 :
	   (((ex_opcode == 4'b0100) | (ex_opcode == 4'b0101) | (ex_opcode == 4'b0110)) & (~(|Shift_Out))) ? 1'b1 : 1'b0;

assign N = (ex_opcode[3:1] == 3'b000) ? CLA_Sum[15] 	: flags[0];
assign V = (ex_opcode[3:1] == 3'b000) ? overflow	: flags[1];

assign New_Flags = {Z, V, N};

assign flag_wen = (ex_opcode[3:1] == 3'b000) | (ex_opcode == 4'b001) | (ex_opcode == 4'b0100) | (ex_opcode == 4'b0101) | (ex_opcode == 4'b0110);


// 3 bit Flag Register
Flags flag(.flags(flags), .clk(clk), .rst(~rst_n), .wen(flag_wen), .New_Flags(New_Flags));

// CLA for incrementing the PC by 2
CLA_16bit PC_Add(.In1(pc), .In2(16'h0002), .cin(1'b0), .Sum(address_inc), .Ov(address_overflow));

// CLA for Branch to Register instruction
CLA_16bit BR_Offset_Calc(.In1(Data1), .In2(~address_inc), .cin(1'b1), .Sum(BR_Offset), .Ov(BR_Offset_overflow));

// RED function
RED red(.In1(Data1), .In2(Data2), .Out(Red_Out));

// XOR function
XOR_16bit xor16(.A(Data1), .B(Data2), .X(XOR_Out));

//used to be just stall
assign exmem_Data_Mem_en = (stall) ? 1'b0 : ex_Data_Mem_en;
assign exmem_Data_Mem_wr = (stall) ? 1'b0 : ex_Data_Mem_wr;
assign exmem_WriteReg    = (stall) ? 1'b0 : ex_WriteReg;

// EX/MEM Pipeline
exmem dff_exmem(.clk(clk), .rst(~rst_n), .exmem_en(exmem_en), .d_hlt(ex_hlt), .d_from_mem(from_mem), .d_Data_Mem_en(exmem_Data_Mem_en), .d_Data_Mem_wr(exmem_Data_Mem_wr), .d_WriteReg(exmem_WriteReg), .d_DstReg(ex_DstReg), .d_Data_Mem_In(q_SrcData2), .d_Data_Mem_Addr(CLA_Sum), .d_DstData(DstData), .q_from_mem(mem_from_mem), .q_Data_Mem_en(q_Data_Mem_en), .q_Data_Mem_wr(q_Data_Mem_wr), .q_hlt(mem_hlt), .q_WriteReg(mem_WriteReg), .q_DstReg(mem_DstReg), .q_Data_Mem_In(q_Data_Mem_In), .q_Data_Mem_Addr(q_Data_Mem_Addr), .q_DstData(mem_DstData));


// data cache
cache dcache(
	.data_out(Data_Mem_Out),
	.data_in(q_Data_Mem_In),
	.addr(q_Data_Mem_Addr),
	.enable(q_Data_Mem_en),
	.wr(q_Data_Mem_wr),
	.clk(clk),
	.rst(~rst_n),
	.busy(data_stall)
);

// MEM/WB Pipeline
memwb dff_memwb(.clk(clk), .rst(~rst_n), .memwb_en(memwb_en), .d_hlt(mem_hlt), .d_from_mem(mem_from_mem), .d_WriteReg(mem_WriteReg), .d_DstReg(mem_DstReg), .d_MemData(Data_Mem_Out), .d_DstData(mem_DstData), .q_hlt(hlt), .q_from_mem(q_from_mem), .q_WriteReg(q_WriteReg), .q_DstReg(q_DstReg), .q_MemData(q_MemData), .q_DstData(q_DstData));


assign wb_data = (q_from_mem) ? q_MemData : q_DstData;

endmodule
