#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100
#define MAX_INST 100
#define MAX_LINE_LENGTH 100

typedef struct {
    char label[10];
    int address;
} Symbol;

typedef struct {
    char mnemonic[10];
    int opcode;
} Instruction;

Symbol symbolTable[MAX_SYMBOLS];
Instruction instructionSet[MAX_INST];
int symbolCount = 0;
int instructionCount = 0;
int locationCounter = 0;

// Initialize the instruction set with mnemonics and their opcodes
void initializeInstructions() {
    strcpy(instructionSet[0].mnemonic, "MOV");
    instructionSet[0].opcode = 0x01;

    strcpy(instructionSet[1].mnemonic, "ADD");
    instructionSet[1].opcode = 0x02;

    instructionCount = 2;
}

// Add a symbol (label) to the symbol table
void addSymbol(char *label, int address) {
    strcpy(symbolTable[symbolCount].label, label);
    symbolTable[symbolCount].address = address;
    symbolCount++;
}

// Get the address of a symbol (label) from the symbol table
int getSymbolAddress(char *label) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].label, label) == 0) {
            return symbolTable[i].address;
        }
    }
    return -1; // Return -1 if the label is not found
}

// Get the opcode for a given mnemonic from the instruction set
int getOpcode(char *mnemonic) {
    for (int i = 0; i < instructionCount; i++) {
        if (strcmp(instructionSet[i].mnemonic, mnemonic) == 0) {
            return instructionSet[i].opcode;
        }
    }
    return -1; // Return -1 if the mnemonic is not found
}

// First pass: Build the symbol table
void firstPass(FILE *sourceFile) {
    char line[MAX_LINE_LENGTH];
    char label[10], opcode[10];

    while (fgets(line, sizeof(line), sourceFile)) {
        if (sscanf(line, "%s %s", label, opcode) == 2) { 
            // Line contains both a label and an opcode
            addSymbol(label, locationCounter);
            locationCounter += 1; // Increment location counter for each instruction
        } else if (sscanf(line, "%s", opcode) == 1) { 
            // Line contains only an opcode
            locationCounter += 1; // Increment location counter for the instruction
        }
    }
}

// Second pass: Generate object code
void secondPass(FILE *sourceFile, FILE *objectFile) {
    char line[MAX_LINE_LENGTH];
    char label[10], opcode[10];

    rewind(sourceFile); // Start reading the source file from the beginning
    while (fgets(line, sizeof(line), sourceFile)) {
        if (sscanf(line, "%s %s", label, opcode) == 2) { 
            // Line contains both a label and an opcode
            int instructionOpcode = getOpcode(opcode);
            if (instructionOpcode != -1) {
                fprintf(objectFile, "Address: %04X, Opcode: %02X\n", getSymbolAddress(label), instructionOpcode);
            } else {
                fprintf(objectFile, "Error: Invalid instruction %s\n", opcode);
            }
        } else if (sscanf(line, "%s", opcode) == 1) { 
            // Line contains only an opcode
            int instructionOpcode = getOpcode(opcode);
            if (instructionOpcode != -1) {
                fprintf(objectFile, "Address: %04X, Opcode: %02X\n", locationCounter, instructionOpcode);
            } else {
                fprintf(objectFile, "Error: Invalid instruction %s\n", opcode);
            }
        }
    }
}

// Main function
int main() {
    FILE *sourceFile = fopen("input.txt", "r");
    if (!sourceFile) {
        perror("Failed to open source file");
        return 1;
    }

    FILE *objectFile = fopen("output.txt", "w");
    if (!objectFile) {
        perror("Failed to open object file");
        fclose(sourceFile);
        return 1;
    }

    // Initialize the instruction set
    initializeInstructions();

    // Perform the first pass to build the symbol table
    firstPass(sourceFile);

    // Perform the second pass to generate object code
    secondPass(sourceFile, objectFile);

    // Close the files
    fclose(sourceFile);
    fclose(objectFile);

    printf("Assembly completed. Check output.txt for object code.\n");
    return 0;
}
