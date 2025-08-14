module alu (
    input  wire [31:0] A,           // Operand A
    input  wire [31:0] B,           // Operand B (post ALUSrc mux)
    input  wire [3:0]  alu_ctrl,    // From alu_control
    output reg  [31:0] result,      // ALU result
    // Flags for branch control (signed semantics)
    output wire        zero_flag,           // (A == B) in practice when SUB or general compare
    output wire        less_than_flag,      // A < B (signed)
    output wire        greater_equal_flag   // A >= B (signed)
);

    // Decode constants (must match alu_control)
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
    // localparam ALU_PASSB = 4'b1010;

    wire signed [31:0] As = $signed(A);
    wire signed [31:0] Bs = $signed(B);

    // Comparators (computed unconditionally; cheap and handy)
    wire eq    = (A == B);
    wire lt_s  = (As < Bs);
    wire ge_s  = (As >= Bs);
    wire lt_u  = (A < B);
    // wire ge_u  = (A >= B);

    // Shamt is lower 5 bits of B for RV32
    wire [4:0] shamt = B[4:0];

    always @(*) begin
        case (alu_ctrl)
            ALU_ADD:  result = A + B;
            ALU_SUB:  result = A - B;
            ALU_AND:  result = A & B;
            ALU_OR:   result = A | B;
            ALU_XOR:  result = A ^ B;
            ALU_SLL:  result = A << shamt;
            ALU_SRL:  result = A >> shamt;
            ALU_SRA:  result = As >>> shamt;   // arithmetic right shift
            ALU_SLT:  result = lt_s  ? 32'd1 : 32'd0; // signed set-less-than
            ALU_SLTU: result = lt_u  ? 32'd1 : 32'd0; // unsigned set-less-than
            // ALU_PASSB: result = B;
            default:  result = 32'd0;
        endcase
    end

    // Flags used by branch unit
    assign zero_flag          = eq;
    assign less_than_flag     = lt_s;
    assign greater_equal_flag = ge_s;

endmodule