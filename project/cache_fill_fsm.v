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

//state flip flop
dff state_dff(.q(state), .d(next_state), .wen(1'b1), .clk(clk), .rst(~rst_n));


//chunk counter
dff_4bit chunk_dff(.q(qchunk), .d(dchunk), .wen(1'b1), .clk(clk), .rst(~rst_n));

CLA_4bit chunks(.In1(qchunk), .In2(4'b0000), .cin(1'b1), .Out(incr_chunk), .Prop(prop), .Gen(gen), .cout(cout)); // adds 1 to chunks_received if a new chunk of data was received

assign dchunk = (~stall & next_state & mem_data_valid) ? incr_chunk : 4'b1111;

//address incrementer
dff_16bit addr_dff(.q(qaddr), .d(daddr), .wen(1'b1), .clk(clk), .rst(~rst_n));

CLA_16bit addr(.In1(qaddr), .In2 (16'h0002), .cin(1'b0), .Sum(incr_address), .Ov());

assign daddr = (~stall & next_state & ~(~dchunk[3] & dchunk[2])) ? incr_address : miss_address;


//state logic
assign next_state = (~state & miss_detected) ? 1'b1 :
                    (state & ~receive_done) ? 1'b1 : 1'b0;
                    
//combination logic 
assign fsm_busy = (state | next_state) ? 1'b1 : 1'b0;
assign wen_tag = (state & ~next_state) ? 1'b1 : 1'b0;
assign wen_cache = (state & next_state & ~receive_done & mem_data_valid) ? 1'b1 : 1'b0; 

assign receive_done = (qchunk == 4'b0111);

assign mem_address = qaddr;

assign word_enable = dchunk[2:0];

endmodule // cache_fill_fsm