#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_INSTRUCTIONS 5

// Define instruction structure
typedef struct {
    char opcode[10]; // Operation (ADD, SUB, AND, etc.)
    int operand1;
    int operand2;
} Instruction;

// Define pipeline registers
typedef struct {
    Instruction instr;
    int result;
    int valid;
} PipelineRegister;

// Sample instruction memory
Instruction instruction_memory[NUM_INSTRUCTIONS] = {
    {"ADD", 5, 3},
    {"SUB", 10, 4},
    {"AND", 7, 2},
    {"OR", 8, 1},
    {"XOR", 6, 3}
};

// Pipeline registers
PipelineRegister IF_ID = { {"", 0, 0}, 0, 0 };
PipelineRegister ID_EX = { {"", 0, 0}, 0, 0 };
PipelineRegister EX_WB = { {"", 0, 0}, 0, 0 };

// Fetch stage
void fetch(int pc) {
    if (pc < NUM_INSTRUCTIONS) {
        IF_ID.instr = instruction_memory[pc];
        IF_ID.valid = 1;
        printf("Fetch: %s %d, %d\n", IF_ID.instr.opcode, IF_ID.instr.operand1, IF_ID.instr.operand2);
    } else {
        IF_ID.valid = 0;
    }
}

// Decode stage
void decode() {
    if (IF_ID.valid) {
        ID_EX.instr = IF_ID.instr;
        ID_EX.valid = 1;
        printf("Decode: %s %d, %d\n", ID_EX.instr.opcode, ID_EX.instr.operand1, ID_EX.instr.operand2);
    } else {
        ID_EX.valid = 0;
    }
}

// Execute stage
void execute() {
    if (ID_EX.valid) {
        EX_WB.instr = ID_EX.instr;
        EX_WB.valid = 1;
        if (strcmp(EX_WB.instr.opcode, "ADD") == 0)
            EX_WB.result = EX_WB.instr.operand1 + EX_WB.instr.operand2;
        else if (strcmp(EX_WB.instr.opcode, "SUB") == 0)
            EX_WB.result = EX_WB.instr.operand1 - EX_WB.instr.operand2;
        else if (strcmp(EX_WB.instr.opcode, "AND") == 0)
            EX_WB.result = EX_WB.instr.operand1 & EX_WB.instr.operand2;
        else if (strcmp(EX_WB.instr.opcode, "OR") == 0)
            EX_WB.result = EX_WB.instr.operand1 | EX_WB.instr.operand2;
        else if (strcmp(EX_WB.instr.opcode, "XOR") == 0)
            EX_WB.result = EX_WB.instr.operand1 ^ EX_WB.instr.operand2;
        else
            EX_WB.result = 0;
        
        printf("Execute: %s Result = %d\n", EX_WB.instr.opcode, EX_WB.result);
    } else {
        EX_WB.valid = 0;
    }
}

int main() {
    int cycles = NUM_INSTRUCTIONS + 2; // Total cycles to execute all instructions
    for (int i = 0; i < cycles; i++) {
        printf("Cycle %d:\n", i + 1);
        execute();  // Execute the previous instruction
        decode();   // Decode the current instruction
        fetch(i);   // Fetch the next instruction
        printf("-----------------------------\n");
    }
    return 0;
}
