module control_unit(
    input  [6:0] opcode,  // Main instruction opcode
    output reg [1:0] ALUOp,  // ALU operation selector
    output reg MemRead, MemWrite,
    output reg RegWrite, MemToReg,
    output reg Branch, ALUSrc
);

    always @(*) begin
        // Default values: NOP behavior
        ALUOp     = 2'b00;
        MemRead   = 0;
        MemWrite  = 0;
        RegWrite  = 0;
        MemToReg  = 0;
        Branch    = 0;
        ALUSrc    = 0;

        case (opcode)
            7'b0110011: begin // R-type
                ALUOp     = 2'b10;
                RegWrite  = 1;
                ALUSrc    = 0; // Both operands from registers
            end

            7'b0010011: begin // I-type (ADDI, ORI, ANDI, etc.)
                ALUOp     = 2'b11;
                RegWrite  = 1;
                ALUSrc    = 1; // Second operand from immediate
            end

            7'b0000011: begin // Load
                ALUOp     = 2'b00; // For address calculation
                MemRead   = 1;
                MemToReg  = 1;
                RegWrite  = 1;
                ALUSrc    = 1;
            end

            7'b0100011: begin // Store
                ALUOp     = 2'b00; // Address calculation
                MemWrite  = 1;
                ALUSrc    = 1;
            end

            7'b1100011: begin // Branch
                ALUOp     = 2'b01; // Branch compare
                Branch    = 1;
                ALUSrc    = 0;
            end

            default: begin
                // NOP or unsupported opcode
            end
        endcase
    end

endmodule
