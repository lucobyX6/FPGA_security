import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt

# Exemple de signal ECG (vous pouvez remplacer cela par votre propre signal)
fs = 360  # Fréquence d'échantillonnage en Hz
t = np.linspace(0, 2, fs * 10)  # Temps de 0 à 10 secondes
ecg = np.sin(2 * np.pi * 1 * t) + 0.5 * np.sin(2 * np.pi * 2 * t) + 0.2 * np.random.randn(len(t))

# Filtrage passe-bande
lowcut = 0.5  # Fréquence de coupure basse en Hz
highcut = 40  # Fréquence de coupure haute en Hz
nyquist = 0.5 * fs
low = lowcut / nyquist
high = highcut / nyquist
b, a = signal.butter(1, [low, high], btype='band')
ecg_filtered = signal.filtfilt(b, a, ecg)

# Détection des complexes QRS
peaks, _ = signal.find_peaks(ecg_filtered, distance=int(fs / 2))

# Détection des ondes P et T
p_peaks = []
t_peaks = []
for peak in peaks:
    # Détection de l'onde P
    p_start = max(0, peak - int(fs / 4))
    p_end = peak
    p_peak = np.argmax(ecg_filtered[p_start:p_end]) + p_start
    p_peaks.append(p_peak)

    # Détection de l'onde T
    t_start = peak
    t_end = min(len(ecg_filtered), peak + int(fs / 2))
    t_peak = np.argmax(ecg_filtered[t_start:t_end]) + t_start
    t_peaks.append(t_peak)

# Affichage du signal ECG et des ondes détectées
plt.plot(t, ecg, label='ECG Original')
plt.plot(t, ecg_filtered, label='ECG Filtré', alpha=0.75)
plt.plot(t[peaks], ecg_filtered[peaks], "x", label='Complexe QRS')
plt.plot(t[p_peaks], ecg_filtered[p_peaks], "o", label='Onde P')
plt.plot(t[t_peaks], ecg_filtered[t_peaks], "o", label='Onde T')
plt.legend()
plt.xlabel('Temps (s)')
plt.ylabel('Amplitude')
plt.title('Détection des ondes P, Q, R, S et T')
plt.show()
