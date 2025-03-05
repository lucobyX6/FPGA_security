# FPGA_security
_Abstract : FPGA project on Xilinx Pynq Z2. The goal is to encrypt a communication between a captor and a display, with a FPGA. The encryption is based on ASCON, the new new lightweight encryption standard._

**Entry :** One ECG of 181 samples (1 octet per samples) --> UART

**Encryption :** UART --> FPGA + ASCON --> UART

**Display :** UART --> Python display

**Data :** 
- words of 64 bits (23 morceaux, il y aura du padding)
- key of 128 bits
- nonce of 128 bits


https://ascon.isec.tugraz.at/specification.html