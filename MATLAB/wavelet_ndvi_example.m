% Generate NDVI time series with enhanced ecological events
clear all; close all;

t = 0:1/12:10;  % 10 years monthly samples
n = length(t);

% Base signal
seasonal_amp = 0.15;
base_ndvi = 0.7;
seasonal = base_ndvi + seasonal_amp * sin(2*pi*t);
ndvi = seasonal;

% Add events
degradation = -0.15 * (t/10).^2;
ndvi = ndvi + degradation;

% Enhanced Drought event
drought_mask = (t >= 3) & (t <= 4.5); % Extend duration
ndvi(drought_mask) = ndvi(drought_mask) - 0.3 * exp(-(t(drought_mask)-3.75).^2/0.3); % Increase amplitude

% Enhanced Insect outbreak event
insect_mask = (t >= 7) & (t <= 7.5); % Extend duration
ndvi(insect_mask) = ndvi(insect_mask) - 0.6; % Increase amplitude

% Reduce random noise
noise = 0.005 * randn(size(t)); % Lower noise level
ndvi = ndvi + noise;

% Plotting
figure('Position', [100 100 1200 1000]);

% Plot 1: Time Series with Enhanced Annotations
subplot(3,1,1);
plot(t, ndvi, 'LineWidth', 2, 'Color', [0.2 0.5 0.7]);
hold on;
plot(t, seasonal + degradation, '--', 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
ylabel('NDVI');
title('NDVI Time Series with Enhanced Ecological Events');
grid on;
legend('Observed NDVI', 'Expected Pattern with Degradation');
ylim([0 1]);

% Annotate events
text(3.75, 0.5, 'Drought', 'FontSize', 10, 'Color', 'red');
text(7.25, 0.3, 'Insect Outbreak', 'FontSize', 10, 'Color', 'red');

% Plot 2: Wavelet Shapes at Different Scales
subplot(3,1,2);
t_wavelet = linspace(-4, 4, 400);
scales = [0.3, 1, 3];
colors = {'r', 'g', 'b'};
legends = {};

for i = 1:length(scales)
    s = scales(i);
    psi = (1 - (t_wavelet/s).^2) .* exp(-(t_wavelet/s).^2/2);
    plot(t_wavelet, psi/max(abs(psi)), colors{i}, 'LineWidth', 2);
    hold on;
    legends{end+1} = sprintf('Scale = %.1f', s);
end

title('Wavelet Shapes at Different Scales (Normalized)');
ylabel('Amplitude');
xlabel('Time shift');
grid on;
legend(legends);
ylim([-1.2 1.2]);

% Plot 3: CWT with Enhanced Events
subplot(3,1,3);
scales = logspace(-1.5, 0.5, 64);  % Adjusted scale range to focus on relevant periods
periods = scales;

cwt = zeros(length(scales), n);
for i = 1:length(scales)
    s = scales(i);
    for j = 1:n
        t_centered = t - t(j);
        wavelet = (1 - (t_centered/s).^2) .* exp(-(t_centered/s).^2/2);
        cwt(i,j) = sum(ndvi .* wavelet) / sqrt(s);
    end
end

imagesc(t, log2(periods), abs(cwt));
colormap('jet');
colorbar;

yticks = log2([0.25 0.5 1 2 3]);
set(gca, 'YTick', yticks);
set(gca, 'YTickLabel', {'3-month', '6-month', '1-year', '2-year', '3-year'});

ylabel('Time Scale (Period)');
xlabel('Time (years)');
title('Continuous Wavelet Transform with Enhanced Events');

% Highlight events on CWT plot
hold on;
plot([3.75 3.75], [log2(0.25) log2(1)], 'k--', 'LineWidth', 1.5); % Drought
plot([7.25 7.25], [log2(0.25) log2(1)], 'k--', 'LineWidth', 1.5); % Insect outbreak

sgtitle('NDVI Wavelet Analysis with Enhanced Event Detection', 'FontSize', 14);
