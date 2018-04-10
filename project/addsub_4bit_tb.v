module addsub_4bit_tb();
	reg [3:0] inA;
	reg [3:0] inB;
	reg sub;
	reg clk;
	wire Ovfl;
	wire [3:0] sum;
	addsub_4bit iDUT(.Sum(sum), .Ovfl(Ovfl), .A(inA), .B(inB), .sub(sub));


	always begin
		#2 clk = ~clk;
	end

	initial begin

		// addition of positives w/ no overflow
		inA = 4'h2;
		inB = 4'h2;
		sub = 1'b0;
		clk = 1'b0;
		repeat(5)@(negedge clk);
		if(sum == 4'b0100 && Ovfl == 0)
			$display("Test1 Passed");
		else begin
			$display("Test1 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		// addition of positives w/ overflow
		inA = 4'h7;
		inB = 4'h7;
		repeat(5)@(negedge clk);
		if(sum == 4'b1110 && Ovfl == 1)
			$display("Test2 Passed");
		else begin
			$display("Test2 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		// addition of negatives w/ no overflow
		inA = 4'hf;
		inB = 4'hf;
		repeat(5)@(negedge clk);
		if(sum == 4'b1110 && Ovfl == 0)
			$display("Test3 Passed");
		else begin
			$display("Test3 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		// addition of negatives w/ overflow
		inA = 4'h8;
		inB = 4'h8;
		repeat(5)@(negedge clk);
		if(sum == 4'b0000 && Ovfl == 1)
			$display("Test4 Passed");
		else begin
			$display("Test4 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		// subtraction w/ no overflow
		inA = 4'h7;
		inB = 4'h6;
		sub = 1'b1;
		repeat(5)@(negedge clk);
		if(sum == 4'b0001 && Ovfl == 0)
			$display("Test5 Passed");
		else begin
			$display("Test5 Failed");
			$stop;
		end
		repeat(5)@(negedge clk);

		// subtraction w/ overflow
		inA = 4'h8;
		inB = 4'h1;
		repeat(5)@(negedge clk);
		if(sum == 4'b0111 && Ovfl == 1)
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