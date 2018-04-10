module Shifter_tb ();
reg signed [15:0] Shift_In; //This is the number to perform shift operation on
reg [3:0] Shift_Val; //Shift amount (used to shift the ?Shift_In?)
reg  Mode; // To indicate SLL or SRA; 0:SLL 1:SRA
reg clk;

wire signed [15:0] Shift_Out; //Shifter value

Shifter iDUT(.Shift_In(Shift_In), .Shift_Val(Shift_Val), .Mode(Mode), .Shift_Out(Shift_Out));

always begin
	#2 clk = ~clk;
end

initial begin

	//Logical left shift by 1
	clk = 0;
	Shift_In = 16'b0001000100010001;
	Shift_Val = 1;
	Mode = 0;
	repeat(2) @(negedge clk);
	if(Shift_Out != 16'b0010001000100010) begin
		$display("Test 1 failed.");
		$stop;
	end
	else
		$display("Test 1 passed.");
	repeat(2) @(negedge clk);

	//Logical left shift by 6
	Shift_Val = 6;
	repeat(2) @(negedge clk);
	if(Shift_Out != 16'b0100010001000000) begin
		$display("Test 2 failed.");
		$stop;
	end
	else
		$display("Test 2 passed.");
	repeat(2) @(negedge clk);

	//Arithmetic right shift by 1; positive
	Shift_Val = 1;
	Mode = 1;
	repeat(2) @(negedge clk);
	if(Shift_Out != 16'b0000100010001000) begin
		$display("Test 3 failed.");
		$display(Shift_Out, );
		$stop;
	end
	else
		$display("Test 3 passed.");
	repeat(2) @(negedge clk);

	//Arithmetic right shift by 1; negative
	Shift_Val = 1;
	Shift_In = 16'b1000100010001000;
	repeat(2) @(negedge clk);
	if(Shift_Out != 16'b1100010001000100) begin
		$display("Test 4 failed.");
		$stop;
	end
	else
		$display("Test 4 passed.");
	repeat(2) @(negedge clk);
	$display("All tests passed.");
	$stop;
end

endmodule