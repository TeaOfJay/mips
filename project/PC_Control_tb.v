module PC_Control_tb();

reg [2:0] c, f;
reg [8:0] i;
reg [15:0] pc_in;

wire [15:0] pc_out;

PC_Control iDUT(.C(c), .I(i), .F(f), .PC_in(pc_in), .PC_out(pc_out));

initial begin
	c = 3'b000;
	f = 3'b000;
	i = 4;
	pc_in = 16'hFF00;
	#5;
	if(pc_out != 16'hFF08) begin
		$display("Test 1 Failed");
		$stop;
	end
	f = 3'b100;
	#5
	if(pc_out != 16'hFF00) begin
		$display("Test 2 Failed");
		$stop;
	end
	c = 3'b001;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 3 Failed");
		$stop;
	end
	f = 3'b000;
	#5
	if(pc_out != 16'hFF00) begin
		$display("Test 4 Failed");
		$stop;
	end
	c = 3'b010;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 5 Failed");
		$stop;
	end
	f = 3'b100;
	#5
	if(pc_out != 16'hFF00) begin
		$display("Test 6 Failed");
		$stop;
	end
	c = 3'b011;
	f = 3'b001;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 7 Failed");
		$stop;
	end
	f = 3'b000;
	#5
	if(pc_out != 16'hFF00) begin
		$display("Test 8 Failed");
		$stop;
	end
	c = 3'b100;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 9 Failed");
		$stop;
	end
	f = 3'b100;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 10 Failed");
		$stop;
	end
	f = 3'b001;
	#5
	if(pc_out != 16'hFF00) begin
		$display("Test 11 Failed");
		$stop;
	end
	c = 3'b101;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 12 Failed");
		$stop;
	end
	f = 3'b100;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 13 Failed");
		$stop;
	end
	f = 3'b000;
	#5
	if(pc_out != 16'hFF00) begin
		$display("Test 14 Failed");
		$stop;
	end
	c = 3'b110;
	f = 3'b010;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 15 Failed");
		$stop;
	end
	f = 3'b000;
	#5
	if(pc_out != 16'hFF00) begin
		$display("Test 16 Failed");
		$stop;
	end
	c = 3'b111;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 17 Failed");
		$stop;
	end
	f = 3'b111;
	#5
	if(pc_out != 16'hFF08) begin
		$display("Test 18 Failed");
		$stop;
	end
	$display("All Tests Passed.");
	$stop;
end

endmodule


//zvn