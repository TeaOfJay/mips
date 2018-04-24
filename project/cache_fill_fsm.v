module cache_fill_fsm(
    input clk,
    input rst_n,
    input miss_detected, 
    input[15:0] miss_address, 
    output fsm_busy, 
    output wen_data,
    output wen_tag,
    output[15:0] mem_address,
    input[15:0] mem_data, //unused
    input mem_data_valid);

wire[15:0] base_address;
wire[3:0] qchunk, dchunk;
wire receive_done; 


dff state_dff(.q(qstate), .d(next_state), .wen(1'b1), .clk(clk), .rst(synch_rst));
dff_4bit chunk_dff(.q(qchunk), .d(dchunk), .wen(mem_data_valid), .clk(clk), .rst());

//state logic

assign state = (~rst_n) ? 1'b0 : qstate;

assign next_state = (~state & miss_detected) ? 1'b1 :
                    (state & receive_done) ? 1'b1 : 1'b0;
                    
//combination logic 

assign fsm_busy = (next_state) ? 1'b1 : 1'b0;
assign wen_tag = (state & ~next_state) ? 1'b1 : 1'b0;
assign wen_data = (state & next_state & ~receive_done & mem_data_valid) ? 1'b1 : 1'b0;

assign receive_done = (qchunk == 4'b1000);

assign dchunk = qchunk + 1'b1;

assign base_address = (miss_detected) ? miss_address : base_address;

assign mem_address = {base_address, {dchunk}};

endmodule // cache_fill_fsm