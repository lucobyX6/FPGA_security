`timescale 1ns / 1ps

module top_level_fpga
  import uart_pkg::*;
(
    input  logic       clock_i,  //main clock
    input  logic       reset_i,  //asynchronous reset active low
    input  logic       Rx_i,     //RX to RS232
    output logic       Tx_o,     //Tx to RS 232
    output logic [2:0] Baud_o,
    output logic       RTS_o
);  
  // Baud_i
  logic [2:0] Baud_w;
  
  logic RXErr_s;
  logic RXRdy_s;
  logic TxBusy_s;
  logic rdata_ld_s;
  logic [NDBits-1:0] rdata_s;
  logic [NDBits-1:0] Dout_s;
  logic clock_s;
  logic resetb_s;

  assign Baud_w   = 3'b000;
  assign Baud_o   = Baud_w;
  assign resetb_s = ~reset_i;
  assign RTS_o    = RXRdy_s;  //from Nathan improve UART behavior (pin 1sur USB SERIAL)

  //internal signals for UART part
  logic [127:0] tag_s;
  logic [1471:0] wave_to_send_s;
  logic cipherRdy_s;
  logic [127:0] key_s;
  logic [127:0] nonce_s;
  logic [63:0] ad_s;
  logic [1471:0] wave_received_s;
  logic start_ascon_s;
  logic init_cpt_mux_s;
  logic en_cpt_mux_s;
  logic en_reg_ascon_s;
  logic cipher_valid_s;
  logic end_ascon_s;

  //mux for injected data in ascon
  logic [63:0] data_s, cipher_s;
  logic [4:0] cpt_s;  //cpt 5 bits
  //logic [0:22][63:0] wave_o_s;  //1472+64 packed
  
  //reg cipher + tag
  logic [1471:0] ascon_to_reg_cipher_w;
  logic [127:0] ascon_to_reg_tag_w;
  logic en_cipher_reg_w;
  logic en_tag_reg_w;

  // Clock convertor 125MHz -> 50MHz
   clk_wiz_0 CLK0
   (
    // Clock out ports
    .clk_out1(clock_s),
    .reset(reset_i),
    .clk_in1(clock_i)
   );

  uart_core uart_core_0 (
      .clock_i(clock_s),
      .resetb_i(resetb_s),
      .Din_i(rdata_s),
      .LD_i(rdata_ld_s),
      .Rx_i(Rx_i),
      .Baud_i(Baud_w),
      .RXErr_o(RXErr_s),
      .RXRdy_o(RXRdy_s),
      .Dout_o(Dout_s),
      .Tx_o(Tx_o),
      .TxBusy_o(TxBusy_s)
  );

  fsm_uart fsm_uart_0 (
      .clock_i(clock_s),
      .resetb_i(resetb_s),
      .RXErr_i(RXErr_s),
      .RXRdy_i(RXRdy_s),
      .TxBusy_i(TxBusy_s),
      .RxData_i(Dout_s),
      .Tag_i(tag_s),
      .Cipher_i(wave_to_send_s),
      .CipherRdy_i(end_ascon_s),
      .TxByte_o(rdata_s),
      .Key_o(key_s),
      .Nonce_o(nonce_s),
      .Ad_o(ad_s),
      .Wave_o(wave_received_s),
      .Start_ascon_o(start_ascon_s),
      .Load_o(rdata_ld_s)
  );

ascon_fsm ascon_fsm_0 (
  .clock_i(clock_s),
  .reset_i(resetb_s),
  .start_i(start_ascon_s),
  .plain_text_i(wave_received_s),
  .key_i(key_s),
  .nonce_i(nonce_s),
  .da_i(ad_s),
  .tag_o(tag_s),
  .cipher_o(ascon_to_reg_cipher_w),
  .end_ascon_o(end_ascon_s),
  .en_cipher_reg_o(en_cipher_reg_w),
  .en_tag_reg_o(en_tag_reg_w)

);

always_ff @(posedge clock_s, negedge resetb_s) begin : cipher_reg
    if (resetb_s == 1'b0) begin
      wave_to_send_s =0;
    end 
    else 
    begin
        if(en_cipher_reg_w == 1'b1) 
        begin   
            wave_to_send_s=ascon_to_reg_cipher_w;
        end
        else
        begin
            wave_to_send_s=wave_to_send_s;
        end
    end
  end : cipher_reg

endmodule : top_level_fpga
