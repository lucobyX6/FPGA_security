import serial
import serial.tools.list_ports
from datetime import datetime

import pandas as pd
import numpy as np
import ascon_pcsn as ap

import matplotlib.pyplot as plt

class fpga_communication:
        def __init__(self, baud_rate):
            self.baud_rate = baud_rate
            self.da = None 
            self.key = None
            self.nonce = None
            self.wave = None

        def get_port(self, port):
            self.port = port
        
        def open_instrument(self):
            """ 
            Inputs : None

            Outputs : None
            
            Initiates communication with the FPGA using a UART protocol.
            + Creates the log file
            
            """
            self.ser = serial.Serial(self.port, self.baud_rate, timeout=1)
            self.log = open("log_fpga_communication.txt","a+")
            current_time = datetime.now()
            self.log.write(f"[INFO] - - - {current_time} - - - \n")
            self.log.write(f"[INFO] FPGA initialized on port {self.port}, baud rate: {self.baud_rate}\n")
        
        # To FPGA
        def open_csv(self, name : str):
            """ 
            Inputs : name (str)

            Outputs : None
            
            Open csv and set index to 0
            
            """
            data = pd.read_csv(name, header=None)
            self.data_array = np.array(data)
            self.i=0

        def fifo_ecg_plus(self):
            """ 
            Inputs : None

            Outputs : ecg line (str)
            
            Return the next line and index ++
            
            """
            current_ecg = self.data_array[self.i][0]
            self.i +=1

            return current_ecg
        
        def fifo_ecg_sub(self):
            """ 
            Inputs : None

            Outputs : ecg line (str)
            
            Return the previous line and index --
            
            """
            current_ecg = self.data_array[self.i][0]
            self.i -=1

            return current_ecg
        
        def current_index(self):
            return self.i
        
        def hex_convertor(self, txt : str):
            """ 
            Inputs : txt (str)

            Outputs : txt_hex (hex)
            
            Return the next line and index ++
            
            """
            txt_hex = bytes.fromhex(txt.format(hex))

            return txt_hex

        def set_key(self, key : str):
            """ 
            Inputs : key (str)

            Outputs : Bad result (bool)
            
            Set the FPGA ascon key.

            """
            self.log.write(f"[DEBUG] Sending key to FPGA\n")
            
            message_length = len(key)
            if (message_length == 32):
                self.log.write(f"[INFO] key length is correct\n")
            else:
                self.log.write(f"[WARNING] Length of wave different of 32 characters\n")
                return False
            
            self.key = self.hex_convertor(key)
            key = "4B" + key
            key_hex = self.hex_convertor(key)
            send = self.ser.write(key_hex)

            ret = self.ser.read(3)
            if (ret == b"OK\n"):
                self.log.write(f"[INFO] Key successfully sent to FPGA\n")
                return True
            else:
                self.log.write(f"[WARNING] Bad result during key transmit\n")
                return False

        def set_da(self, da : str):
            """ 
            Inputs : da (str)

            Outputs : Bad result (bool)
            
            Set the ascon associated data.
            """
            self.log.write(f"[DEBUG] Sending associated data to FPGA\n")

            message_length = len(da)
            if (message_length == 12):
                self.log.write(f"[INFO] Da length is correct\n")
            else:
                self.log.write(f"[WARNING] Length of da different of 12 characters\n")
                return False
            self.da = da + "8000"
            self.da = self.hex_convertor(self.da)
            da = "41" + da + "8000"
            da_hex = self.hex_convertor(da)
            send = self.ser.write(da_hex)

            ret = self.ser.read(3)
            if (ret == b"OK\n"):
                self.log.write(f"[INFO] Key successfully sent to FPGA\n")
                return True
            else:
                self.log.write(f"[WARNING] Bad result during key transmit\n")
                return False
        
        def set_nonce(self, nonce : str):
            """ 
            Inputs : none (str)

            Outputs : Bad result (bool)
            
            Set the ascon none parameter.

            """
            self.log.write(f"[DEBUG] Sending none to FPGA\n")
            message_length = len(nonce)
            if (message_length == 32):
                self.log.write(f"[INFO] none length is correct\n")
            else:
                self.log.write(f"[WARNING] Length of wave different of 32 characters\n")
                return False
            
            self.nonce = self.hex_convertor(nonce)
            nonce = "4E" + nonce
            nonce_hex = self.hex_convertor(nonce)
            send = self.ser.write(nonce_hex)

            ret = self.ser.read(3)
            if (ret == b"OK\n"):
                self.log.write(f"[INFO] Key successfully sent to FPGA\n")
                return True
            else:
                self.log.write(f"[WARNING] Bad result during key transmit\n")
                return False
        
        def set_wave(self, wave : str):
            """ 
            Inputs : wave (str)

            Outputs : Bad result (bool)
            
            Send the wave.

            """
            self.log.write(f"[DEBUG] Sending wave to FPGA\n")

            message_length = len(wave)
            if (message_length == 362):
                self.log.write(f"[INFO] Wave length is correct\n")
            else:
                self.log.write(f"[WARNING] Length of wave different of 362 characters\n")
                return False
            
            self.wave = self.hex_convertor(wave + "800000")
            wave = "57" + wave + "800000"
            wave_hex = self.hex_convertor(wave)
            send = self.ser.write(wave_hex)

            ret = self.ser.read(3)
            if (ret == b"OK\n"):
                self.log.write(f"[INFO] Wave successfully sent to FPGA\n")
                return True
            else:
                self.log.write(f"[WARNING] Bad result during wave transmit\n")
                return False
            
        def start_ascon(self):
            """ 
            Inputs : None

            Outputs : Bad result (bool)
            
            Send the wave.
            """
            go_hex = self.hex_convertor("47")
            send = self.ser.write(go_hex)

            ret = self.ser.read(3)
            if (ret == b"OK\n"):
                self.log.write(f"[INFO] Go successfully sent to FPGA\n")
                return True
            else:
                self.log.write(f"[WARNING] Bad result during go transmit\n")
                return False
            
        def read_cipher(self):
            """ 
            Inputs : None

            Outputs : cipher (str)
            
            Get the cipher.
            """
            c_hex = self.hex_convertor("43")
            send = self.ser.write(c_hex)

            ret = self.ser.read(187)
            self.cipher = ret[:-3].hex()

            return ret[:-3].hex()

        def read_tag(self):
            """ 
            Inputs : None

            Outputs : tag (str)
            
            Get the tag.
            """
            t_hex = self.hex_convertor("54")
            send = self.ser.write(t_hex)

            ret = self.ser.read(19)
            self.tag = ret[:-3].hex()
            
            return ret[:-3].hex()
        
        def decrypt_cipher(self, cipher, tag):
            plain_text = ap.ascon_decrypt(key = self.key, nonce = self.nonce, associateddata = self.da, ciphertext = self.cipher+self.tag, variant="Ascon-128")
            return plain_text
        
        def display_ecg(self, list):
            
            wave_int = [int(hexa, 16) for hexa in list]
            plt.figure()
            plt.plot([i for i in range(len(wave_int))], wave_int)
            plt.grid()
            plt.xlabel("Time(s)")
            plt.ylabel("Value (0-255)")
            plt.scatter([wave_int.index(max(wave_int))], [max(wave_int)], color='red')
            plt.text(0, 0, f"X = {wave_int.index(max(wave_int))} | Y = {max(wave_int)} ", fontsize=12, bbox=dict(boxstyle="round",ec=(0, 0, 0),fc=(1., 0.8, 0.8)))
            plt.show()
        
        
        def close_instrument(self):
            """ 
            Inputs : None

            Outputs : None
            
            Close the communication between FPGA and computer.
            """
            self.ser.close() 
            self.log.write(f"[INFO] Connection closed successfully\n \n")
            self.log.close()