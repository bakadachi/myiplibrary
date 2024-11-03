QuestaSim RTL Simulation Script
This repository contains a Python script to automate RTL simulations with QuestaSim on Windows. The script can accept file paths and a work directory as command-line arguments or ask for them interactively if not provided.

Requirements
QuestaSim installed and added to your system PATH (for commands like vsim and vlog).
RTL and testbench files ready for simulation.
Usage
1. Running the Script with Command-Line Arguments
Provide the RTL file, testbench file, and (optionally) the work directory as arguments:

bash
Kopioi koodi
python run_questasim_simulation.py --rtl_file path\to\your\rtl_file.v --testbench_file path\to\your\testbench.v --work_dir work
--rtl_file: Path to the RTL file (e.g., path\to\your\rtl_file.v).
--testbench_file: Path to the testbench file (e.g., path\to\your\testbench.v).
--work_dir: (Optional) Work directory for simulation files. Defaults to work if not specified.
2. Running the Script Interactively
If you omit any arguments, the script will ask for them:

bash
Kopioi koodi
python run_questasim_simulation.py
When prompted:

Enter the path to the RTL file (e.g., C:\projects\rtl\my_module.v).
Enter the path to the testbench file (e.g., C:\projects\rtl\my_testbench.v).
Specify the work directory or press Enter to accept the default (work).
Example
To run a simulation with the RTL file located at C:\projects\rtl\my_module.v and the testbench at C:\projects\rtl\my_testbench.v, either:

Use command-line arguments:

bash
Kopioi koodi
python run_questasim_simulation.py --rtl_file C:\projects\rtl\my_module.v --testbench_file C:\projects\rtl\my_testbench.v
Or run the script without arguments and provide paths when prompted:

bash
Kopioi koodi
python run_questasim_simulation.py
What the Script Does
Sets up the specified work directory (creates or cleans it).
Compiles the RTL and testbench files.
Launches QuestaSim in GUI mode with all signals logged for easy inspection.
This will open QuestaSim's GUI, allowing you to view waveforms and debug your simulation visually.
