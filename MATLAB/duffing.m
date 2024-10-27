% Duffing Oscillator Simulation using ODE45 in MATLAB
% This script compares two initial conditions for the Duffing oscillator:
% m*x''(t) + γ*x'(t) + α*x(t) + β*x^3(t) = F*cos(ω*t)

% Clearing workspace and figures
clear; close all; clc;

% Parameters for the Duffing oscillator
gamma = 0.1;    % Damping coefficient (γ)
alpha = -1;     % Linear stiffness (α)
beta = 1;       % Non-linear stiffness (β)
F = 2;          % Amplitude of the external force
omega = 2.4;    % Frequency of the external force

% Two initial conditions
x0_1 = [0.5; 0];    % First initial condition [x(0), x'(0)]
x0_2 = [0.51; 0];   % Second initial condition [x(0), x'(0)]

% Time span for the simulation
tspan = [0 100];

% Solve the Duffing equation for both initial conditions
[t1, x1] = ode45(@(t, x) duffingODE(t, x, gamma, alpha, beta, F, omega), tspan, x0_1);
[t2, x2] = ode45(@(t, x) duffingODE(t, x, gamma, alpha, beta, F, omega), tspan, x0_2);

% Create figure with enhanced styling
figure('Position', [100 100 900 800], 'Color', 'white');

% Plot 1: Displacement vs Time
subplot(2,1,1);
hold on;
p1 = plot(t1, x1(:,1), 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
p2 = plot(t2, x2(:,1), 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410], 'LineStyle', '--');
title('Duffing Oscillator - Displacement vs Time', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time', 'FontSize', 10);
ylabel('Displacement (x)', 'FontSize', 10);
grid on;
legend('x₀ = 0.5', 'x₀ = 0.51', 'Location', 'best');
box on;

% Add textbox with system parameters
param_text = sprintf('Parameters:\nγ = %.1f\nα = %.1f\nβ = %.1f\nF = %.1f\nω = %.1f', ...
    gamma, alpha, beta, F, omega);
annotation('textbox', [0.15 0.8 0.2 0.1], 'String', param_text, ...
    'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black');

% Plot 2: Phase Space
subplot(2,1,2);
hold on;
p3 = plot(x1(:,1), x1(:,2), 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
p4 = plot(x2(:,1), x2(:,2), 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410], 'LineStyle', '--');

% Mark initial conditions
plot(x1(1,1), x1(1,2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0.8500 0.3250 0.0980], ...
    'MarkerEdgeColor', 'none');
plot(x2(1,1), x2(1,2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0.4470 0.7410], ...
    'MarkerEdgeColor', 'none');

title('Duffing Oscillator - Phase Space', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Displacement (x)', 'FontSize', 10);
ylabel('Velocity (dx/dt)', 'FontSize', 10);
grid on;
legend('x₀ = 0.5', 'x₀ = 0.51', 'Location', 'best');
box on;

% Add arrow annotations to show direction of flow
% Sample points for arrows (adjust based on your specific case)
for t_idx = 1:500:length(t1)
    quiver(x1(t_idx,1), x1(t_idx,2), ...
        x1(t_idx+1,1)-x1(t_idx,1), x1(t_idx+1,2)-x1(t_idx,2), ...
        0.5, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1);
end

% Adjust figure properties for better visualization
set(gcf, 'PaperPositionMode', 'auto');
set(findall(gcf,'-property','FontSize'), 'FontSize', 10);

% Duffing ODE function
function dxdt = duffingODE(t, x, gamma, alpha, beta, F, omega)
    % x(1) is the displacement x
    % x(2) is the velocity x'
    dxdt = zeros(2,1);
    dxdt(1) = x(2);                                                   % Velocity
    dxdt(2) = -gamma*x(2) - alpha*x(1) - beta*x(1)^3 + F*cos(omega*t); % Acceleration
end
