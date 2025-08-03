module regfile(
    input clk,
    input [4:0] rs1, rs2, // register to read from decode
    input [4:0] wb_rd,    // register to write from writeback
    input [31:0] wb_data, // data to write from writeback
    input wb_reg_write,   // enable signal to allow writing
    output reg [31:0] read_data1, read_data2 // data from rs1 and rs2
);
    reg [31:0] registers [0:31]; // 32 registers of 32 bits

    always @(posedge clk) begin
        // Default read with x0 as 0
        read_data1 <= (rs1 == 0) ? 0 : registers[rs1];
        read_data2 <= (rs2 == 0) ? 0 : registers[rs2];

        // Write only if enabled and not x0
        if (wb_reg_write && wb_rd != 0) begin
            registers[wb_rd] <= wb_data;
        end
    end
endmodule  
   