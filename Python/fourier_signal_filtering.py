import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq, ifft

# Set default plotting style
plt.style.use('default')  # Reset to default style first
plt.rcParams.update({
    'figure.facecolor': '#f0f0f0',
    'axes.facecolor': '#ffffff',
    'axes.grid': True,
    'grid.color': '#cccccc',
    'grid.linestyle': '--',
    'grid.alpha': 0.5
})


# Set up the parameters for the time series
sampling_rate = 1000  # Sampling rate in Hz
T = 1.0 / sampling_rate  
N = 1000  # Number of points in the signal
time = np.linspace(0.0, N * T, N, endpoint=False)  # Time 

# Define frequencies for the two components of the signal
f1 = 50.0  # Frequency of the first sine wave (in Hz)
f2 = 120.0  # Frequency of the second sine wave (in Hz)

# Create two separate signals and a mixed signal
signal1 = 0.7 * np.sin(2.0 * np.pi * f1 * time)  # First signal
signal2 = 1.0 * np.sin(2.0 * np.pi * f2 * time)  # Second signal
mixed_signal = signal1 + signal2  # Mixed signal

# Compute the Fast Fourier Transform (FFT) of the mixed signal
fft_values = fft(mixed_signal)
frequencies = fftfreq(N, T)

# Focus on positive frequencies for simplicity
positive_freqs = frequencies[:N//2]
positive_fft_values = 2.0/N * np.abs(fft_values[:N//2])  # Normalized magnitude

# Create the low-pass filter response
cutoff_frequency = 100  # Cutoff frequency in Hz
filter_response = np.ones_like(frequencies)
filter_response[np.abs(frequencies) > cutoff_frequency] = 0

# Create a figure with a custom size and layout
plt.figure(figsize=(15, 12))

# Plot 1: Time-domain signals
ax1 = plt.subplot(4, 1, 1)
plt.plot(time[:200], signal1[:200], label="50 Hz Signal", color='#2ecc71', linewidth=2)
plt.plot(time[:200], signal2[:200], label="120 Hz Signal", color='#e74c3c', linewidth=2)
plt.plot(time[:200], mixed_signal[:200], label="Mixed Signal", color='#3498db', alpha=0.7, linewidth=2)
plt.title("Time Domain Signals (First 0.2 seconds)", fontsize=12, pad=10)
plt.xlabel("Time (s)")
plt.ylabel("Amplitude")
plt.legend(loc='upper right', framealpha=0.9)
plt.grid(True, linestyle='--', alpha=0.7)

# Plot 2: Frequency-domain representation
ax2 = plt.subplot(4, 1, 2)
plt.plot(positive_freqs, positive_fft_values, color='#9b59b6', linewidth=2)
plt.title("Frequency Domain (FFT of Mixed Signal)", fontsize=12, pad=10)
plt.xlabel("Frequency (Hz)")
plt.ylabel("Magnitude")
plt.grid(True, linestyle='--', alpha=0.7)
plt.xlim(0, 150)  # Focus on relevant frequency range

# Plot 3: Low-pass filter response
ax3 = plt.subplot(4, 1, 3)
plt.plot(frequencies[frequencies >= 0], filter_response[frequencies >= 0], 
         color='#e67e22', linewidth=2, label='Filter Response')
plt.axvline(x=cutoff_frequency, color='#c0392b', linestyle='--', 
            label=f'Cutoff Frequency ({cutoff_frequency} Hz)')
plt.title("Low-Pass Filter Response", fontsize=12, pad=10)
plt.xlabel("Frequency (Hz)")
plt.ylabel("Magnitude")
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend(loc='upper right')
plt.xlim(0, 150)

# Apply the filter and compute filtered signal
filtered_fft_values = fft_values * filter_response
filtered_signal = np.real(ifft(filtered_fft_values))

# Plot 4: Filtered signal
ax4 = plt.subplot(4, 1, 4)
plt.plot(time[:200], filtered_signal[:200], color='#16a085', linewidth=2, 
         label='Filtered Signal')
plt.plot(time[:200], signal1[:200], '--', color='k', alpha=.5, 
         label='Original 50 Hz Signal')
plt.title("Reconstructed Signal After Low-Pass Filtering", fontsize=12, pad=10)
plt.xlabel("Time (s)")
plt.ylabel("Amplitude")
plt.legend(loc='upper right')
plt.grid(True, linestyle='--', alpha=0.7)

# Adjust layout and display
plt.tight_layout()
plt.show()
