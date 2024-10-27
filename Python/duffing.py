import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Parameters for the Duffing oscillator
gamma = 0.1  # Damping coefficient (γ)
alpha = -1   # Linear stiffness (α)
beta = 1     # Non-linear stiffness (β)
F = 2        # Amplitude of the external force
omega = 2.4  # Frequency of the external force

# Define the Duffing oscillator system of ODEs
def duffing_system(t, state, gamma, alpha, beta, F, omega):
    """
    Define the Duffing oscillator differential equations.
    state[0] is displacement x
    state[1] is velocity x'
    """
    x, v = state
    dxdt = v
    dvdt = -gamma*v - alpha*x - beta*x**3 + F*np.cos(omega*t)
    return [dxdt, dvdt]

# Initial conditions for two simulations with small changes
x0_1 = [0.5, 0]   # Initial conditions [x(0), x'(0)]
x0_2 = [0.51, 0]  # Slightly different initial conditions [x(0), x'(0)]

# Time span for the simulation
t_span = (0, 100)
t_eval = np.linspace(*t_span, 10000)  # Points at which to store the solution

# Solve the system for both initial conditions
solution_1 = solve_ivp(
    duffing_system,
    t_span,
    x0_1,
    args=(gamma, alpha, beta, F, omega),
    t_eval=t_eval,
    method='RK45'
)

solution_2 = solve_ivp(
    duffing_system,
    t_span,
    x0_2,
    args=(gamma, alpha, beta, F, omega),
    t_eval=t_eval,
    method='RK45'
)

# Create the plots
plt.figure(figsize=(10, 8))

# Displacement vs Time plot
plt.subplot(2, 1, 1)
plt.plot(solution_1.t, solution_1.y[0], label='Initial Condition: x0 = 0.5', color='blue', linewidth=1.5)
plt.plot(solution_2.t, solution_2.y[0], label='Initial Condition: x0 = 0.51', color='orange', linewidth=1.5)
plt.title('Duffing Oscillator - Displacement vs Time')
plt.xlabel('Time')
plt.ylabel('Displacement (x)')
plt.legend()
plt.grid(True)

# Phase space plot for the first initial condition
plt.subplot(2, 1, 2)
plt.plot(solution_1.y[0], solution_1.y[1], label='Initial Condition: x0 = 0.5', color='blue', linewidth=1.5)
plt.plot(solution_2.y[0], solution_2.y[1], label='Initial Condition: x0 = 0.51', color='orange', linewidth=1.5)
plt.title('Duffing Oscillator - Phase Space (x vs x\')')
plt.xlabel('Displacement (x)')
plt.ylabel('Velocity (x\')')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.show()

