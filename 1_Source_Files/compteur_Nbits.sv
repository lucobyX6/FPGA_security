`timescale 1 ns / 1 ps

module compteur_Nbits
  import ascon_pack::*;
#(
    parameter N_bits = 5
) (
    input  logic         clock_i,
    input  logic         resetb_i,
    input  logic         en_i,
    input  logic         init_i,
    output logic [N_bits : 0] data_o
);

  logic [N_bits:0] cpt_s;

  always_ff @(posedge clock_i or negedge resetb_i) begin
    if (resetb_i == 1'b0) begin
      cpt_s <= 0;
    end else begin
      if (en_i == 1'b1) begin
        if (init_i == 1'b1) begin
          cpt_s <= 0;
        end else cpt_s <= cpt_s + 1;
      end
    end
  end

  assign data_o = cpt_s;

endmodule : compteur_Nbits