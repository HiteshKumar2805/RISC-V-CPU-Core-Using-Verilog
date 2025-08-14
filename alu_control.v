module alu_control (
    input  wire [1:0] ALUOp,     // 00=addr calc, 01=branch cmp, 10=R-type, 11=I-type ALU
    input  wire [2:0] funct3,    // instr[14:12]
    input  wire [6:0] funct7,    // instr[31:25]
    input  wire [6:0] opcode,    // instr[6:0] (optional: for LUI/AUIPC if you want later)
    output reg  [3:0] alu_ctrl   // compact ALU op selector
);
    // ALU control encoding (fixed contract with ALU)
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRA  = 4'b0111;
    localparam ALU_SLT  = 4'b1000; // signed
    localparam ALU_SLTU = 4'b1001; // unsigned

    always @(*) begin
        // Default safe op
        alu_ctrl = ALU_ADD;

        case (ALUOp)
            2'b00: begin
                // Loads/Stores/AUIPC address calc -> ADD
                alu_ctrl = ALU_ADD;
            end

            2'b01: begin
                // Branch compare; ALU result not strictly needed,
                // but SUB is conventional for BEQ/BNE equality checks.
                alu_ctrl = ALU_SUB;
            end

            2'b10: begin
                // R-type: use funct3/funct7
                case (funct3)
                    3'b000: alu_ctrl = (funct7 == 7'b0100000) ? ALU_SUB : ALU_ADD; // SUB vs ADD
                    3'b111: alu_ctrl = ALU_AND;
                    3'b110: alu_ctrl = ALU_OR;
                    3'b100: alu_ctrl = ALU_XOR;
                    3'b001: alu_ctrl = ALU_SLL;
                    3'b101: alu_ctrl = (funct7 == 7'b0100000) ? ALU_SRA : ALU_SRL; // SRA vs SRL
                    3'b010: alu_ctrl = ALU_SLT;   // signed
                    3'b011: alu_ctrl = ALU_SLTU;  // unsigned
                    default: alu_ctrl = ALU_ADD;
                endcase
            end

            2'b11: begin
                // I-type ALU ops
                case (funct3)
                    3'b000: alu_ctrl = ALU_ADD;  // ADDI
                    3'b111: alu_ctrl = ALU_AND;  // ANDI
                    3'b110: alu_ctrl = ALU_OR;   // ORI
                    3'b100: alu_ctrl = ALU_XOR;  // XORI
                    3'b001: alu_ctrl = ALU_SLL;  // SLLI (check funct7 in decode for legality)
                    3'b101: alu_ctrl = (funct7 == 7'b0100000) ? ALU_SRA : ALU_SRL; // SRAI/SRLI
                    3'b010: alu_ctrl = ALU_SLT;   // SLTI
                    3'b011: alu_ctrl = ALU_SLTU;  // SLTIU
                    default: alu_ctrl = ALU_ADD;
                endcase
            end

            default: alu_ctrl = ALU_ADD;
        endcase
    end
endmodule
