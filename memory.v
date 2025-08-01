module memory(
    input clk,              
    input [31:0] alu_result,
    input [31:0] rs2_data,
    input [4:0] rd,
    input reg_write, mem_read, mem_write,  
    input [31:0] mem_data,
    output reg [31:0] mem_addr,
    output reg [31:0] mem_wdata,
    output reg mem_write_out, mem_read_out,
    output reg [4:0] rd_out,
    output reg [31:0] mem_data_out
);

    always @(posedge clk) begin
    // Default values
    mem_addr <= alu_result;        // Always use the latest address
    mem_wdata <= 0;               // Default to 0 if not writing
    mem_data_out <= 0;            // Default to 0 if not reading
    mem_write_out <= mem_write;   // Pass through write signal
    mem_read_out <= mem_read;     // Pass through read signal
    rd_out <= rd;                 // Pass through register address

    // Handle read (load)
    if (mem_read) begin
        mem_data_out <= mem_data;
    end

    // Handle write (store)
    if (mem_write) begin
        mem_wdata <= rs2_data;    // Set data to write
    end
end
endmodule