module CLA_16bit_tb();
reg [15:0] In1, In2;
reg cin, clk;
wire [15:0] Sum;
wire Ov;

CLA_16bit iDUT(.In1(In1), .In2(In2), .cin(cin), .Sum(Sum), .Ov(Ov));

always begin
	#2 clk = ~clk;
end

initial begin
	clk = 0;
	In1 = 16'h0404;
	In2 = 16'h0404;
	cin = 0;
	repeat(2) @(posedge clk);

	if(Sum != 16'h0808) begin
		$display("Test 1 Failed");
		$stop;
	end
	else
		$display("Test 1 Passed");

	repeat(2) @(posedge clk);

	In1 = 16'h0789;
	In2 = 16'h0987;

	repeat(2) @(posedge clk);

	if(Sum != 16'h1110) begin
		$display("Test 2 Failed");
		$stop;
	end
	else
		$display("Test 2 Passed");

	repeat(2) @(posedge clk);

	In1 = 16'h7777;
	In2 = 16'h7777;

	repeat(2) @(posedge clk);

	if(Sum != 16'h7FFF) begin
		$display("Test 3 Failed");
		$stop;
	end
	else
		$display("Test 3 Passed");

	repeat(2) @(posedge clk);

	In1 = 16'h8044;
	In2 = 16'h8044;

	repeat(2) @(posedge clk);

	if(Sum != 16'h8000) begin
		$display("Test 4 Failed");
		$stop;
	end
	else
		$display("Test 4 Passed");

	repeat(2) @(posedge clk);

	$display("All Tests Passed.");
	$stop;

end
endmodule
