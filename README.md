# FPGA_security

_Abstract : FPGA project on Xilinx Pynq Z2. This project encrypt a communication with a FPGA and ASCON 128 (new lightweight encryption standard) and display the result with man-machine interface._

**Problematic :** Medical data need to be protect, in accord with european law : GDPR. To protect the transfer in real time, we need to use onboard encryption.  

**Goal :**  Encrypt an ecg communatication between a sensor and a display, with a Pynq-Z2 FPGA. 

## Tree structure

> 0_Documentation
> 1_Source_Files
> 2_Python_Files
> 3_Data



## Prerequisites

### software required

### Librairies required

### Hardware required





**Entry :** One ECG of 181 samples (1 octet per samples) --> UART

**Encryption :** UART --> FPGA + ASCON --> UART

**Display :** UART --> Python display

**Data :** 
- words of 64 bits (23 morceaux, il y aura du padding)
- key of 128 bits
- nonce of 128 bits





https://ascon.isec.tugraz.at/specification.html


Prérequis 

Logiciel nécessaire


Comment exécuter 


Affichage 

Référence