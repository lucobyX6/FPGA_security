`timescale 1ns / 1ps

module ascon_fsm_tb ();
    
logic clock_w;
logic reset_w;
logic start_w;
logic [1471:0] plain_text_w;
logic [127:0] key_w;
logic [127:0] nonce_w;
logic [63:0] da_w;

logic [127:0] tag_w;
logic [1471:0] cipher_w;

assign plain_text_w = 1471'h5A_5B_5B_5A_5A_5A_5A_5A_59_55_4E_4A_4C_4F_54_55_53_51_53_54_56_57_58_57_5A_5A_59_57_56_59_5B_5A_55_54_54_52_52_50_4F_4F_4C_4C_4D_4D_4A_49_44_44_47_47_46_44_42_43_41_40_3B_36_38_3E_44_49_49_47_47_46_46_44_43_42_43_45_47_45_44_45_46_47_4A_49_47_45_48_4F_58_69_7C_92_AE_CE_ED_FF_FF_E3_B4_7C_47_16_00_04_17_29_36_3C_3F_3E_40_41_41_41_40_3F_3F_40_3F_3E_3B_3A_3B_3E_3D_3E_3C_39_3C_41_46_46_46_45_44_47_46_4A_4C_4F_4C_50_55_55_52_4F_51_55_59_5C_5A_59_5A_5C_5C_5B_59_59_57_53_51_50_4F_4F_53_57_5A_5C_5A_5B_5D_5E_60_60_61_5F_60_5F_5E_5A_58_57_54_52_52_80_00_00;
assign key_w =128'h8A_55_11_4D_1C_B6_A9_A2_BE_26_3D_4D_7A_EC_AA_FF;
assign nonce_w =128'h4E_D0_EC_0B_98_C5_29_B7_C8_CD_DF_37_BC_D0_28_4A;
assign da_w =64'h41_20_74_6F_20_42_80_00;

ascon_fsm DUT(
    .clock_i(clock_w),
    .reset_i(reset_w),
    .start_i(start_w),
    .plain_text_i(plain_text_w),
    .key_i(key_w),
    .nonce_i(nonce_w),
    .da_i(da_w),
    .tag_o(tag_w),
    .cipher_o(cipher_w)
);

initial begin
		clock_w = 1'b0;
		forever #10 clock_w = ~clock_w;
	end

initial begin
    assign reset_w = 1'b0;
    #40
    assign reset_w = 1'b1;
    assign start_w = 1'b1;
    end

endmodule