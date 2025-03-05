# FPGA_security
_Abstract : FPGA project on Xilinx Pynq Z2. The goal is to encrypt a communication between a captor and a display, with a FPGA. The encryption is based on ASCON, the new new lightweight encryption standard._

**Entry :** One ECG of 161 samples (1 octet per samples)
--> UART

**Encryption :** FPGA + ASCON
--> UART

**Display :** Python display

**Python Communication UART** 
initialisation of class named FPGA with parameters :
      > *port* : to define the connected port on the compute
      > *baud_rate* : to determine the communication baud rate
      > *timeout* : amount of time before shutting down if no answer

The functions :
      > *open_instrument()* : Open communication with FPGA
      > *close_instrument()* : Close the FPGA communication
      > *set_memory_adrr()* : Set memory address
      > *write_val_mem()* : Write value into target memory space
      > *display_mem_vals_leds()* : Display the values in target memory space on the LEDs
      > *read_mem_val()* : Read memory value
      
