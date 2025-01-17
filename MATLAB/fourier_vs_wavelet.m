% Clear workspace
clear; clc; close all;

% Parameters
fs = 1000; % Sampling frequency (Hz)
t = 0:1/fs:10; % Extended to 10 seconds for longer video
% Create a more interesting signal with clear time-varying frequencies
signal = sin(2*pi*5*t) + ...                    % Constant low frequency
         sin(2*pi*(10 + 2*t).*t) + ...         % Linear chirp
         0.5*sin(2*pi*30*t).*(t>5).*(t<7);     % High frequency burst

% Fourier Transform (FT)
nfft = length(signal);
frequencies = linspace(0, fs/2, floor(nfft/2) + 1);
FT = abs(fft(signal)/nfft);
FT = FT(1:floor(nfft/2) + 1);

% Custom window function
function_window = @(N) 0.5 * (1 - cos(2*pi*(0:N-1)'/(N-1)));

% Time-Frequency Analysis parameters
win_size = 500; % Larger window for better frequency resolution
step = 100;    % Smaller step for smoother animation
time_steps = 1:step:length(t)-win_size;
wavelet_data = zeros(length(frequencies), length(time_steps));

% Compute Time-Frequency representation
for i = 1:length(time_steps)
    idx = round(time_steps(i)):round(time_steps(i) + win_size - 1);
    window = function_window(length(idx));
    win_signal = signal(idx) .* window';
    win_fft = abs(fft(win_signal, nfft)/nfft);
    wavelet_data(:, i) = win_fft(1:length(frequencies));
end

% Create video writer object with correct dimensions
figure('Position', [100 100 1600 1200], 'Color', 'k');
v = VideoWriter('laplace.mp4', 'MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

% Create title text
titleStr = {'Time-Frequency Analysis Comparison', ...
            'Showing how wavelet-based analysis captures time-varying frequencies'};

% Animation loop with longer display time
numFrames = length(time_steps) * 3; % Triple the number of frames for slower motion
for k = 1:numFrames
    clf;
    
    % Calculate actual analysis position
    analysisIdx = ceil(k/3); % Slow down the analysis movement
    
    % Main title
    sgtitle(titleStr, 'Color', 'w', 'FontSize', 16, 'FontWeight', 'bold');
    
    % Time domain plot
    subplot(3,1,1);
    plot(t, signal, 'y', 'LineWidth', 2);
    hold on;
    current_idx = round(time_steps(analysisIdx)):round(time_steps(analysisIdx) + win_size - 1);
    plot(t(current_idx), signal(current_idx), 'r', 'LineWidth', 2.5);
    title('Time Domain Signal - Mixed Frequency Components', 'Color', 'w', 'FontSize', 14);
    xlabel('Time (s)', 'Color', 'w');
    ylabel('Amplitude', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'LineWidth', 1.5);
    grid on;
    xlim([0 10]);
    
    % Fourier Transform plot
    subplot(3,1,2);
    plot(frequencies(1:500), FT(1:500), 'c', 'LineWidth', 2);
    title('Fourier Transform - Overall Frequency Content', 'Color', 'w', 'FontSize', 14);
    xlabel('Frequency (Hz)', 'Color', 'w');
    ylabel('Magnitude', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'LineWidth', 1.5);
    grid on;
    
    % Time-Frequency plot
    subplot(3,1,3);
    current_data = wavelet_data;
    current_data(:, analysisIdx) = current_data(:, analysisIdx) * 1.5;
    imagesc(time_steps/fs, frequencies(1:500), current_data(1:500,:));
    axis xy;
    colormap(jet);
    title('Time-Frequency Analysis - When Each Frequency Occurs', 'Color', 'w', 'FontSize', 14);
    xlabel('Time (s)', 'Color', 'w');
    ylabel('Frequency (Hz)', 'Color', 'w');
    set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'LineWidth', 1.5);
    cb = colorbar;
    cb.Color = 'w';
    
    % Add annotations for key features
    subplot(3,1,3);
    hold on;
    if k == 1
        text(0.5, 40, 'Constant low frequency', 'Color', 'w', 'FontSize', 12);
        text(3, 20, 'Increasing frequency (chirp)', 'Color', 'w', 'FontSize', 12);
        text(6, 35, 'High frequency burst', 'Color', 'w', 'FontSize', 12);
    end
    
    % Write frame
    frame = getframe(gcf);
    writeVideo(v, frame);
    
    % Real-time display delay
    pause(0.03);
end

% Hold the final frame for a few seconds
for i = 1:90 % 3 seconds at 30 fps
    writeVideo(v, frame);
end

close(v);
disp('Animation saved as laplace.mp4');
