module ALU_tb();
	reg [3:0] ALU_In1;
	reg [3:0] ALU_In2;
	reg [1:0] Opcode;
	reg clk;
	wire Error;
	wire [3:0] ALU_Out;

	ALU iDUT(.ALU_Out(ALU_Out),.Error(Error),.ALU_In1(ALU_In1),.ALU_In2(ALU_In2),.Opcode(Opcode));

	always begin
		#2 clk = ~clk;
	end

	initial begin
		clk = 0;
		Opcode = 2'b00;
		ALU_In1 = 4'h2;
		ALU_In2 = 4'h3;

		//Add w/ No Overflow : 2+3 = 5
		repeat(5)@(negedge clk);
		if(ALU_Out == 4'b0101 && Error == 0)
			$display("Test1 Passed");
		else begin
			$display("Test1 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		ALU_In1 = 4'h7;
		//Add w/ Overflow : 7+3 = 10
		repeat(5)@(negedge clk);
		if(ALU_Out == 4'b1010 && Error == 1)
			$display("Test2 Passed");
		else begin
			$display("Test2 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		Opcode = 2'b01;
		//Subtract w/ No Overflow : 7-3 = 4
		repeat(5)@(negedge clk);
		if(ALU_Out == 4'b0100 && Error == 0)
			$display("Test3 Passed");
		else begin
			$display("Test3 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		ALU_In1 = 4'h8;
		ALU_In2 = 4'h1;
		//Subtract w/ Overflow : -8 - 1 = -9
		repeat(5)@(negedge clk);
		if(ALU_Out == 4'b0111 && Error == 1)
			$display("Test4 Passed");
		else begin
			$display("Test4 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		ALU_In1 = 4'hA;
		ALU_In2 = 4'h3;
		Opcode = 2'b10;
		//NAND : 1010 NAND 0011 = 1101
		repeat(5)@(negedge clk);
		if(ALU_Out == 4'b1101 && Error == 0)
			$display("Test5 Passed");
		else begin
			$display("Test5 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		Opcode = 2'b11;
		//XOR : 1010 XOR 0011 = 1001
		repeat(5)@(negedge clk);
		if(ALU_Out == 4'b1001 && Error == 0)
			$display("Test6 Passed");
		else begin
			$display("Test6 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);
		$display("All Tests Passed");
		$stop;
	end

endmodule