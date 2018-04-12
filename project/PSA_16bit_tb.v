module PSA_16bit_tb ();
reg [15:0] A, B;
reg clk;
wire [15:0] Sum;
wire Error;

PSA_16bit iDUT(.A(A), .B(B), .Sum(Sum), .Error(Error));

always begin
	#2 clk = ~clk;
end

initial begin

	//Add, no overflow
	clk = 0;
	A = 16'b0001000100010001;
	B = 16'b0001000100010001;
	repeat(2) @(negedge clk);
	if(Sum != 16'b0010001000100010 | Error != 0) begin
		$display("Test 1 failed.");
		$stop;
	end
	else
		$display("Test 1 passed.");
	repeat(2) @(negedge clk);

	//Add, overflow in MSB
	A = 16'b1000100010001000;
	B = 16'b1000000000000000;
	repeat(2) @(negedge clk);
	if(Sum != 16'b0000100010001000 | Error != 1) begin
		$display("Test 2 failed.");
		$stop;
	end
	else
		$display("Test 2 passed.");
	repeat(2) @(negedge clk);

	//Add, overflow in 2nd to most significant bit
	A = 16'b1000100010001000;
	B = 16'b0000100000000000;
	repeat(2) @(negedge clk);
	if(Sum != 16'b1000000010001000 | Error != 1) begin
		$display("Test 3 failed.");
		$stop;
	end
	else
		$display("Test 3 passed.");
	repeat(2) @(negedge clk);

	//Add, overflow in 2nd to least significant bit
	A = 16'b1000100010001000;
	B = 16'b0000000010000000;
	repeat(2) @(negedge clk);
	if(Sum != 16'b1000100000001000 | Error != 1) begin
		$display("Test 4 failed.");
		$stop;
	end
	else
		$display("Test 4 passed.");
	repeat(2) @(negedge clk);

	//Add, overflow in LSb
	A = 16'b1000100010001000;
	B = 16'b0000000000001000;
	repeat(2) @(negedge clk);
	if(Sum != 16'b1000100010000000 | Error != 1) begin
		$display("Test 5 failed.");
		$stop;
	end
	else
		$display("Test 5 passed.");
	repeat(2) @(negedge clk);
	$display("All tests passed.");
	$stop;
end

endmodule
