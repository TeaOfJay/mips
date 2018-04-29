module cache(
	output[15:0] data_out,
	input[15:0] data_in,
	input[15:0] addr, 
	input enable, //read enable
	input wr,     //write enable
	input clk,
	input rst,
	output busy,
	input stall,
	
	input[15:0] mem_rdata,
	output[15:0] mem_wdata,
	output[15:0] mem_addr,
	output mem_ren,
	output mem_wen,
	input mem_data_valid
);

//wire declarations
wire[6:0] decode_address;
wire[2:0] word_address;

wire[127:0] block_enable;
wire[7:0]   word_enable;

wire[15:0] data_write;
wire[7:0]  metadata;
wire[7:0] metadata_write;

wire wen_tag;  //tag write for metadata
wire wen_cache; //write data to cache
wire data_valid;
wire miss_detected;

wire[2:0] word_select;

//cache addressing
wire[3:0] 	block_offset;
wire[2:0] 	word_addr; 	 //unused
wire[6:0] 	set_addr;   
wire[4:0]   tag; 	

//address management 
assign block_offset = addr[3:0];
assign word_addr    = block_offset[3:1];  //block offset[0] is byte select for byte addressing, also unused
assign set_addr     = addr[10:4]; //placeholder for visualization, remove once done.
assign tag          = addr[15:11];

/**
* if there's write enable, you want the decoded address to be your write location
* if its read enable, you want the decode daddress to be your read 
*
**/
assign decode_address = addr[10:4]; //(enable) ? mem_address[10:4] : addr[10:4]; //do we need this? the decode address may be same for both write and read.

assign word_address = (wen_cache) ? word_select : addr[3:1];

assign metadata_write = {1'b1, 2'b00, tag}; // 8 bits total , valid bit set

assign data_write = (mem_wen) ? data_in : mem_rdata;
// TO-DO: unsure that pipeline halts may not stop writing of register values

/**
* its considered a hit only if its 
* a. valid
* b. tag matches
**/
assign miss_detected = (~(metadata[7] & (metadata[4:0] === tag))) & (wr | enable); //sign extension?

//memory signal assignments

// mem_rdata goes to data array
assign mem_wdata = data_in;
// mem_addr comes from fsm
assign mem_ren = miss_detected; //only read on misses for both read and write
assign mem_wen = ~miss_detected & wr;   //only write on hits and if we're obviously writing...

//decoders
cache_decoder cdecoder(
	.addr  (decode_address),
	.enable(block_enable)
);

word_decoder  wdecoder(
	.addr       (word_address),
	.word_enable(word_enable)
);

//our actual cache memory
DataArray data_array(
	.clk 		(clk),
	.rst 		(rst),
	.DataIn 	(data_write),
	.Write 		(wen_cache || mem_wen), 
	.BlockEnable(block_enable),
	.WordEnable (word_enable),
	.DataOut 	(data_out) //one word, aka 2 bytes (is direct read from cache array ok?)
);
MetaDataArray metadata_array(
	.clk 		(clk),
	.rst 		(rst),
	.DataIn 	(metadata_write), 
	.Write 		(wen_tag),
	.BlockEnable(block_enable),
    .DataOut    (metadata) //one byte
);
//metadata structure is [1] valid [7] tag
//if we want we can implement a dirty bit then as [1] valid [1] dirty [6] tag
// we could implement further bits if we wished.
// tag is at max 5 bits 

//fsm 
cache_fill_fsm fsm(
	.clk 				(clk),  
	.rst_n 				(~rst), 
	.miss_detected 		(miss_detected), 
	.miss_address  		(addr), 
	.fsm_busy      		(busy),
	.wen_cache      	(wen_cache),
	.wen_tag          	(wen_tag),
	.mem_address   		(mem_addr),
	.mem_data_valid		(mem_data_valid),
	.word_enable        (word_select),
	.stall              (stall)
);

endmodule // cache