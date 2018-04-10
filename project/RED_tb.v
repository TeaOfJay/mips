module RED_tb();
reg clk;
reg [15:0] In1, In2;
wire [15:0] Out;

RED iDUT(.In1(In1), .In2(In2), .Out(Out));

always begin
	#2 clk = ~clk;
end

initial begin
	In1 = 16'h4646;
	In2 = 16'h6464;
	clk = 1;
	repeat(2) @(posedge clk);

	if(Out != 16'h0028) begin
		$display("Test 1 Failed.");
		$stop;
	end
	else begin
		$display("Test 1 Passed.");
	end
	repeat(2) @(posedge clk);

	In1 = 16'h7979;
	In2 = 16'h9797;

	repeat(2) @(posedge clk);
	if(Out != 16'h0000) begin
		$display("Test 2 Failed.");
		$display(Out);
		$stop;
	end
	else begin
		$display("Test 2 Passed.");
	end

	repeat(2) @(posedge clk);

	In1 = 16'h0009;
	In2 = 16'h0006;

	repeat(2) @(posedge clk);
	if(Out != 16'h000F) begin
		$display("Test 4 Failed.");
		$display(Out);
		$stop;
	end
	else begin
		$display("Test 4 Passed.");
	end

	$display("All Tests Passed.");
	$stop;

end


endmodule
