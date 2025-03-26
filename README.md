# FPGA_security

_Abstract : FPGA project on Xilinx Pynq Z2. This project encrypt a communication with a FPGA and ASCON 128 (new lightweight encryption standard) and display the result with man-machine interface._

**Problematic :** Medical data need to be protect, in accord with european law : GDPR. To protect the transfer in real time, we need to use onboard encryption.  

**Goal :**  Encrypt an ecg communatication between a sensor and a display, with a Pynq-Z2 FPGA. 

## Tree structure

> **0_Documentation** : Doc, like presentation or quickstart \
> **1_Source_Files** : Files from Vivado \
> **2_Python_Files** : Files of class and to execute the project \
> **3_Data** : Waveforms

## Prerequisites

### Software required

```console 
user:~$ pip install tk
```

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