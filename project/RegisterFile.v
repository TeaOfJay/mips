module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0] DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

wire [15:0] Read_Wordline1, Read_Wordline2, Write_Wordline1, Data1, Data2;

ReadDecoder_4_16 RD1(.RegId(SrcReg1), .Wordline(Read_Wordline1));
ReadDecoder_4_16 RD2(.RegId(SrcReg2), .Wordline(Read_Wordline2));

WriteDecoder_4_16 WD1(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(Write_Wordline1));

Register R0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[0]), .ReadEnable1(Read_Wordline1[0]), .Readenable2(Read_Wordline2[0]), .Bitline1(Data1), .Bitline2(Data2));
Register R1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[1]), .ReadEnable1(Read_Wordline1[1]), .Readenable2(Read_Wordline2[1]), .Bitline1(Data1), .Bitline2(Data2));
Register R2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[2]), .ReadEnable1(Read_Wordline1[2]), .Readenable2(Read_Wordline2[2]), .Bitline1(Data1), .Bitline2(Data2));
Register R3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[3]), .ReadEnable1(Read_Wordline1[3]), .Readenable2(Read_Wordline2[3]), .Bitline1(Data1), .Bitline2(Data2));
Register R4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[4]), .ReadEnable1(Read_Wordline1[4]), .Readenable2(Read_Wordline2[4]), .Bitline1(Data1), .Bitline2(Data2));
Register R5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[5]), .ReadEnable1(Read_Wordline1[5]), .Readenable2(Read_Wordline2[5]), .Bitline1(Data1), .Bitline2(Data2));
Register R6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[6]), .ReadEnable1(Read_Wordline1[6]), .Readenable2(Read_Wordline2[6]), .Bitline1(Data1), .Bitline2(Data2));
Register R7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[7]), .ReadEnable1(Read_Wordline1[7]), .Readenable2(Read_Wordline2[7]), .Bitline1(Data1), .Bitline2(Data2));
Register R8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[8]), .ReadEnable1(Read_Wordline1[8]), .Readenable2(Read_Wordline2[8]), .Bitline1(Data1), .Bitline2(Data2));
Register R9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[9]), .ReadEnable1(Read_Wordline1[9]), .Readenable2(Read_Wordline2[9]), .Bitline1(Data1), .Bitline2(Data2));
Register R10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[10]), .ReadEnable1(Read_Wordline1[10]), .Readenable2(Read_Wordline2[10]), .Bitline1(Data1), .Bitline2(Data2));
Register R11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[11]), .ReadEnable1(Read_Wordline1[11]), .Readenable2(Read_Wordline2[11]), .Bitline1(Data1), .Bitline2(Data2));
Register R12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[12]), .ReadEnable1(Read_Wordline1[12]), .Readenable2(Read_Wordline2[12]), .Bitline1(Data1), .Bitline2(Data2));
Register R13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[13]), .ReadEnable1(Read_Wordline1[13]), .Readenable2(Read_Wordline2[13]), .Bitline1(Data1), .Bitline2(Data2));
Register R14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[14]), .ReadEnable1(Read_Wordline1[14]), .Readenable2(Read_Wordline2[14]), .Bitline1(Data1), .Bitline2(Data2));
Register R15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(Write_Wordline1[15]), .ReadEnable1(Read_Wordline1[15]), .Readenable2(Read_Wordline2[15]), .Bitline1(Data1), .Bitline2(Data2));

assign SrcData1 = ((SrcReg1 == DstReg) & WriteReg) ? DstData : Data1;
assign SrcData2 = ((SrcReg2 == DstReg) & WriteReg) ? DstData : Data2;
//assign SrcData1 = Data1;
//assign SrcData2 = Data2;
endmodule
