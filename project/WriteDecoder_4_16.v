module WriteDecoder_4_16(input [3:0] RegId, input WriteReg, output [15:0] Wordline);

assign Wordline = ((RegId == 4'h0) & WriteReg) ? (16'h0001) :
		  ((RegId == 4'h1) & WriteReg) ? (16'h0002) :
		  ((RegId == 4'h2) & WriteReg) ? (16'h0004) :
		  ((RegId == 4'h3) & WriteReg) ? (16'h0008) :
		  ((RegId == 4'h4) & WriteReg) ? (16'h0010) :
		  ((RegId == 4'h5) & WriteReg) ? (16'h0020) :
		  ((RegId == 4'h6) & WriteReg) ? (16'h0040) :
		  ((RegId == 4'h7) & WriteReg) ? (16'h0080) :
		  ((RegId == 4'h8) & WriteReg) ? (16'h0100) :
		  ((RegId == 4'h9) & WriteReg) ? (16'h0200) :
		  ((RegId == 4'hA) & WriteReg) ? (16'h0400) :
		  ((RegId == 4'hB) & WriteReg) ? (16'h0800) :
		  ((RegId == 4'hC) & WriteReg) ? (16'h1000) :
		  ((RegId == 4'hD) & WriteReg) ? (16'h2000) :
		  ((RegId == 4'hE) & WriteReg) ? (16'h4000) :
		  ((RegId == 4'hF) & WriteReg) ? (16'h8000) :
				    		 (16'h0000);


endmodule
