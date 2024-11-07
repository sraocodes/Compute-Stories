import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
from matplotlib.animation import FFMpegWriter
from dataclasses import dataclass
plt.close('all')

# Define Planet class to store planet data
@dataclass
class Planet:
    name: str
    x0: float
    y0: float
    vx0: float
    vy0: float
    color: str

# Constants
G = 6.67430e-11  # Gravitational constant (m^3 kg^-1 s^-2)
M = 1.989e30     # Mass of the Sun (kg)
AU = 1.496e11    # One Astronomical Unit (m)

# Planet Data
planets = [
    Planet('Earth', AU, 0, 0, 29780, 'b'),
    Planet('Mars', 1.524*AU, 0, 0, 24100, 'r')
]

# Simulation Setup
simulation_time = 3.154e7 * 12  # 2 Earth years in seconds
num_steps = 500  # Reduced for faster rendering
t_span = (0, simulation_time)
t_eval = np.linspace(0, simulation_time, num_steps)

def orbital_equations(t, state, G, M):
    """Defines the differential equations for orbital motion"""
    x, y, vx, vy = state
    r = np.sqrt(x**2 + y**2)
    
    return [
        vx,
        vy,
        -G*M*x/r**3,
        -G*M*y/r**3
    ]

# Compute orbits
solutions = []
max_radius = 0

for planet in planets:
    initial_conditions = [planet.x0, planet.y0, planet.vx0, planet.vy0]
    
    sol = solve_ivp(
        orbital_equations,
        t_span,
        initial_conditions,
        args=(G, M),
        method='RK45',
        t_eval=t_eval,
        rtol=1e-8,
        atol=1e-10
    )
    
    solutions.append(sol)
    max_radius = max(max_radius, 1.1 * np.max(np.sqrt(sol.y[0]**2 + sol.y[1]**2)))

# Set up the figure
fig = plt.figure(figsize=(10, 10))
ax = plt.gca()
ax.set_xlim(-max_radius, max_radius)
ax.set_ylim(-max_radius, max_radius)
ax.grid(True)
ax.set_aspect('equal')
ax.set_xlabel('Distance (m)')
ax.set_ylabel('Distance (m)')

# Initialize plot elements
sun = ax.plot(0, 0, 'yo', markersize=15, markerfacecolor='yellow', label='Sun')[0]
planet_plots = []
orbit_plots = []

for planet, sol in zip(planets, solutions):
    # Plot complete orbit
    orbit_plots.append(ax.plot(sol.y[0], sol.y[1], color=planet.color, alpha=0.3)[0])
    # Plot initial planet position
    planet_plots.append(ax.plot(sol.y[0][0], sol.y[1][0], 'o',
                               color=planet.color,
                               markeredgecolor='k',
                               markersize=8,
                               label=planet.name)[0])

plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))

# Set up the writer
writer = FFMpegWriter(fps=30, metadata=dict(artist='Me'), bitrate=1800)

# Create the animation
with writer.saving(fig, "orbital_motion.mp4", dpi=100):
    for frame in range(num_steps):
        # Update planet positions
        for i, planet_plot in enumerate(planet_plots):
            planet_plot.set_data([solutions[i].y[0][frame]], [solutions[i].y[1][frame]])
        
        # Update title
        plt.title(f'Solar System: Earth and Mars Orbits\nDay {solutions[0].t[frame]/(24*3600):.1f}')
        
        writer.grab_frame()
        
        # Print progress
        if frame % 50 == 0:
            print(f"Progress: {frame}/{num_steps} frames")

plt.close()
print("\nAnimation saved as 'orbital_motion.mp4'")
