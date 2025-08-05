module id_ex(
    input clk, reset,
    input stall, flush,

    // Data input
    input [31:0] pc_in,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [31:0] imm_in,

    // Control input
    input [3:0] alu_op_in,
    input reg_write_in, mem_read_in, mem_write_in, alu_src_in, branch_in, jump_in,
    input [11:0] csr_addr_in,
    input csr_write_in,

    // Register addresses
    input [4:0] rs1_in, rs2_in, rd_in,

    // Outputs 
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out, rs2_data_out, imm_out,
    output reg [3:0] alu_op_out,
    output reg reg_write_out, mem_read_out, mem_write_out, alu_src_out, branch_out, jump_out,
    output reg [11:0] csr_addr_out,
    output reg csr_write_out,
    output reg [4:0] rs1_out, rs2_out, rd_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            pc_out <= 0; rs1_data_out <= 0; rs2_data_out <= 0; imm_out <= 0;
            alu_op_out <= 0;
            reg_write_out <= 0; mem_read_out <= 0; mem_write_out <= 0; alu_src_out <= 0;
            branch_out <= 0; jump_out <= 0;
            csr_addr_out <= 0; csr_write_out <= 0;
            rs1_out <= 0; rs2_out <= 0; rd_out <= 0;
        end else if (!stall) begin
            pc_out <= pc_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            imm_out <= imm_in;
            alu_op_out <= alu_op_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            alu_src_out <= alu_src_in;
            branch_out <= branch_in;
            jump_out <= jump_in;
            csr_addr_out <= csr_addr_in;
            csr_write_out <= csr_write_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
        end
    end
endmodule
