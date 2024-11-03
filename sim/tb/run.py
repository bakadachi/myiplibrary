import subprocess
import os
import argparse

def run_command(command):
    """Run a shell command and handle errors."""
    result = subprocess.run(command, shell=True)
    if result.returncode != 0:
        print(f"Error: Command '{command}' failed with return code {result.returncode}")
        exit(result.returncode)

def main(rtl_file, testbench_file, work_dir):
    # Check if files exist
    if not os.path.isfile(rtl_file):
        print(f"Error: RTL file '{rtl_file}' not found.")
        exit(1)
    if not os.path.isfile(testbench_file):
        print(f"Error: Testbench file '{testbench_file}' not found.")
        exit(1)

    # Create or clean work directory
    if os.path.isdir(work_dir):
        print(f"Cleaning work directory '{work_dir}'...")
        run_command(f"rd /s /q {work_dir}")
    print(f"Creating work directory '{work_dir}'...")
    run_command(f"vlib {work_dir}")

    # Compile RTL file
    print("Compiling RTL file...")
    run_command(f"vlog -work {work_dir} {rtl_file}")

    # Compile testbench file
    print("Compiling Testbench...")
    run_command(f"vlog -work {work_dir} {testbench_file}")

    # Run simulation in GUI mode
    print("Running simulation in GUI mode...")
    run_command(f"vsim -lib {work_dir} testbench -do \"log -r /*; run -all;\"")

    print("Simulation launched in GUI.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run QuestaSim Simulation for RTL code with GUI.")
    parser.add_argument("--rtl_file", help="Path to the RTL file (e.g., path\\to\\your\\rtl_file.v)")
    parser.add_argument("--testbench_file", help="Path to the testbench file (e.g., path\\to\\your\\testbench.v)")
    parser.add_argument("--work_dir", default="work", help="Work directory for simulation (default: 'work')")

    args = parser.parse_args()

    # Prompt for any missing arguments
    rtl_file = args.rtl_file or input("Enter the path to the RTL file: ")
    testbench_file = args.testbench_file or input("Enter the path to the testbench file: ")
    work_dir = args.work_dir

    # Run the main function with provided arguments
    main(rtl_file, testbench_file, work_dir)
