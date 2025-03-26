# FPGA_security

_Abstract : FPGA project on Xilinx Pynq Z2. This project encrypt a communication with a FPGA and ASCON 128 (new lightweight encryption standard) and display the result with man-machine interface._

**Problematic :** Medical data need to be protect, in accord with european law : GDPR. To protect the transfer in real time, we need to use onboard encryption.  

**Goal :**  Encrypt an ecg communatication between a sensor and a display, with a Pynq-Z2 FPGA. 

## Tree structure

> **1_Source_Files** : Files from Vivado \
> **2_Python_Files** : Files of class and to execute the project \
> **3_Data** : Waveforms

## Prerequisites

### Software required
**Python** is required. To install it, click on this link : https://www.python.org/downloads/

**Pip** is required. To install it, follow this tutorial : https://www.geeksforgeeks.org/how-to-install-pip-onwindows 

**Vivado** is required. To install it, lick on this link : https://www.xilinx.com/support/download.html 

### Librairies required

**tkinter** is required. To install it, type the following command :  
```console 
user:~$ pip install tk
```

**pyserial** is required. To install it, type the following command :  
```console 
user:~$ pip install pyserial
```

**numpy** is required. To install it, type the following command :  
```console 
user:~$ pip install numpy
```

**pandas** is required. To install it, type the following command :  
```console 
user:~$ pip install pandas
```

**matplotlib.pyplot** is required. To install it, type the following command :  
```console 
user:~$ pip install matplotlib
```


### Hardware required
A **Pynq - Z2 FPGA card** is required. You can buy it with this link :  https://www.amd.com/en/corporate/university-program/aupboards/pynq-z2.html 
A **Pmod A UART** is required. You can buy it with this link : https://digilent.com/reference/pmod/pmodusbuart/start
**Two Micro B USB** are required. 

## How to use it

**Preparation of the Pynq Z2 Board**

1. **Power Supply**: Connect the first cable to the Pynq Z2 board and the computer to power the FPGA.
2. **Power Switch**: Turn on the power switch. Several red LEDs should light up.
3. **UART Connection**: Connect the second cable to the Pmod UART.
4. **Pmod UART Setup**: Connect the Pmod UART to the Pynq Z2 board following these guidelines:
   - The Pmod should be on position A and connected to the top six pins.
   - The LED and jumper should be facing upwards.
   - The Dupont connectors should be fully inserted.
5. **Vivado Application**: Open the Vivado application and in the Tasks section, open the Hardware Manager.
6. **Device Programming**: Click on "Open target," then "Auto Connect," and finally "Program Device."
7. **Bitstream File**: Select the bitstream file: `top_level_fpga.bit`.
8. **Board Ready**: The board is now ready for use.

**Python files**

9. **Run Python Script**: Navigate to the directory and execute the following command:
   ```sh
   user:~\$ python3 display_main.py
   ```
10. **GUI Window**: A window named "FPGA Security - ECG Display" should open.
11. **Encryption and Decryption** : To start the encryption and decryption process, follow these steps:
    - Select the COM port corresponding to the Pmod UART from the dropdown list (use Device Manager if needed)and click "Validate COM."
    - Enter the relative path of your CSV file (including folder names and `./`) and click "Validate CSV."
    - Enter the associated data and click "Validate AD."
    - Enter the key and click "Validate key."
    - Enter the nonce and click "Validate nonce."
    - Use the "+1" and "-1" buttons to navigate through the database. The cipher and tag will be displayed below.
    - Remember to close the port with "Close PORT" after finishing your operations.
12. **Graphs**: Graphs should appear with each click on "+1" or "-1."
13. **Usage**: You can now use our project.


# References

[1] ASCON documentation : https://ascon.isec.tugraz.at/specification.html

[2] Pynq Z2 documenation : https://dpoauwgwqsy2x.cloudfront.net/Download/PYNQ_Z2_User_Manual_v1.1.pdf 

# Authors

EMSE - ISMIN Student : Lucas VINCENT
EMSE - ISMIN Student : Mathieu MORUCCI

*Thanks to : Jean-Baptiste RIGAUD and Olivier POTIN, for the codes and debug.*