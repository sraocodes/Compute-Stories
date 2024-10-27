% Duffing Oscillator Simulation with Phase Space Animation
clear; close all; clc;

% Parameters for the Duffing oscillator
gamma = 0.1;    % Damping coefficient (γ)
alpha = -1;     % Linear stiffness (α)
beta = 1;       % Non-linear stiffness (β)
F = 2;          % Amplitude of the external force
omega = 2.4;    % Frequency of the external force

% Initial conditions for two trajectories
x0_1 = [0.5; 0];   % First initial condition [x(0), x'(0)]
x0_2 = [0.51; 0];  % Second initial condition [x(0), x'(0)]

% Time span for the simulation
tspan = [0 100];

% Solve the Duffing equation for both initial conditions
[t1, x1] = ode45(@(t, x) duffingODE(t, x, gamma, alpha, beta, F, omega), tspan, x0_1);
[t2, x2] = ode45(@(t, x) duffingODE(t, x, gamma, alpha, beta, F, omega), tspan, x0_2);

% Create figure with dark theme
fig = figure('Color', [0.1 0.1 0.1], 'Position', [100 100 800 600]);

% Phase space plot
ax = gca;
hold on;
box on;
grid on;

% Set background color and grid style
ax.Color = [0.1 0.1 0.1];
ax.GridColor = [0.3 0.3 0.3];
ax.GridAlpha = 0.3;
ax.MinorGridColor = [0.2 0.2 0.2];
ax.MinorGridAlpha = 0.2;

% Set axis color
ax.XColor = [0.8 0.8 0.8];
ax.YColor = [0.8 0.8 0.8];

% Set title and labels
title('Duffing Oscillator - Phase Space Animation', 'FontSize', 14, 'Color', [0.9 0.9 0.9]);
xlabel('Displacement (x)', 'FontSize', 12, 'Color', [0.8 0.8 0.8]);
ylabel('Velocity (dx/dt)', 'FontSize', 12, 'Color', [0.8 0.8 0.8]);

% Set axis limits
xlim([min(min(x1(:,1)), min(x2(:,1)))-0.1 max(max(x1(:,1)), max(x2(:,1)))+0.1]);
ylim([min(min(x1(:,2)), min(x2(:,2)))-0.1 max(max(x1(:,2)), max(x2(:,2)))+0.1]);

% Initialize animation elements
trail_length = 200;  % Length of the trailing path

% Create animated lines with different colors
h_trail1 = animatedline('Color', [1 0.3 0.3], 'LineWidth', 1.5);  % Red
h_trail2 = animatedline('Color', [0.3 0.8 1], 'LineWidth', 1.5);  % Blue

% Create markers for current positions
h_head1 = plot(x1(1,1), x1(1,2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0.3 0.3], ...
    'MarkerEdgeColor', 'none');
h_head2 = plot(x2(1,1), x2(1,2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0.3 0.8 1], ...
    'MarkerEdgeColor', 'none');

% Add legend
legend('x₀ = 0.5', 'x₀ = 0.51', 'Location', 'northeast', 'TextColor', [0.8 0.8 0.8], ...
    'Color', [0.15 0.15 0.15]);

% Initialize video writer
v = VideoWriter('duffing_animation.mp4', 'MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

% Animation loop
step = 5;  % Skip frames for smoother animation
num_frames = length(t1);

for i = 1:step:num_frames
    if ~ishandle(fig)
        break;
    end
    
    % Update trails
    idx_start = max(1, i-trail_length);
    
    clearpoints(h_trail1);
    clearpoints(h_trail2);
    
    addpoints(h_trail1, x1(idx_start:i,1), x1(idx_start:i,2));
    addpoints(h_trail2, x2(idx_start:i,1), x2(idx_start:i,2));
    
    % Update current points
    set(h_head1, 'XData', x1(i,1), 'YData', x1(i,2));
    set(h_head2, 'XData', x2(i,1), 'YData', x2(i,2));
    
    % Draw and capture frame
    drawnow;
    frame = getframe(fig);
    writeVideo(v, frame);
end

% Close the video file
close(v);

% Display completion message
fprintf('Animation has been saved as "duffing_animation.mp4"\n');

% Duffing ODE function
function dxdt = duffingODE(t, x, gamma, alpha, beta, F, omega)
    dxdt = zeros(2,1);
    dxdt(1) = x(2);
    dxdt(2) = -gamma*x(2) - alpha*x(1) - beta*x(1)^3 + F*cos(omega*t);
end
