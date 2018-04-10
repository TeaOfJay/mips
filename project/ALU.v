
module ALU(ALU_Out,Error,ALU_In1,ALU_In2,Opcode);

input signed [3:0] ALU_In1,ALU_In2;		// two 4-bit quantities to be addes/subtracted
input [1:0] Opcode;				// 00: ADD 01:SUB 10:NAND 11:XOR
output signed [3:0] ALU_Out;			// result of  operation
output Error;					// overflow

wire signed [3:0] sum;
wire ovfl;

addsub_4bit A0(.Sum(sum), .Ovfl(ovfl), .A(ALU_In1), .B(ALU_In2), .sub(Opcode[0]));

assign Error = (Opcode[1]) ? 0 : ovfl; //Overflow only if adding or subtracting

// 00: ADD 01:SUB 10:NAND 11:XOR
assign ALU_Out = (Opcode == 2'b00) ? sum :
		 (Opcode == 2'b01) ? sum :
		 (Opcode == 2'b10) ? ~(ALU_In1 & ALU_In2) :
				    ALU_In1 ^ ALU_In2;
endmodule 