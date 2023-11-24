Overview:

# Vivado CPU Design Project

This Vivado project implements an 8-bit CPU using VHDL. The project is organized into various directories and contains VHDL files for different components of the CPU.

## Project Structure

### 1. Utility Sources
- Contains utility VHDL files commonly used across different modules.

### 2. Design Sources
- Contains VHDL files representing the main components of the CPU.
  - **Modules:**
    - `datapath.vhd`
    - `tri_state_buffer.vhd`
    - `alu.vhd`
    - `register_file.vhd`
    - `accumulator.vhd`
    - `mux4.vhd`
    - `controller.vhd`
    - `clock_divider.vhd`
  - **Top-Level Design:**
    - `cpu_core.vhd`

## How to Use

1. Clone the repository.
2. Open the project in Vivado.
3. Explore different modules and components within the project.
4. Modify and extend the CPU design as needed.


## Contributions:
@Shyama Gandhi, @Antonio Andara Lara, @Raju Machupalli
Contributions are welcome! If you find issues or want to improve the project, feel free to open a pull request.

## License:
This project is licensed under the CC0 1.0 Universal (Provide credits to the author).
