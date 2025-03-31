// ALU Module
module ALU (
    input [3:0] A,        // Operand A
    input [3:0] B,        // Operand B
    input [2:0] ALU_Op,   // ALU Operation Code
    output reg [3:0] ALU_Result, // ALU Result
    output reg Zero       // Zero Flag
);
    always @(*) begin
        case (ALU_Op)
            3'b000: ALU_Result = A + B;     // Addition
            3'b001: ALU_Result = A - B;     // Subtraction
            3'b010: ALU_Result = A & B;     // AND
            3'b011: ALU_Result = A | B;     // OR
            3'b100: ALU_Result = A ^ B;     // XOR
            default: ALU_Result = 4'b0000;  // Default
        endcase
        Zero = (ALU_Result == 0); // Set Zero Flag
    end
endmodule

// Register File Module
module RegisterFile (
    input clk,                   // Clock
    input [1:0] ReadReg1,        // Address of Register 1
    input [1:0] ReadReg2,        // Address of Register 2
    input [1:0] WriteReg,        // Address to Write
    input [3:0] WriteData,       // Data to Write
    input RegWrite,              // Write Enable Signal
    output [3:0] ReadData1,      // Data from Register 1
    output [3:0] ReadData2       // Data from Register 2
);
    reg [3:0] registers [3:0];   // 4 registers, 4 bits each

    // Read data
    assign ReadData1 = registers[ReadReg1];
    assign ReadData2 = registers[ReadReg2];

    // Write data
    always @(posedge clk) begin
        if (RegWrite) registers[WriteReg] <= WriteData;
    end
endmodule

// Simple CPU Module
module SimpleCPU (
    input clk,            // Clock
    input rst,            // Reset
    input [15:0] Instr,   // Instruction
    output Zero           // Zero Flag
);
    wire [1:0] SrcA, SrcB, Dest;
    wire [3:0] DataA, DataB, ALU_Result;
    wire [3:0] Imm;
    wire [2:0] ALU_Op;
    wire RegWrite;

    // Decode instruction
    assign SrcA = Instr[15:14];
    assign SrcB = Instr[13:12];
    assign Dest = Instr[11:10];
    assign ALU_Op = Instr[9:7];
    assign Imm = Instr[6:3];
    assign RegWrite = Instr[2];

    // Instantiate Register File
    RegisterFile rf (
        .clk(clk),
        .ReadReg1(SrcA),
        .ReadReg2(SrcB),
        .WriteReg(Dest),
        .WriteData(ALU_Result),
        .RegWrite(RegWrite),
        .ReadData1(DataA),
        .ReadData2(DataB)
    );

    // Instantiate ALU
    ALU alu (
        .A(DataA),
        .B(DataB),
        .ALU_Op(ALU_Op),
        .ALU_Result(ALU_Result),
        .Zero(Zero)
    );
endmodule

module TestBench;
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] Opcode;
    wire [3:0] Result;
    wire Cout;

    // Instantiate the ALU module
    ALU uut (
        .A(A),
        .B(B),
        .ALU_Op(Opcode),
        .ALU_Result(Result),
        .Zero(Cout)
    );

    initial begin
        // Setup GTKWave
        $dumpfile("ALU4Bit.vcd");
        $dumpvars(0, TestBench);

        // Monitor output in the desired format
        $monitor("Time: %0t | A: %b | B: %b | Opcode: %b | Result: %b | Cout: %b",
                 $time, A, B, Opcode, Result, Cout);

        // Test cases
        A = 4'b0101; B = 4'b0011; Opcode = 3'b000; #10; // Addition
        A = 4'b0101; B = 4'b0011; Opcode = 3'b001; #10; // Subtraction
        A = 4'b0101; B = 4'b0011; Opcode = 3'b010; #10; // AND
        A = 4'b0101; B = 4'b0011; Opcode = 3'b011; #10; // OR
        A = 4'b0101; B = 4'b0011; Opcode = 3'b100; #10; // XOR
        A = 4'b0101; B = 4'bxxxx; Opcode = 3'b101; #10; // NOT (on A)
        A = 4'bxxxx; B = 4'b0011; Opcode = 3'b110; #10; // Pass-through B
        A = 4'b0101; B = 4'bxxxx; Opcode = 3'b111; #10; // Pass-through A

        // End simulation
        $finish;
    end
endmodule
