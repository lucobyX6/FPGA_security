**File :** ascon_pcsn.py \
*Weight : 15ko | Type : .py*
> Functions for ASCON decipher

**File :** display_main.py \
*Weight : 5ko | Type : .py*
> File to execute

**File :** fpga_communication.py \
*Weight : 9ko | Type : .py*
> Class for FPGA communication and result interpretation

# ascon_pcsn.py

This Python module provides a function `ascon_decrypt`, for decrypt the wave encrypt. 

# display_main.py

This Python script provides a graphical user interface (GUI) for communicating with an FPGA (Field-Programmable Gate Array) using the `fpga_communication` class. The GUI is built using the `tkinter` library and allows users to select COM ports, input CSV files, associated data, keys, and nonces, and visualize ECG waveforms.

## Features
- Choose the avaible COM port in the list.
- Connect the FPGA trough this port.
- Text zone for `csv` files, associated data, key and nonce.
- Increment or decrement the wave index to visualize different ECG waveforms.
- Display ciphertext and tags.
- Close the communication with the FPGA.

## Librairies

- `import tkinter as tk`
- `import serial`
- `import numpy as np`
- `import fpga_communication as fp`

## Usage

1. Run the script to open the GUI.
2. Select an available COM port and click "Validate COM" to connect to the FPGA.
3. Input the name of the CSV file and click "Validate CSV".
4. Input the associated data, key, and nonce, and click the respective "Validate" buttons.
5. Use the "+1" and "-1" buttons to increment or decrement the wave index and visualize the ECG waveform.
6. Click "Close COM" to close the communication with the FPGA.

# fpga_communication.py

This Python module provides a class `fpga_communication` for communicating with the Pynq-Z2 FPGA (Field-Programmable Gate Array) using UART protocol.

## Summary

- Initialize/close the communication with the FPGA.
- Send waveformes, key, associated data and none.
- Read `csv` to get waveform.
- Start the ASCON encryption.
- Read ciphertext and tag from the FPGA.
- Decrypt ciphertext using the Ascon encryption algorithm.
- Display a man-machine interface
- Visualize ECG data using matplotlib.

## Librairies

- `import serial`
- `from datetime import datetime`
- `import pandas as pd`
- `import numpy as np`
- `import matplotlib.pyplot as plt`
- `import ascon_pcsn as ap` (other class from the repository)

## Class: `fpga_communication`

### Functions

#### Initialization

- `__init__(self, baud_rate)`: Initialize the communication with the specified baud rate.
- `get_port(self, port)`: Set the communication port.
- `open_instrument(self)`: Open the serial communication with the FPGA and create a log file.

#### Data Handling

- `open_csv(self, name: str)`: Open a CSV file and set the index to 0.
- `fifo_ecg_plus(self)`: Return the next ECG line and increment the index.
- `fifo_ecg_sub(self)`: Return the previous ECG line and decrement the index.
- `current_index(self)`: Get the current index.
- `hex_convertor(self, txt: str)`: Convert a string to hexadecimal format.

#### FPGA Communication

- `set_key(self, key: str)`: Set the Ascon key on the FPGA.
- `set_da(self, da: str)`: Set the associated data on the FPGA.
- `set_nonce(self, nonce: str)`: Set the nonce on the FPGA.
- `set_wave(self, wave: str)`: Send the waveform to the FPGA.
- `start_ascon(self)`: Start the Ascon encryption process on the FPGA.
- `read_cipher(self)`: Read the ciphertext from the FPGA.
- `read_tag(self)`: Read the tag from the FPGA.
- `decrypt_cipher(self)`: Decrypt the ciphertext using the Ascon algorithm.

#### Visualization

- `display_ecg(self, list)`: Display the ECG waveform using matplotlib.

#### Cleanup

- `close_instrument(self)`: Close the serial communication and log file.

## Usage

```python
# Example usage
fpga = fpga_communication(baud_rate=9600)
fpga.get_port('COM3')
fpga.open_instrument()

# Set key, associated data, nonce, and waveform
fpga.set_key('your_key_here')
fpga.set_da('your_da_here')
fpga.set_nonce('your_nonce_here')
fpga.set_wave('your_wave_here')

# Start Ascon encryption
fpga.start_ascon()

# Read ciphertext and tag
cipher = fpga.read_cipher()
tag = fpga.read_tag()
print(cipher)
print(tag)

# Decrypt ciphertext
plain_text = fpga.decrypt_cipher()
print(plain_text)

# Display ECG waveform
fpga.display_ecg(your_ecg_list)

# Close the communication
fpga.close_instrument()