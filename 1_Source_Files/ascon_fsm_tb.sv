`timescale 1ns / 1ps

module ascon_fsm_tb ();
    
logic clock_w;
logic reset_w;
logic start_w;
logic [1447:0] plain_text_w;
logic [127:0] key_w;
logic [127:0] nonce_w;
logic [63:0] da_w;

logic [127:0] tag_w;
logic [1447:0] cipher_w;

assign plain_text_w = 0;
assign key_w =0;
assign nonce_w =0;
assign da_w =0;

ascon_fsm DUT(
    .clock_i(clock_w),
    .reset_i(reset_w),
    .start_i(start_w),
    .plain_text_i(plain_text_w),
    .key_i(key_w),
    .nonce_i(nonce_w),
    .da_i(da_w),
    .tag_i(tag_w),
    .cipher_i(cipher_w)
);

initial begin
		clock_w = 1'b0;
		forever #10 clock_w = ~clock_w;
	end

initial begin
    assign reset_w = 1'b1;
    #40
    assign start_w = 1'b1;
    end

endmodule