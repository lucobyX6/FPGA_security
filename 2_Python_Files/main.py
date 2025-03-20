import fpga_communication as fp
import serial
import serial.tools.list_ports

ports = serial.tools.list_ports.comports(include_links=False)

if ports:
    PORT = ports[0].device

if __name__ == '__main__' and ports:
    fpga = fp.fpga_communication(port = PORT, baud_rate = 115200)
    fpga.open_instrument()
    fpga.set_key("8A55114D1CB6A9A2BE263D4D7AECAAFF")
    fpga.set_nonce("4ED0EC0B98C529B7C8CDDF37BCD0284A")
    fpga.set_da("4120746F2042")
    fpga.open_csv("../3_Data/ecg.csv")
    tmp = fpga.fifo_ecg()
    fpga.set_wave(tmp)
    fpga.start_ascon()
    t = fpga.read_tag()
    c = fpga.read_cipher()
    fpga.decrypt_cipher(c, t)
    fpga.close_instrument()
