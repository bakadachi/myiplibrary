module async_fifo #(
    parameter DATA_WIDTH = 8,         // Width of data
    parameter FIFO_DEPTH = 16         // Depth of FIFO (must be a power of 2)
) (
    input  logic                clk_wr,       // Write clock domain
    input  logic                clk_rd,       // Read clock domain
    input  logic                rst_n,        // Active low reset
    input  logic [DATA_WIDTH-1:0] wr_data,    // Write data input
    input  logic                wr_en,        // Write enable
    input  logic                rd_en,        // Read enable
    output logic [DATA_WIDTH-1:0] rd_data,    // Read data output
    output logic                full,         // FIFO full flag
    output logic                empty         // FIFO empty flag
);

    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);  // Address width based on FIFO depth

    // Memory to store data
    logic [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

    // Write and Read pointers in binary and gray code
    logic [ADDR_WIDTH:0] wr_ptr_bin, wr_ptr_gray, wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    logic [ADDR_WIDTH:0] rd_ptr_bin, rd_ptr_gray, rd_ptr_gray_sync1, rd_ptr_gray_sync2;

    // Write and Read pointers for accessing FIFO
    logic [ADDR_WIDTH-1:0] wr_addr, rd_addr;

    // Full and Empty flag generation
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});
    assign empty = (wr_ptr_gray_sync2 == rd_ptr_gray);

    // Write pointer update
    always @(posedge clk_wr or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_bin <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            wr_ptr_bin <= wr_ptr_bin + 1;
            wr_ptr_gray <= (wr_ptr_bin + 1) ^ ((wr_ptr_bin + 1) >> 1);
        end
    end

    // Write data into FIFO
    always @(posedge clk_wr) begin
        if (wr_en && !full) begin
            fifo_mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge clk_rd or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    // Read pointer update
    always @(posedge clk_rd or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_bin <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_bin <= rd_ptr_bin + 1;
            rd_ptr_gray <= (rd_ptr_bin + 1) ^ ((rd_ptr_bin + 1) >> 1);
        end
    end

    // Read data from FIFO
    assign rd_data = fifo_mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

    // Synchronize read pointer into write clock domain
    always @(posedge clk_wr or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

endmodule
