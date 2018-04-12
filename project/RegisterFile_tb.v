module RegisterFile_tb();
reg clk, rst, WriteReg;
reg [3:0] SrcReg1, SrcReg2, DstReg;
reg [15:0] DstData;
wire [15:0] SrcData1, SrcData2;

RegisterFile iDUT(.clk(clk), .rst(rst), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(DstReg), .WriteReg(WriteReg), .DstData(DstData), .SrcData1(SrcData1), .SrcData2(SrcData2));

always begin
	#2 clk = ~clk;
end

initial begin
	clk = 0;
	rst = 1;
	repeat(4) @(posedge clk);
	rst = 0;
	DstReg = 4'h2;
	DstData = 16'h2222;		//Write 16'h2222 to register 2
	WriteReg = 1;
	repeat(4) @(posedge clk);
	WriteReg = 0;
	repeat(2) @(posedge clk);

	DstReg = 4'h4;
	DstData = 16'h4444;		//Write 16'h4444 to register 4
	WriteReg = 1;
	repeat(4) @(posedge clk);
	WriteReg = 0;
	repeat(2) @(posedge clk);

	DstReg = 4'h6;
	DstData = 16'h6666;		//Write 16'h6666 to register 6
	WriteReg = 1;
	repeat(4) @(posedge clk);
	WriteReg = 0;
	repeat(2) @(posedge clk);

	DstReg = 4'h8;
	DstData = 16'h8888;		//Write 16'h8888 to register 8
	WriteReg = 1;
	repeat(4) @(posedge clk);
	WriteReg = 0;
	repeat(2) @(posedge clk);
					//Read 16'h2222 from register 2 and 16'h4444 from register 4
	SrcReg1 = 4'h2;
	SrcReg2 = 4'h4;
	repeat(2) @(posedge clk);
	if(SrcData1 != 16'h2222 || SrcData2 != 16'h4444) begin
		$display("Test 1 Failed.");
		$stop;
	end
	else
		$display("Test 1 Passed.");
	repeat(2) @(posedge clk);
					//Read 16'h4444 from register 4 and 16'h6666 from register 6
	SrcReg1 = 4'h6;
	SrcReg2 = 4'h8;
	repeat(2) @(posedge clk);
	if(SrcData1 != 16'h6666 || SrcData2 != 16'h8888) begin
		$display("Test 2 Failed.");
		$stop;
	end
	else
		$display("Test 2 Passed.");
	repeat(2) @(posedge clk);
					//Read 16'h7777 from register 7 while writing 16'h7777 to it(internal bypassing)
					//Previous value was 16'h0000
	SrcReg1 = 4'h7;
	SrcReg2 = 4'h7;
	DstReg = 4'h7;
	DstData = 16'h7777;
	WriteReg = 1;
	@(posedge clk);
	WriteReg = 0;
	if(SrcData1 != 16'h7777 || SrcData2 != 16'h7777) begin
		$display("Test 3 Failed.");
		$stop;
	end
	else
		$display("Test 3 Passed.");

	@(posedge clk);
					//Read 16'h7777 from register 7 to make sure it was written while being bypassed
	if(SrcData1 != 16'h7777 || SrcData2 != 16'h7777) begin
		$display("Test 4 Failed.");
		$stop;
	end
	else
		$display("Test 4 Passed.");
	repeat(2) @(posedge clk);


	$display("All Tests Passed");
	$stop;
end

endmodule
