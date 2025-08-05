module ex_mem(
    input clk, reset,
    input stall, flush,
    input [31:0] pc_in,
    input [31:0] alu_result_in,
    input [31:0] rs2_data_in,
    input [4:0] rd_in,
    input reg_write_in, mem_read_in, mem_write_in, branch_taken_in,
    output reg [31:0] pc_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] rs2_data_out,
    output reg [4:0] rd_out,
    output reg reg_write_out, mem_read_out, mem_write_out, branch_taken_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            pc_out <= 0; alu_result_out <= 0; rs2_data_out <= 0; rd_out <= 0;
            reg_write_out <= 0; mem_read_out <= 0; mem_write_out <= 0; branch_taken_out <= 0;
        end else if (!stall) begin
            pc_out <= pc_in;
            alu_result_out <= alu_result_in;
            rs2_data_out <= rs2_data_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            branch_taken_out <= branch_taken_in;
        end
    end
endmodule
