`timescale 1ns / 1ps

module ascon_fsm_tb ();
    


initial begin
		clock_i_s = 1'b0;
		forever #10 clock_i_s = ~clock_i_s;
	end

	initial begin
        // idle

        // init_ascon

        // end_init_ascon

        // associated_data_init

        // associated_data_set

        // associated_data_end

        // cipher_init

        // plain_text_set

        // cipher_data_get

        // cipher_stop

        // cipher_end

        // tag_init

        // tag_end

        // end_ascon
        

    end

endmodule