import fpga_communication as fp
import serial
import serial.tools.list_ports

ports = serial.tools.list_ports.comports(include_links=False)

if ports:
    PORT = ports[0].device

if __name__ == '__main__' and ports:
    fpga = fp.fpga_communication(baud_rate = 115200)
    fpga.get_port(port = PORT)
    fpga.open_instrument()
    fpga.set_key("8A55114D1CB6A9A2BE263D4D7AECAAFF")
    fpga.set_nonce("4ED0EC0B98C529B7C8CDDF37BCD0284A")
    fpga.set_da("4120746F2042")
    fpga.open_csv("../3_Data/ecg.csv")
    tmp = "57"+"5A5B5B5A5A5A5A5A59554E4A4C4F545553515354565758575A5A595756595B5A5554545252504F4F4C4C4D4D4A49444447474644424341403B36383E4449494747464644434243454745444546474A494745484F58697C92AECEEDFFFFE3B47C471600041729363C3F3E40414141403F3F403F3E3B3A3B3E3D3E3C393C41464646454447464A4C4F4C505555524F5155595C5A595A5C5C5B5959575351504F4F53575A5C5A5B5D5E6060615F605F5E5A5857545252" + "800000"
    fpga.set_wave(tmp)
    fpga.start_ascon()

    print(fpga.read_tag())
  
    c = fpga.read_cipher()

    #fpga.decrypt_cipher(c, t)
    fpga.close_instrument()
