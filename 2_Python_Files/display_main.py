import tkinter as tk
import serial
import serial.tools.list_ports
import numpy as np
import fpga_communication as fp

def avaible_ports_display():
    ports = serial.tools.list_ports.comports(include_links=False)
    global ports_list 
    ports_list = [port.device for port in ports]

def choose_port():
    port = str(selected_port.get())
    if(port != "PY_VAR0" and port != "None" and port != ""):    
        fpga.get_port(port = port)
        fpga.open_instrument()
        Port_display["text"] = f"Connected to : {port}"
    else:
        Port_display["text"] = "Connected to : None"

def Select_csv():
    name = Entry_csv.get()
    fpga.open_csv(name)

def Select_ad():
    ad = Entry_Ad.get()
    fpga.set_da(ad)

def Select_key():
    key = Entry_key.get()
    fpga.set_key(key)

def Select_nonce():
    nonce = Entry_nonce.get()
    fpga.set_key(nonce)

def wave_plus_one():
    wave = fpga.fifo_ecg_plus()
    """fpga.start_ascon()
    
    cipher_display["text"] = f"Cipher : {fpga.read_cipher()}"
    tag_display["text"] = f"Tag : {fpga.read_tag()}"""

    index = fpga.current_index()
    i_display["text"] = f"{index}"
    wave_list = np.array([wave[i:i+2] for i in range(0, len(wave), 2)])
    fpga.display_ecg(wave_list)

def wave_sub_one():
    wave = fpga.fifo_ecg_sub()
    fpga.start_ascon()
    
    cipher_display["text"] = f"Cipher : {fpga.read_cipher()}"
    tag_display["text"] = f"Tag : {fpga.read_tag()}"

    index = fpga.current_index()
    i_display["text"] = f"{index}"
    wave_list = np.array([wave[i:i+2] for i in range(0, len(wave), 2)])
    fpga.display_ecg(wave_list)




# Initialisation
main_window = tk.Tk()
main_window.title("FPGA Security - ECG Display")
photo = tk.PhotoImage(file = "heart.png")
main_window.iconphoto(False, photo)

main_window.rowconfigure([0, 1], minsize=50, weight=1)

main_window.columnconfigure([0, 1], minsize=50, weight=1)

global index

wave = ""
index = 0

# Init FPGA
fpga = fp.fpga_communication(baud_rate = 115200)

# Choose com port
Com_display = tk.Label(text="Choose an avaible COM port", font=("Helvetica", 12))
Com_display.pack(pady=10)

avaible_ports_display()

selected_port = tk.StringVar()
port_menu = tk.OptionMenu(main_window, selected_port, "None", *ports_list)
port_menu.pack(pady=20)     

button_com = tk.Button(text="Validate COM", command=choose_port, font=("Helvetica", 12), bg="orange", fg="white")
button_com.pack(pady=10)
Port_display = tk.Label(text="Connected to : None", font=("Helvetica", 12), fg="red")
Port_display.pack(pady=10)

# Csv file
Csv_display = tk.Label(text="Please write the name of your csv", font=("Helvetica", 12))
Csv_display.pack(pady=10)
Entry_csv = tk.Entry(width=50)
Entry_csv.pack()

button_csv = tk.Button(text="Validate CSV", command=Select_csv, font=("Helvetica", 12), bg="#4CAF50", fg="white")
button_csv.pack(pady=10)

# Associated Data
Ad_display = tk.Label(text="Please write the associated data", font=("Helvetica", 12))
Ad_display.pack(pady=10)
Entry_Ad = tk.Entry(width=50)
Entry_Ad.pack()

button_ad = tk.Button(text="Validate AD", command=Select_ad, font=("Helvetica", 12), bg="#4CAF50", fg="white")
button_ad.pack(pady=10)

# Key
key_display = tk.Label(text="Please write the key", font=("Helvetica", 12))
key_display.pack(pady=10)
Entry_key = tk.Entry(width=50)
Entry_key.pack()

button_key = tk.Button(text="Validate key", command=Select_key, font=("Helvetica", 12), bg="#4CAF50", fg="white")
button_key.pack(pady=10)

# Nonce
nonce_display = tk.Label(text="Please write the nonce", font=("Helvetica", 12))
nonce_display.pack(pady=10)
Entry_nonce = tk.Entry(width=50)
Entry_nonce.pack()

button_nonce= tk.Button(text="Validate nonce", command=Select_nonce, font=("Helvetica", 12), bg="#4CAF50", fg="white")
button_nonce.pack(pady=10)

# Choose wave
i_display = tk.Label(text=f"{index}")
i_display.pack(pady=5)
button_wave_plus= tk.Button(text="+1", command=wave_plus_one, font=("Helvetica", 12), bg="#2196F3", fg="white")
button_wave_plus.pack(pady=5)
button_wave_moins= tk.Button(text="-1", command=wave_sub_one, font=("Helvetica", 12), bg="#2196F3", fg="white")
button_wave_moins.pack(pady=5)
cipher_display = tk.Label(text="Cipher : None")
cipher_display.pack(pady=5)
tag_display = tk.Label(text="Tag : None")
tag_display.pack(pady=5)

# Close communication
button_close= tk.Button(text="Close COM", command=fpga.close_instrument, font=("Helvetica", 12), bg="#F44336", fg="white")
button_close.pack(pady=10)

main_window.mainloop()
