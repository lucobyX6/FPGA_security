****Python Communication UART****

**Librairies**

-> **serial** and **serial.tools.list_ports** : Used for communication with the ports

-> **datetime** : Used to calculate the fix the date in the log file

**Class FPGA**

FPGA class has all the functions and variables to start a communication with the PYNQ card. 

Initialisation of class named FPGA with parameters :

      -> port : to define the connected port on the compute
      
      -> baud_rate : to determine the communication baud rate
      
      -> timeout : amount of time before shutting down if no answer

The functions :

      -> open_instrument() : Open communication with FPGA
      
      -> close_instrument() : Close the FPGA communication
      
      -> set_memory_adrr() : Set memory address
      
      -> write_val_mem(message:str)* : Write value into target memory space
      
      -> display_mem_vals_leds() : Display the values in target memory space on the LEDs
      
      -> read_mem_val() : Read memory value

