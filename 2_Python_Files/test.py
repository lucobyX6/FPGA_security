import numpy as np
string = "D"

hex_table = np.array(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"])
translate_table = np.array(['\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07', '\x08', '\x09', '\x0A', '\x0B', '\x0C', '\x0D', '\x0E', '\x0F'])

index = np.where(hex_table == string)[0][0]
equivalent = translate_table[int(index)].encode("utf-8")
print(equivalent)
