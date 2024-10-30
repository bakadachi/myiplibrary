module sync_debounce #(
    parameter integer DEBOUNCE_COUNT = 1000,     // Number of clock cycles to debounce
    parameter integer COUNTER_WIDTH = 10        // Bit width of the debounce counter
) (
    input  logic clk,        // Target clock domain
    input  logic rst_n,      // Active low reset
    input  logic sig_a,      // Asynchronous input signal
    output logic sig_out     // Debounced, synchronized output signal
);

    // Internal signals for synchronization and debouncing
    logic sig_sync1, sig_sync2;                   // Synchronization stages
    logic sig_stable;                             // Stable signal after debounce
    logic [COUNTER_WIDTH-1:0] debounce_counter;   // Counter for debounce

    // Two-stage synchronizer to synchronize `sig_a` to `clk` domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sig_sync1 <= 0;
            sig_sync2 <= 0;
        end else begin
            sig_sync1 <= sig_a;    // First stage
            sig_sync2 <= sig_sync1; // Second stage
        end
    end

    // Debounce logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debounce_counter <= 0;
            sig_stable <= 0;
        end else if (sig_sync2 != sig_stable) begin
            // Start counting if the synchronized signal changes
            debounce_counter <= debounce_counter + 1;
            if (debounce_counter == DEBOUNCE_COUNT - 1) begin
                // If signal is stable for the debounce time, update stable signal
                sig_stable <= sig_sync2;
                debounce_counter <= 0; // Reset the counter
            end
        end else begin
            // Reset the counter if no change is detected
            debounce_counter <= 0;
        end
    end

    // Output the debounced and synchronized signal
    assign sig_out = sig_stable;

endmodule
