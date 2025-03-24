`timescale 1ns / 1ps

module ascon_fsm (
    input logic clock_i,
    input logic reset_i,
    input logic start_i,
    input logic [1471:0] plain_text_i,
    input logic [127:0] key_i,
    input logic [127:0] nonce_i,
    input logic [63:0] da_i,

    output logic [127:0] tag_o,
    output logic [1471:0] cipher_o,
    output logic end_ascon_o,
    
    output logic en_cipher_reg_o,
    output logic en_tag_reg_o

);

reg [1471:0] cipher_o_reg;

/* ASCON */
logic         init_w;
logic         associate_data_w;
logic         finalisation_w;
logic [63:0]  data_w;
logic         data_valid_w;

logic         end_associate_w;
logic [63:0]  cipher_w;
logic         cipher_valid_w;
logic         end_tag_w;
logic         end_initialisation_w;
logic         end_cipher_w;

/* Compteur */
logic         en_compteur_w;
logic         init_compteur_w;
logic [4:0] compteur_w;

assign end_ascon_o = end_tag_w;

ascon ASCON_0(

    .clock_i(clock_i),
    .reset_i(!reset_i),
    .init_i(init_w),
    .associate_data_i(associate_data_w),
    .finalisation_i(finalisation_w),
    .data_i(data_w),
    .data_valid_i(data_valid_w),
    .key_i(key_i),
    .nonce_i(nonce_i),
    .end_associate_o(end_associate_w),
    .cipher_o(cipher_w),
    .cipher_valid_o(cipher_valid_w),
    .tag_o(tag_o),
    .end_tag_o(end_tag_w),
    .end_initialisation_o(end_initialisation_w),
    .end_cipher_o(end_cipher_w)
);

compteur_Nbits #(.N_bits(5)) C0(
    .clock_i(clock_i),
    .resetb_i(reset_i),
    .en_i(en_compteur_w),
    .init_i(init_compteur_w),
    .data_o(compteur_w)

);

assign cipher_o = cipher_o_reg; 

typedef enum {
    idle,
    init_ascon,
    end_init_ascon,
    associated_data_init,
    associated_data_wait,
    associated_data_end,
    cipher_init,
    plain_text_set,
    cipher_data_get,
    cipher_stop,
    cipher_end,
    wait_ascon,
    end_ascon
  } state_fsm_cache;

  // Present and futur states declaration
  state_fsm_cache current_state, next_state;

  // sequential process
  always_ff @(posedge clock_i, negedge reset_i) begin
    if (reset_i == 1'b0) begin
      current_state <= idle;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin : fsm_ascon_state_choice
    case (current_state)
        idle:
            begin
                if (start_i == 1'b1) next_state = init_ascon;
                else next_state = idle;
            end

        init_ascon:
            begin
                next_state = end_init_ascon;
            end

        end_init_ascon:
            begin
                if (end_initialisation_w == 1'b1) next_state = associated_data_init;
                else next_state = end_init_ascon;
            end

        associated_data_init:
            begin
                next_state = associated_data_wait;
            end

        associated_data_wait:
            begin
                if (end_associate_w == 1'b1) next_state = associated_data_end;
                else next_state = associated_data_wait;
            end

        associated_data_end:
            begin
                next_state = cipher_init;
            end

        cipher_init:
            begin
                next_state = plain_text_set;
            end

        plain_text_set:
            begin
                if (cipher_valid_w == 1'b1) next_state = cipher_data_get;
                else next_state = plain_text_set;
            end

        cipher_data_get:
            begin
                if (end_cipher_w == 1'b1) next_state = cipher_stop;
                else next_state = cipher_data_get;
            end

        cipher_stop:
            begin
                if (compteur_w >= 5'h16) next_state = cipher_end; // On s'arrête à 22, car le dernier à lieu avec la finalisation
                else next_state = plain_text_set;
            end

        cipher_end:
            begin
                if (end_tag_w == 1'b1) next_state = wait_ascon; // On réalise la finalisation
                else next_state = cipher_end;
            end
        wait_ascon:
            begin
                next_state = end_ascon;
            end
            
        end_ascon:
            begin
                next_state = idle;
            end

        default: next_state = idle;
    endcase
  end

always_comb begin : fsm_ascon_set
    case (current_state)
        idle:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
                en_cipher_reg_o =1'b0;
                en_tag_reg_o = 1'b0;
                end_ascon_o = 1'b0;
    
                en_cipher_reg_o = 1'b0;
                en_tag_reg_o = 1'b0;
            end

        init_ascon:
            begin
                init_w = 1'b1;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
            end

        end_init_ascon:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
            end


        associated_data_init:
            begin
                init_w = 1'b1;
                associate_data_w = 1'b1;
                finalisation_w = 1'b0;
                data_w = da_i;
                data_valid_w = 1'b1;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
            end

        associated_data_wait:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = da_i;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
            end

        associated_data_end:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
            end

        cipher_init:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b1;
                init_compteur_w = 1'b1;
            end

        plain_text_set:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                case(compteur_w)
                    0: data_w = plain_text_i[1471:1408];
                    1: data_w = plain_text_i[1407:1344];
                    2: data_w = plain_text_i[1343:1280];
                    3: data_w = plain_text_i[1279:1216];
                    4: data_w = plain_text_i[1215:1152];
                    5: data_w = plain_text_i[1151:1088];
                    6: data_w = plain_text_i[1087:1024];
                    7: data_w = plain_text_i[1023:960];
                    8: data_w = plain_text_i[959:896];
                    9: data_w = plain_text_i[895:832];
                    10: data_w = plain_text_i[831:768];
                    11: data_w = plain_text_i[767:704];
                    12: data_w = plain_text_i[703:640];
                    13: data_w = plain_text_i[639:576];
                    14: data_w = plain_text_i[575:512];
                    15: data_w = plain_text_i[511:448];
                    16: data_w = plain_text_i[447:384];
                    17: data_w = plain_text_i[383:320];
                    18: data_w = plain_text_i[319:256];
                    19: data_w = plain_text_i[255:192];
                    20: data_w = plain_text_i[191:128];
                    21: data_w = plain_text_i[127:64];
                    default: data_w = 0;
                endcase     
                    
                data_valid_w = 1'b1;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
            end

        cipher_data_get:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;
                
                case (compteur_w)
                    0: cipher_o_reg[1471:1408] = cipher_w;
                    1: cipher_o_reg[1407:1344] = cipher_w;
                    2: cipher_o_reg[1343:1280] = cipher_w;
                    3: cipher_o_reg[1279:1216] = cipher_w;
                    4: cipher_o_reg[1215:1152] = cipher_w;
                    5: cipher_o_reg[1151:1088] = cipher_w;
                    6: cipher_o_reg[1087:1024] = cipher_w;
                    7: cipher_o_reg[1023:960] = cipher_w;
                    8: cipher_o_reg[959:896] = cipher_w;
                    9: cipher_o_reg[895:832] = cipher_w;
                    10: cipher_o_reg[831:768] = cipher_w;
                    11: cipher_o_reg[767:704] = cipher_w;
                    12: cipher_o_reg[703:640] = cipher_w;
                    13: cipher_o_reg[639:576] = cipher_w;
                    14: cipher_o_reg[575:512] = cipher_w;
                    15: cipher_o_reg[511:448] = cipher_w;
                    16: cipher_o_reg[447:384] = cipher_w;
                    17: cipher_o_reg[383:320] = cipher_w;
                    18: cipher_o_reg[319:256] = cipher_w;
                    19: cipher_o_reg[255:192] = cipher_w;
                    20: cipher_o_reg[191:128] = cipher_w;
                    21: cipher_o_reg[127:64] = cipher_w;
                    default: cipher_o_reg[63:0] = 0;
                endcase  

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
            end

        cipher_stop:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b1;
                init_compteur_w = 1'b0;
            end

        cipher_end:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b1;
                data_w = plain_text_i[63:0];
                data_valid_w = 1'b1;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
                cipher_o_reg[63:0] = cipher_w;
                en_cipher_reg_o = 1'b1;
            end
        wait_ascon:
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;
                en_tag_reg_o = 1'b1;
            end
            
        end_ascon: 
        begin
            init_w = 1'b0;
            associate_data_w = 1'b0;
            finalisation_w = 1'b0;
            data_w = 0;
            data_valid_w = 1'b0;

            en_compteur_w = 1'b0;
            init_compteur_w = 1'b0;
        end

        default: 
            begin
                init_w = 1'b0;
                associate_data_w = 1'b0;
                finalisation_w = 1'b0;
                data_w = 0;
                data_valid_w = 1'b0;

                en_compteur_w = 1'b0;
                init_compteur_w = 1'b0;  
            end
    endcase
end




endmodule : ascon_fsm