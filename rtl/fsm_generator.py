import yaml

def get_signal_details(prompt):
    signals = []
    while True:
        name = input(f"Enter the {prompt} name: ")
        size = input(f"Enter the size of {name} (e.g., 1 for single bit, 8 for byte): ")
        description = input(f"Enter a description for {name}: ")
        signals.append({'name': name, 'size': int(size), 'description': description})
        
        more = input("Do you want to add another signal? (y/n): ")
        if more.lower() != 'y':
            break
    return signals

def get_fsm_states():
    states = []
    while True:
        state_name = input("Enter the state name: ")
        states.append(state_name)
        
        more = input("Do you want to add another state? (y/n): ")
        if more.lower() != 'y':
            break
    return states

def generate_systemverilog_fsm_file(fsm_name, inputs, outputs, states, current_state, next_state, counter=False):
    sv_code = f"""// Auto-generated SystemVerilog FSM
module {fsm_name} (
"""
    # Add inputs
    for inp in inputs:
        sv_code += f"    input logic [{inp['size']-1}:0] {inp['name']}, // {inp['description']}\n"

    # Add outputs
    for out in outputs:
        sv_code += f"    output logic [{out['size']-1}:0] {out['name']}, // {out['description']}\n"

    # FSM signals
    sv_code += f"""    input logic clk,
    input logic rst
);

    // State Encoding
    typedef enum logic [{(len(states)-1).bit_length()-1}:0] {{
"""
    for i, state in enumerate(states):
        sv_code += f"        {state}"
        if i < len(states) - 1:
            sv_code += ","
        sv_code += "\n"
    sv_code += f"    }} {current_state}_t;\n\n"

    # State registers
    sv_code += f"    {current_state}_t {current_state}, {next_state};\n"

    # Optional counter
    if counter:
        sv_code += "    logic [31:0] counter;\n"

    # Always block for state transition
    sv_code += f"""
    // Sequential block for current state update
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            {current_state} <= {states[0]};
        else
            {current_state} <= {next_state};
    end

    // Combinational block for next state logic
    always_comb begin
        // Default next state
        {next_state} = {current_state};
"""
    if counter:
        sv_code += "        counter = counter + 1;\n"
    sv_code += "        // Add state transition logic here\n\n"

    # Close always_comb
    sv_code += "    end\n\n"

    # Output decoder
    sv_code += f"    // Output decoder based on current state\n"
    sv_code += "    always_comb begin\n"
    for out in outputs:
        sv_code += f"        {out['name']} = '0; // Default\n"
    sv_code += "        // Add output logic here based on current state\n"
    sv_code += "    end\n\n"

    # End of module
    sv_code += f"endmodule // {fsm_name}\n"
    return sv_code

def generate_yaml_file(fsm_name, inputs, outputs, states, current_state, next_state, counter):
    fsm_data = {
        'fsm_name': fsm_name,
        'inputs': inputs,
        'outputs': outputs,
        'states': states,
        'current_state': current_state,
        'next_state': next_state,
        'counter': counter
    }
    with open(f"{fsm_name}.yaml", "w") as yaml_file:
        yaml.dump(fsm_data, yaml_file)

def generate_package_file(fsm_name, current_state, states):
    package_code = f"""// Auto-generated package for {fsm_name} FSM
package {fsm_name}_pkg;
    typedef enum logic [{(len(states)-1).bit_length()-1}:0] {{
"""
    for i, state in enumerate(states):
        package_code += f"        {state}"
        if i < len(states) - 1:
            package_code += ","
        package_code += "\n"
    package_code += f"    }} {current_state}_t;\n"
    package_code += f"endpackage // {fsm_name}_pkg\n"
    return package_code

def main():
    fsm_name = input("Enter the FSM module name: ")
    
    # Gather inputs and outputs
    print("\n--- Input Signals ---")
    inputs = get_signal_details("input")
    
    print("\n--- Output Signals ---")
    outputs = get_signal_details("output")

    # FSM State and Encoders
    print("\n--- FSM State Details ---")
    current_state = input("Enter the name for the current state register: ")
    next_state = input("Enter the name for the next state register: ")
    print("\n--- FSM States ---")
    states = get_fsm_states()
    
    # Optional counter
    counter = input("Do you want to add a counter to the FSM? (y/n): ").lower() == 'y'
    
    # Generate SystemVerilog FSM file
    sv_code = generate_systemverilog_fsm_file(fsm_name, inputs, outputs, states, current_state, next_state, counter)
    with open(f"{fsm_name}.sv", "w") as sv_file:
        sv_file.write(sv_code)

    # Generate YAML file
    generate_yaml_file(fsm_name, inputs, outputs, states, current_state, next_state, counter)

    # Generate Package file
    package_code = generate_package_file(fsm_name, current_state, states)
    with open(f"{fsm_name}_pkg.sv", "w") as pkg_file:
        pkg_file.write(package_code)

    print(f"\nGenerated files:\n- {fsm_name}.sv\n- {fsm_name}.yaml\n- {fsm_name}_pkg.sv")

if __name__ == "__main__":
    main()
