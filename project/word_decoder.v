module word_decoder(
	input[2:0] addr, 
	output[6:0] word_enable
);
always @(addr) begin
	case(addr)
		3'h1: word_enable = 7'h01;
		3'h2: word_enable = 7'h02;
		3'h3: word_enable = 7'h04;
		3'h4: word_enable = 7'h08;
		3'h5: word_enable = 7'h10;
		3'h6: word_enable = 7'h20;
		3'h7: word_enable = 7'h40;
		default: word_enable = 7'h0;
	endcase // addr
end
endmodule // word_decoder