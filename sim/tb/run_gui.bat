@echo off
rem ------------------------------------------------------------------------
rem Script to run QuestaSim Simulation for RTL code on Windows with GUI
rem ------------------------------------------------------------------------

rem Set variables for RTL and testbench file paths
set RTL_FILE=path\to\your\rtl_file.v        rem Replace with your RTL file path
set TESTBENCH_FILE=path\to\your\testbench.v  rem Replace with your testbench file path

rem Set up working directory for simulation
set WORK_DIR=work
if exist %WORK_DIR% rd /s /q %WORK_DIR%
vlib %WORK_DIR%

rem Compile the RTL file
echo Compiling RTL...
vlog -work %WORK_DIR% %RTL_FILE%
if %errorlevel% neq 0 (
    echo Error: RTL compilation failed.
    exit /b %errorlevel%
)

rem Compile the testbench file
echo Compiling Testbench...
vlog -work %WORK_DIR% %TESTBENCH_FILE%
if %errorlevel% neq 0 (
    echo Error: Testbench compilation failed.
    exit /b %errorlevel%
)

rem Run simulation using vsim with GUI
echo Opening Simulation in GUI...
vsim -lib %WORK_DIR% testbench -do "log -r /*; run -all;"

echo Simulation launched in GUI.
exit /b 0
