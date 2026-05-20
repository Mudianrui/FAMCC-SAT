# FAMCC-SAT

Matlab code for Fully Actuated Manifold Constraint Based Output Feedback Control for Input-Constrained Uncertain Nonlinear Systems

## Requirements

- Matlab (R2020b or higher) with Simulink.

## Usage

The entry points are `.mdl` files. Open them in Simulink to run the simulations:

- `Ssim_OF.mdl` — Output feedback control simulation
- `Ssim3.mdl` — Third-order system simulation

The remaining `.m` files contain model and controller functions required for simulation, and are automatically invoked by the Simulink models.
