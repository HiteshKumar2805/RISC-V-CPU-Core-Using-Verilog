module branch_control (
    input wire [31:0] pc,           // Current PC from IF stage
    input wire [31:0] imm,          // Immediate offset for branch/jump
    input wire [31:0] rs1_data,     // Source register 1 data (for JALR)
    input wire branch,              // Branch instruction flag
    input wire jump,                // Jump instruction flag
    input wire [2:0] funct3,        // Branch condition type
    input wire zero_flag,           // ALU Zero flag (BEQ/BNE)
    input wire less_than_flag,      // ALU less-than flag (BLT/BGE)
    input wire greater_equal_flag,  // ALU greater-equal flag (BGE/BLT)
    output reg branch_taken,        // Output: 1 if branch/jump taken
    output reg [31:0] target_pc,    // Output: Target PC address
    output reg flush                // Output: Flush pipeline if taken
);

    always @(*) begin
        branch_taken = 0;
        flush = 0;
        target_pc = pc + 4; // Default: next sequential PC

        // ===============================
        // Branch Decision Logic
        // ===============================
        if (branch) begin
            case (funct3)
                3'b000: begin // BEQ
                    if (zero_flag) begin
                        branch_taken = 1;
                        target_pc = pc + imm;
                    end
                end
                3'b001: begin // BNE
                    if (!zero_flag) begin
                        branch_taken = 1;
                        target_pc = pc + imm;
                    end
                end
                3'b100: begin // BLT
                    if (less_than_flag) begin
                        branch_taken = 1;
                        target_pc = pc + imm;
                    end
                end
                3'b101: begin // BGE
                    if (greater_equal_flag) begin
                        branch_taken = 1;
                        target_pc = pc + imm;
                    end
                end
                default: begin
                    branch_taken = 0;
                end
            endcase
        end

        // Jump Decision Logic
        if (jump) begin
            branch_taken = 1;
            if (funct3 == 3'b000) begin // JAL
                target_pc = pc + imm;
            end else begin // JALR
                target_pc = (rs1_data + imm) & ~32'b1; // align to even address
            end
        end

        // Flush Control
        if (branch_taken) begin
            flush = 1; // flush incorrect instructions
        end
    end
endmodule