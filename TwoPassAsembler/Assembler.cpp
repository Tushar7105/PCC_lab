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

void initializeInstructions() {
    strcpy(instructionSet[0].mnemonic, "MOV");
    instructionSet[0].opcode = 0x01; 

    strcpy(instructionSet[1].mnemonic, "ADD");
    instructionSet[1].opcode = 0x02; 

    
    instructionCount = 2;
}

void addSymbol(char *label, int address) {
    strcpy(symbolTable[symbolCount].label, label);
    symbolTable[symbolCount].address = address;
    symbolCount++;
}

int getSymbolAddress(char *label) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].label, label) == 0) {
            return symbolTable[i].address;
        }
    }
    return -1; 
}

void firstPass(FILE *sourceFile) {
    char line[MAX_LINE_LENGTH];
    char label[10], opcode[10];

    while (fgets(line, sizeof(line), sourceFile)) {

        if (sscanf(line, "%s %s", label, opcode) == 2) {
            addSymbol(label, locationCounter);
            locationCounter += 1; 
        } else if (sscanf(line, "%s", opcode) == 1) {
            locationCounter += 1; 
        }
    }
}

void secondPass(FILE *sourceFile, FILE *objectFile) {
    char line[MAX_LINE_LENGTH];
    char label[10], opcode[10];

    rewind(sourceFile); 
    while (fgets(line, sizeof(line), sourceFile)) {
        if (sscanf(line, "%s %s", label, opcode) == 2) {
            int address = getSymbolAddress(label);
 
            if (address != -1) {
                fprintf(objectFile, "Address: %04X, Opcode: %02X\n", address, getSymbolAddress(opcode));
            }
        } else if (sscanf(line, "%s", opcode) == 1) {

            fprintf(objectFile, "Address: %04X, Opcode: %02X\n", locationCounter, getSymbolAddress(opcode));
        }
    }
}

int main() {
    FILE *sourceFile = fopen("/Users/tushar./Desktop/PCC lab/TwoPassAsembler/input", "r");
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

    initializeInstructions();
    firstPass(sourceFile);
    secondPass(sourceFile, objectFile);

    fclose(sourceFile);
    fclose(objectFile);
    
    printf("Assembly completed. Check output.obj for object code.\n");
    return 0;
}