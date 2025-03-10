`timescale 1ns / 1ps

module UART_register (
    input logic clock_i,
    input logic reset_i,
    input logic we_i,
    input logic re_i,

    input logic [127:0] tag_i,
    input logic [1472:0] cipher_i,

    input logic shift_i,
    input logic select_i,

    output logic tag_end_o,
    output logic cipher_end_o,

    output logic [127:0] tag_o,
    output logic [1472:0] cipher_o

);

/* Compteur */
logic         en_compteur_w;
logic         init_compteur_w;
logic [4:0] compteur_w;

logic [127:0] tag_reg;
logic [1472:0] cipher_reg;

compteur_Nbits #(.N_bits(8)) counter(
    .clock_i(clock_i),
    .resetb_i(reset_i),
    .en_i(en_compteur_w),
    .init_i(init_compteur_w),
    .data_o(compteur_w)

);

assign resetb_i = !reset_i; 

typedef enum {
    idle,
    write_state,
    read_state,
    cipher_transmit,
    tag_transmit,
    counter_shift_cipher,
    counter_shift_tag,
    end_cipher_transmit,
    end_tag_transmit
  } state_fsm_cache;

state_fsm_cache current_state, next_state;

always_ff @(posedge clock_i, posedge reset_i) begin
    if (reset_i == 1'b0) begin
      current_state <= idle;
      assign tag_reg=0;
      assign cipher_reg =0;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin : fsm_register_state_choice
    case (current_state)
        idle:
        begin
          if(we_i == 1'b1) next_state = write_state;
          else if (re_i == 1'b1) next_state = read_state;
          else next_state = idle;
        end

        write_state:
        begin
          next_state = idle;
        end

        read_state:
        begin
          if(select_i == 1'b0) next_state = cipher_transmit;
          else if (select_i == 1'b1) next_state = tag_transmit;
          else next_state = read_state;
        end

        cipher_transmit:
        begin
          if(shift_i == 1'b1) next_state = counter_shift_cipher;
          else next_state = cipher_transmit;
        end

        tag_transmit:
        begin
          if(shift_i == 1'b1) next_state = counter_shift_tag;
          else next_state = tag_transmit;
        end

        counter_shift_cipher:
        begin
          if(compteur_w == 182) next_state = idle;
          else next_state = cipher_transmit;
        end

        end_cipher_transmit:
        begin
          next_state = idle;
        end

        counter_shift_tag:
        begin
          if(compteur_w == 15) next_state = end_tag_transmit;
          else next_state = tag_transmit;
        end

        end_tag_transmit:
        begin
          next_state = idle;
        end

        default: next_state = idle;
    endcase
  end

always_comb begin : fsm_register_date
    case (current_state)
        idle:
        begin
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b0;
          assign tag_o = 0;
          assign cipher_o = 0;

          assign en_compteur_w =1'b0;
          assign init_compteur_w = 1'b0;

          //assign tag_reg;
          //assign cipher_reg;

        end

        write_state:
        begin
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b0;
          assign tag_o = 0;
          assign cipher_o = 0;

          assign en_compteur_w =1'b0;
          assign init_compteur_w = 1'b0;

          assign tag_reg =tag_i;
          assign cipher_reg =cipher_reg;
        end

        read_state:
        begin
          
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b0;
          assign tag_o = 0;
          assign cipher_o = 0;

          assign en_compteur_w =1'b1;
          assign init_compteur_w = 1'b1;

          //assign tag_reg;
          //assign cipher_reg;
        end

        cipher_transmit:
        begin
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b0;
          assign tag_o = 0;

          case(compteur_w)
            0: assign cipher_o = cipher_reg[7:0];
            1: assign cipher_o = cipher_reg[8+7:8];
            2: assign cipher_o = cipher_reg[16+7:16];
            3: assign cipher_o = cipher_reg[24+7:24];
            4: assign cipher_o = cipher_reg[32+7:32];
            5: assign cipher_o = cipher_reg[40+7:40];
            6: assign cipher_o = cipher_reg[48+7:48];
            7: assign cipher_o = cipher_reg[56+7:56];
            8: assign cipher_o = cipher_reg[64+7:64];
            9: assign cipher_o = cipher_reg[72+7:72];
            10: assign cipher_o = cipher_reg[80+7:80];
            11: assign cipher_o = cipher_reg[88+7:88];
            12: assign cipher_o = cipher_reg[96+7:96];
            13: assign cipher_o = cipher_reg[104+7:104];
            14: assign cipher_o = cipher_reg[112+7:112];
            15: assign cipher_o = cipher_reg[120+7:120];
            16: assign cipher_o = cipher_reg[128+7:128];
            17: assign cipher_o = cipher_reg[136+7:136];
            18: assign cipher_o = cipher_reg[144+7:144];
            19: assign cipher_o = cipher_reg[152+7:152];
            20: assign cipher_o = cipher_reg[160+7:160];
            21: assign cipher_o = cipher_reg[168+7:168];
            22: assign cipher_o = cipher_reg[176+7:176];
            23: assign cipher_o = cipher_reg[184+7:184];
            24: assign cipher_o = cipher_reg[192+7:192];
            25: assign cipher_o = cipher_reg[200+7:200];
            26: assign cipher_o = cipher_reg[208+7:208];
            27: assign cipher_o = cipher_reg[216+7:216];
            28: assign cipher_o = cipher_reg[224+7:224];
            29: assign cipher_o = cipher_reg[232+7:232];
            30: assign cipher_o = cipher_reg[240+7:240];
            31: assign cipher_o = cipher_reg[248+7:248];
            32: assign cipher_o = cipher_reg[256+7:256];
            33: assign cipher_o = cipher_reg[264+7:264];
            34: assign cipher_o = cipher_reg[272+7:272];
            35: assign cipher_o = cipher_reg[280+7:280];
            36: assign cipher_o = cipher_reg[288+7:288];
            37: assign cipher_o = cipher_reg[296+7:296];
            38: assign cipher_o = cipher_reg[304+7:304];
            39: assign cipher_o = cipher_reg[312+7:312];
            40: assign cipher_o = cipher_reg[320+7:320];
            41: assign cipher_o = cipher_reg[328+7:328];
            42: assign cipher_o = cipher_reg[336+7:336];
            43: assign cipher_o = cipher_reg[344+7:344];
            44: assign cipher_o = cipher_reg[352+7:352];
            45: assign cipher_o = cipher_reg[360+7:360];
            46: assign cipher_o = cipher_reg[368+7:368];
            47: assign cipher_o = cipher_reg[376+7:376];
            48: assign cipher_o = cipher_reg[384+7:384];
            49: assign cipher_o = cipher_reg[392+7:392];
            50: assign cipher_o = cipher_reg[400+7:400];
            51: assign cipher_o = cipher_reg[408+7:408];
            52: assign cipher_o = cipher_reg[416+7:416];
            53: assign cipher_o = cipher_reg[424+7:424];
            54: assign cipher_o = cipher_reg[432+7:432];
            55: assign cipher_o = cipher_reg[440+7:440];
            56: assign cipher_o = cipher_reg[448+7:448];
            57: assign cipher_o = cipher_reg[456+7:456];
            58: assign cipher_o = cipher_reg[464+7:464];
            59: assign cipher_o = cipher_reg[472+7:472];
            60: assign cipher_o = cipher_reg[480+7:480];
            61: assign cipher_o = cipher_reg[488+7:488];
            62: assign cipher_o = cipher_reg[496+7:496];
            63: assign cipher_o = cipher_reg[504+7:504];
            64: assign cipher_o = cipher_reg[512+7:512];
            65: assign cipher_o = cipher_reg[520+7:520];
            66: assign cipher_o = cipher_reg[528+7:528];
            67: assign cipher_o = cipher_reg[536+7:536];
            68: assign cipher_o = cipher_reg[544+7:544];
            69: assign cipher_o = cipher_reg[552+7:552];
            70: assign cipher_o = cipher_reg[560+7:560];
            71: assign cipher_o = cipher_reg[568+7:568];
            72: assign cipher_o = cipher_reg[576+7:576];
            73: assign cipher_o = cipher_reg[584+7:584];
            74: assign cipher_o = cipher_reg[592+7:592];
            75: assign cipher_o = cipher_reg[600+7:600];
            76: assign cipher_o = cipher_reg[608+7:608];
            77: assign cipher_o = cipher_reg[616+7:616];
            78: assign cipher_o = cipher_reg[624+7:624];
            79: assign cipher_o = cipher_reg[632+7:632];
            80: assign cipher_o = cipher_reg[640+7:640];
            81: assign cipher_o = cipher_reg[648+7:648];
            82: assign cipher_o = cipher_reg[656+7:656];
            83: assign cipher_o = cipher_reg[664+7:664];
            84: assign cipher_o = cipher_reg[672+7:672];
            85: assign cipher_o = cipher_reg[680+7:680];
            86: assign cipher_o = cipher_reg[688+7:688];
            87: assign cipher_o = cipher_reg[696+7:696];
            88: assign cipher_o = cipher_reg[704+7:704];
            89: assign cipher_o = cipher_reg[712+7:712];
            90: assign cipher_o = cipher_reg[720+7:720];
            91: assign cipher_o = cipher_reg[728+7:728];
            92: assign cipher_o = cipher_reg[736+7:736];
            93: assign cipher_o = cipher_reg[744+7:744];
            94: assign cipher_o = cipher_reg[752+7:752];
            95: assign cipher_o = cipher_reg[760+7:760];
            96: assign cipher_o = cipher_reg[768+7:768];
            97: assign cipher_o = cipher_reg[776+7:776];
            98: assign cipher_o = cipher_reg[784+7:784];
            99: assign cipher_o = cipher_reg[792+7:792];
            100: assign cipher_o = cipher_reg[800+7:800];
            101: assign cipher_o = cipher_reg[808+7:808];
            102: assign cipher_o = cipher_reg[816+7:816];
            103: assign cipher_o = cipher_reg[824+7:824];
            104: assign cipher_o = cipher_reg[832+7:832];
            105: assign cipher_o = cipher_reg[840+7:840];
            106: assign cipher_o = cipher_reg[848+7:848];
            107: assign cipher_o = cipher_reg[856+7:856];
            108: assign cipher_o = cipher_reg[864+7:864];
            109: assign cipher_o = cipher_reg[872+7:872];
            110: assign cipher_o = cipher_reg[880+7:880];
            111: assign cipher_o = cipher_reg[888+7:888];
            112: assign cipher_o = cipher_reg[896+7:896];
            113: assign cipher_o = cipher_reg[904+7:904];
            114: assign cipher_o = cipher_reg[912+7:912];
            115: assign cipher_o = cipher_reg[920+7:920];
            116: assign cipher_o = cipher_reg[928+7:928];
            117: assign cipher_o = cipher_reg[936+7:936];
            118: assign cipher_o = cipher_reg[944+7:944];
            119: assign cipher_o = cipher_reg[952+7:952];
            120: assign cipher_o = cipher_reg[960+7:960];
            121: assign cipher_o = cipher_reg[968+7:968];
            122: assign cipher_o = cipher_reg[976+7:976];
            123: assign cipher_o = cipher_reg[984+7:984];
            124: assign cipher_o = cipher_reg[992+7:992];
            125: assign cipher_o = cipher_reg[1000+7:1000];
            126: assign cipher_o = cipher_reg[1008+7:1008];
            127: assign cipher_o = cipher_reg[1016+7:1016];
            128: assign cipher_o = cipher_reg[1024+7:1024];
            129: assign cipher_o = cipher_reg[1032+7:1032];
            130: assign cipher_o = cipher_reg[1040+7:1040];
            131: assign cipher_o = cipher_reg[1048+7:1048];
            132: assign cipher_o = cipher_reg[1056+7:1056];
            133: assign cipher_o = cipher_reg[1064+7:1064];
            134: assign cipher_o = cipher_reg[1072+7:1072];
            135: assign cipher_o = cipher_reg[1080+7:1080];
            136: assign cipher_o = cipher_reg[1088+7:1088];
            137: assign cipher_o = cipher_reg[1096+7:1096];
            138: assign cipher_o = cipher_reg[1104+7:1104];
            139: assign cipher_o = cipher_reg[1112+7:1112];
            140: assign cipher_o = cipher_reg[1120+7:1120];
            141: assign cipher_o = cipher_reg[1128+7:1128];
            142: assign cipher_o = cipher_reg[1136+7:1136];
            143: assign cipher_o = cipher_reg[1144+7:1144];
            144: assign cipher_o = cipher_reg[1152+7:1152];
            145: assign cipher_o = cipher_reg[1160+7:1160];
            146: assign cipher_o = cipher_reg[1168+7:1168];
            147: assign cipher_o = cipher_reg[1176+7:1176];
            148: assign cipher_o = cipher_reg[1184+7:1184];
            149: assign cipher_o = cipher_reg[1192+7:1192];
            150: assign cipher_o = cipher_reg[1200+7:1200];
            151: assign cipher_o = cipher_reg[1208+7:1208];
            152: assign cipher_o = cipher_reg[1216+7:1216];
            153: assign cipher_o = cipher_reg[1224+7:1224];
            154: assign cipher_o = cipher_reg[1232+7:1232];
            155: assign cipher_o = cipher_reg[1240+7:1240];
            156: assign cipher_o = cipher_reg[1248+7:1248];
            157: assign cipher_o = cipher_reg[1256+7:1256];
            158: assign cipher_o = cipher_reg[1264+7:1264];
            159: assign cipher_o = cipher_reg[1272+7:1272];
            160: assign cipher_o = cipher_reg[1280+7:1280];
            161: assign cipher_o = cipher_reg[1288+7:1288];
            162: assign cipher_o = cipher_reg[1296+7:1296];
            163: assign cipher_o = cipher_reg[1304+7:1304];
            164: assign cipher_o = cipher_reg[1312+7:1312];
            165: assign cipher_o = cipher_reg[1320+7:1320];
            166: assign cipher_o = cipher_reg[1328+7:1328];
            167: assign cipher_o = cipher_reg[1336+7:1336];
            168: assign cipher_o = cipher_reg[1344+7:1344];
            169: assign cipher_o = cipher_reg[1352+7:1352];
            170: assign cipher_o = cipher_reg[1360+7:1360];
            171: assign cipher_o = cipher_reg[1368+7:1368];
            172: assign cipher_o = cipher_reg[1376+7:1376];
            173: assign cipher_o = cipher_reg[1384+7:1384];
            174: assign cipher_o = cipher_reg[1392+7:1392];
            175: assign cipher_o = cipher_reg[1400+7:1400];
            176: assign cipher_o = cipher_reg[1408+7:1408];
            177: assign cipher_o = cipher_reg[1416+7:1416];
            178: assign cipher_o = cipher_reg[1424+7:1424];
            179: assign cipher_o = cipher_reg[1432+7:1432];
            180: assign cipher_o = cipher_reg[1440+7:1440];
            181: assign cipher_o = cipher_reg[1448+7:1448];
            182: assign cipher_o = cipher_reg[1456+7:1456];
        endcase

          assign en_compteur_w =1'b0;
          assign init_compteur_w = 1'b0;
        end

        tag_transmit:
        begin
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b0;
          assign cipher_o = 0;
          
          case(compteur_w)
            0: assign tag_o = tag_reg[7:0];
            1: assign tag_o = tag_reg[8+7:8];
            2: assign tag_o = tag_reg[16+7:16];
            3: assign tag_o = tag_reg[24+7:24];
            4: assign tag_o = tag_reg[32+7:32];
            5: assign tag_o = tag_reg[40+7:40];
            6: assign tag_o = tag_reg[48+7:48];
            7: assign tag_o = tag_reg[56+7:56];
            8: assign tag_o = tag_reg[64+7:64];
            9: assign tag_o = tag_reg[72+7:72];
            10: assign tag_o = tag_reg[80+7:80];
            11: assign tag_o = tag_reg[88+7:88];
            12: assign tag_o = tag_reg[96+7:96];
            13: assign tag_o = tag_reg[104+7:104];
            14: assign tag_o = tag_reg[112+7:112];
            15: assign tag_o = tag_reg[120+7:120];
          endcase

          assign en_compteur_w =1'b0;
          assign init_compteur_w = 1'b0;
        end

        counter_shift_cipher:
        begin
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b0;
          assign tag_o = 0;
          assign cipher_o = 0;

          assign en_compteur_w =1'b1;
          assign init_compteur_w = 1'b0;

          //assign tag_reg;
          //assign cipher_reg;
        end

        end_cipher_transmit:
        begin
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b1;
          assign tag_o = 0;
          assign cipher_o = 0;

          assign en_compteur_w =1'b0;
          assign init_compteur_w = 1'b0;

          //assign tag_reg;
          //assign cipher_reg;
        end

        counter_shift_tag:
        begin
          assign tag_end_o = 1'b0;
          assign cipher_end_o = 1'b0;
          assign tag_o = 0;
          assign cipher_o = 0;

          assign en_compteur_w =1'b1;
          assign init_compteur_w = 1'b0;

          //assign tag_reg;
          //assign cipher_reg;
        end

        end_tag_transmit:
        begin
          assign tag_end_o = 1'b1;
          assign cipher_end_o = 1'b0;
          assign tag_o = 0;
          assign cipher_o = 0;

          assign en_compteur_w =1'b0;
          assign init_compteur_w = 1'b0;

          //assign tag_reg;
          //assign cipher_reg;
        end


        default: 
            begin
            end
    endcase
end

endmodule : UART_register