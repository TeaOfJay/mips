module cache_fill_fsm(
    input clk,
    input rst_n,
    input miss_detected, 
    input[15:0] miss_address, 
    output fsm_busy, 
    output wen_cache,
    output wen_tag,
    output[15:0] mem_address,
    input[2:0] word_enable,
    input mem_data_valid,
	input stall
);
	
//general wire declarations
wire state, next_state;
	
wire receive_done; 

wire[3:0] qchunk, dchunk;
wire[3:0] incr_chunk;

wire[15:0] daddr, qaddr;
wire[15:0] incr_address;

wire[3:0] word_out;

//state flip flop
dff state_dff(.q(state), .d(next_state), .wen(1'b1), .clk(clk), .rst(~rst_n));


//chunk counter
dff_4bit chunk_dff(.q(qchunk), .d(dchunk), .wen(1'b1), .clk(clk), .rst(~rst_n));

CLA_4bit chunks(.In1(qchunk), .In2(4'b0000), .cin(1'b1), .Out(incr_chunk), .Prop(), .Gen(), .cout()); // adds 1 to chunks_received if a new chunk of data was received

assign dchunk = (next_state & mem_data_valid) ? incr_chunk : 4'b1111;

//address incrementer
dff_16bit addr_dff(.q(qaddr), .d(daddr), .wen(1'b1), .clk(clk), .rst(~rst_n));

CLA_16bit addr(.In1(mem_address), .In2 (16'h0002), .cin(1'b0), .Sum(incr_address), .Ov());

assign daddr = incr_address;

//state logic
assign next_state = (stall) ? 1'b0 : 
					(~state & miss_detected) ? 1'b1 :
                    (state & ~receive_done ) ? 1'b1 : 1'b0;
                    
//combination logic 
assign fsm_busy = (state | next_state) ? 1'b1 : 1'b0;
assign wen_tag = (state & ~next_state) ? 1'b1 : 1'b0;
assign wen_cache = (state & next_state & ~receive_done & mem_data_valid) ? 1'b1 : 1'b0; 

assign receive_done = (qchunk == 4'b0111);

assign mem_address = (~state & next_state) ? miss_address : qaddr;


wire[3:0] word1, word2, word3, word4;

dff_4bit wdff1(.q(word1), .d(mem_address[3:0]), .wen(1'b1), .clk(clk), .rst(~rst_n));
dff_4bit wdff2(.q(word2), .d(word1), .wen(1'b1), .clk(clk), .rst(~rst_n));
dff_4bit wdff3(.q(word3), .d(word2), .wen(1'b1), .clk(clk), .rst(~rst_n));
dff_4bit wdff4(.q(word4), .d(word3), .wen(1'b1), .clk(clk), .rst(~rst_n));
//assign dword = (next_state & mem_data_valid) ? {1'b0, miss_address[3:1]} : word_incr;
//CLA_4bit wordselect(.In1(qword), .In2(4'h1), .cin(1'b0), .Out(word_incr), .Prop(), .Gen(), .cout());

assign word_enable = word4[3:1];//(next_state & mem_data_valid) ? miss_address[3:1] : qword[2:0];

endmodule // cache_fill_fsm