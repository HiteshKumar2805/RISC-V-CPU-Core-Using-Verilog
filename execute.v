module execute (
    input clk,
    input [31:0] pc_in, rs1_data, rs2_data, imm,
    input [4:0] rs1, rs2, rd,
    input [3:0] alu_op,
    input reg_write, mem_read, mem_write, alu_src, branch, jump,
    input [31:0] ex_mem_alu_result, mem_wb_data,
    input [4:0] ex_mem_rd, mem_wb_rd,
    input ex_mem_reg_write, mem_wb_reg_write,
    input stall, flush, // Added missing inputs
    output reg [31:0] pc_out, alu_result,
    output reg [31:0] rs2_data_out,
    output reg [4:0] rd_out,
    output reg reg_write_out, mem_read_out, mem_write_out,
    output reg branch_taken
);
    // Select ALU input B (rs2_data or imm) based on alu_src
    wire [31:0] alu_b = alu_src ? imm : rs2_data;

    // Forwarding logic for rs1_data
    wire [31:0] forwarded_rs1 = (ex_mem_reg_write && ex_mem_rd == rs1 && ex_mem_rd != 0) ? ex_mem_alu_result :
                                (mem_wb_reg_write && mem_wb_rd == rs1 && mem_wb_rd != 0) ? mem_wb_data : rs1_data;

    // Forwarding logic for rs2_data
    wire [31:0] forwarded_rs2 = (ex_mem_reg_write && ex_mem_rd == rs2 && ex_mem_rd != 0) ? ex_mem_alu_result :
                                (mem_wb_reg_write && mem_wb_rd == rs2 && mem_wb_rd != 0) ? mem_wb_data : rs2_data;

    // ALU and branch/jump logic (combinational)
    always @(*) begin
        case (alu_op)
            4'b0000: alu_result = forwarded_rs1 + alu_b; // ADD
            4'b0001: alu_result = forwarded_rs1 - forwarded_rs2; // SUB (for branch or R-type)
            default: alu_result = 0;
        endcase
        branch_taken = (branch && (forwarded_rs1 == forwarded_rs2)); // BEQ condition
        if (jump) alu_result = pc_in + imm; // JAL target
    end

    // Pipeline register updates
    always @(posedge clk) begin
        if (!stall && !flush) begin
            pc_out <= pc_in;
            alu_result <= alu_result;
            rs2_data_out <= rs2_data;
            rd_out <= rd;
            reg_write_out <= reg_write;
            mem_read_out <= mem_read;
            mem_write_out <= mem_write;
        end else if (flush) begin
            pc_out <= 0;
            alu_result <= 0;
            rs2_data_out <= 0;
            rd_out <= 0;
            reg_write_out <= 0;
            mem_read_out <= 0;
            mem_write_out <= 0;
        end
    end

endmodule