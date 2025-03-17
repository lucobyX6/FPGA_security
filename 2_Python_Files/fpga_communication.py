import serial
import serial.tools.list_ports
from datetime import datetime

class fpga_communication:
        def __init__(self, port, baud_rate):
            self.port = port
            self.baud_rate = baud_rate
        
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

        def set_key(self, key : str):
            """ 
            Inputs : key (str)

            Outputs : Bad result (bool)
            
            Sets the FPGA ascon key.

            """
            self.log.write(f"[DEBUG] Sending key to FPGA\n")
            message_length = len(key)
            

            if (message_length == 33):
                self.log.write(f"[INFO] Wave sucessfully send to FPGA\n")
            else:
                self.log.write(f"[WARNING] Length of wave different of 33 characters\n")
                return False

        def set_da(self, da : str):
            """ 
            Inputs : da (str)

            Outputs : Bad result (bool)
            
            Sets the ascon associated data.

            """
            self.log.write(f"[DEBUG] Sending associated data to FPGA\n")
            message_length = len(da)

            if (message_length == 12):
                self.log.write(f"[INFO] Wave sucessfully send to FPGA\n")
            else:
                self.log.write(f"[WARNING] Length of wave different of 12 characters\n")
                return False
        
        def set_none(self, none : str):
            """ 
            Inputs : none (str)

            Outputs : Bad result (bool)
            
            Sets the ascon none parameter.

            """
            self.log.write(f"[DEBUG] Sending none to FPGA\n")
            message_length = len(none)

            if (message_length == 33):
                self.log.write(f"[INFO] Wave sucessfully send to FPGA\n")
            else:
                self.log.write(f"[WARNING] Length of wave different of 33 characters\n")
                return False
        
        def set_wave(self, wave : str):
            """ 
            Inputs : wave (str)

            Outputs : Bad result (bool)
            
            Send the wave.

            """
            self.log.write(f"[DEBUG] Sending wave to FPGA\n")
            message_length = len(wave)

            if (message_length == 369):
                self.log.write(f"[INFO] Wave sucessfully send to FPGA\n")
            else:
                self.log.write(f"[WARNING] Length of wave different of 369 characters\n")
                return False

        def close_instrument(self):
            """ 
            Inputs : None

            Outputs : None
            
            Close the communication between FPGA and computer.
            """
            self.ser.close() 
            self.log.write(f"[INFO] Connection closed successfully\n \n")