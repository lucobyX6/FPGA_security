`timescale 1ns / 1ps

module ascon_fsm (
    input clock_i,
    input reset_i,
    input start_i,
    input [1447:0] plain_text_i,
    input [127:0] key_i,
    input [127:0] nonce_i,
    input [63:0] da_i,

    output [127:0] tag_o,
    output [1447:0] cipher_o

);

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
logic [22 : 0] compteur_w;


ascon ASCON_0(

    .clock_i(clock_i),
    .reset_i(reset_i),
    .init_i(start_i),
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

typedef enum {
    idle,
    init_ascon,
    end_init_ascon,
    associated_data_init,
    associated_data_set,
    associated_data_end,
    cipher_init,
    plain_text_set,
    cipher_data_get,
    cipher_stop,
    cipher_end,
    end_ascon
  } state_fsm_cache;

  // Present and futur states declaration
  state_fsm_cache current_state, next_state;

  // sequential process
  always_ff @(posedge clock_i, posedge reset_i) begin
    if (reset_i == 1'b0) begin
      current_state <= idle;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin : fsm_cache_state_choice
    case (current_state)
        idle:
            begin
                if (start_i == 1'b1) next_state = init_ascon;
                else next_state = idle;
            end

        init_ascon:
            begin
                if (end_initialisation_w == 1'b1) next_state = end_init_ascon;
                else next_state = init_ascon;
            end

        end_init_ascon:
            begin
                next_state = associated_data_init;
            end


        associated_data_init:
            begin
                next_state = associated_data_set;
            end

        associated_data_set:
            begin
                if (end_associate_w == 1'b1) next_state = associated_data_end;
                else next_state = associated_data_set;
            end

        associated_data_end:
            begin
                next_state = cipher_init;
            end

        cipher_init:
            begin
                next_state = cipher_init;
            end

        plain_text_set:
            begin
                if (cipher_valid_w == 1'b1) next_state = cipher_data_get;
                else next_state = plain_text_set;
            end

        cipher_data_get:
            begin
                if (end_cipher_w == 1'b1) next_state = cipher_stop;
                else next_state = plain_text_set;
            end

        cipher_stop:
            begin
                if (compteur_w == 22) next_state = cipher_end; // On s'arrête à 22, car le dernier à lieu avec la finalisation
                else next_state = cipher_init;
            end

        cipher_end:
            begin
                if (end_tag_w == 1'b1) next_state = end_ascon; // On réalise la finalisation
                else next_state = cipher_end;
            end
        end_ascon:
            begin
                next_state = idle;
            end

        default: next_state = idle;
    endcase
  end

always_comb begin : fsm_cache_date
    case (current_state)
        idle:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
                assign compteur_w = 1'b0;
            end

        init_ascon:
            begin
                assign init_w = 1'b1;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
                assign compteur_w = 1'b0;
            end

        end_init_ascon:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
                assign compteur_w = 1'b0;
            end


        associated_data_init:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b1;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
                assign compteur_w = 1'b0;
            end

        associated_data_set:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b1;
                assign finalisation_w = 1'b0;
                assign data_w = da_i;
                assign data_valid_w = 1'b1;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
                assign compteur_w = 1'b0;
            end

        associated_data_end:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
                assign compteur_w = 1'b0;
            end

        cipher_init:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b1;
                assign compteur_w = 1'b1;
            end

        plain_text_set:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                case(compteur_w)
                    0: assign data_w = plain_text_i[63:0];    
                    1: assign data_w = plain_text_i[64+63:64];    
                    2: assign data_w = plain_text_i[2*64+63:2*64];  
                    3: assign data_w = plain_text_i[3*64+63:3*64]; 
                    4: assign data_w = plain_text_i[4*64+63:4*64];   
                    5: assign data_w = plain_text_i[5*64+63:5*64];  
                    6: assign data_w = plain_text_i[6*64+63:6*64];  
                    7: assign data_w = plain_text_i[7*64+63:7*64];  
                    8: assign data_w = plain_text_i[8*64+63:8*64];  
                    9: assign data_w = plain_text_i[9*64+63:9*64];  
                    10: assign data_w = plain_text_i[10*64+63:10*64];
                    11: assign data_w = plain_text_i[11*64+63:11*64];
                    12: assign data_w = plain_text_i[12*64+63:12*64];
                    13: assign data_w = plain_text_i[13*64+63:13*64];
                    14: assign data_w = plain_text_i[14*64+63:14*64];
                    15: assign data_w = plain_text_i[15*64+63:15*64];
                    16: assign data_w = plain_text_i[16*64+63:16*64];
                    17: assign data_w = plain_text_i[17*64+63:17*64];
                    18: assign data_w = plain_text_i[18*64+63:18*64];
                    19: assign data_w = plain_text_i[19*64+63:19*64];
                    20: assign data_w = plain_text_i[20*64+63:20*64];
                    21: assign data_w = plain_text_i[21*64+63:21*64];
                    22: assign data_w = plain_text_i[22*64+63:22*64];
                endcase     
                    
                assign data_valid_w = 1'b1;

                assign en_compteur_w = 1'b1;
                assign init_compteur_w = 1'b0;
            end

        cipher_data_get:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
            end

        cipher_stop:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
            end

        cipher_end:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b1;
                assign data_w = plain_text_i[23*64+63:64*(23-1)];
                assign data_valid_w = 1'b1;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
            end
        end_ascon:
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;
            end


        default: 
            begin
                assign init_w = 1'b0;
                assign associate_data_w = 1'b0;
                assign finalisation_w = 1'b0;
                assign data_w = 0;
                assign data_valid_w = 1'b0;

                assign en_compteur_w = 1'b0;
                assign init_compteur_w = 1'b0;  
            end
    endcase
end




endmodule : ascon_fsm