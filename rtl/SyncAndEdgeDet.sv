module async_signal_sync #(
    parameter POS_EDGE_EN = 1,   // Enable pulse on positive edge (1 to enable, 0 to disable)
    parameter NEG_EDGE_EN = 1    // Enable pulse on negative edge (1 to enable, 0 to disable)
) (
    input  logic clk,            // Target clock domain
    input  logic rst_n,          // Active low reset
    input  logic sig_a,          // Asynchronous input signal
    output logic sig,            // Synchronized signal output
    output logic sig_p,          // Pulse output for positive edge
    output logic sig_n           // Pulse output for negative edge
);

    // Internal signals for synchronization
    logic sig_sync1, sig_sync2;

    // Two-stage synchronizer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sig_sync1 <= 0;
            sig_sync2 <= 0;
        end else begin
            sig_sync1 <= sig_a;     // First stage of synchronizer
            sig_sync2 <= sig_sync1; // Second stage of synchronizer
        end
    end

    // Synchronized output signal
    assign sig = sig_sync2;

    // Optional positive edge detection
    generate
        if (POS_EDGE_EN) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    sig_p <= 0;
                end else begin
                    sig_p <= sig_sync1 & ~sig_sync2; // Pulse on positive edge
                end
            end
        end else begin
            always @* sig_p = 0; // Disable positive edge detection if not enabled
        end
    endgenerate

    // Optional negative edge detection
    generate
        if (NEG_EDGE_EN) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    sig_n <= 0;
                end else begin
                    sig_n <= ~sig_sync1 & sig_sync2; // Pulse on negative edge
                end
            end
        end else begin
            always @* sig_n = 0; // Disable negative edge detection if not enabled
        end
    endgenerate

endmodule
