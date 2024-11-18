%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();

extern FILE *yyin;  // Declare external file pointer used by Lex
%}

%token INT FLOAT IDENTIFIER NUMBER
%token ASSIGN PLUS MINUS MUL DIV SEMICOLON LPAREN RPAREN

%%
program:
    program statement
    | /* empty */
    ;

statement:
    declaration
    | assignment
    | expression SEMICOLON
    ;

declaration:
    type IDENTIFIER SEMICOLON
    ;

type:
    INT
    | FLOAT
    ;

assignment:
    IDENTIFIER ASSIGN expression SEMICOLON
    ;

expression:
    expression PLUS expression
    | expression MINUS expression
    | expression MUL expression
    | expression DIV expression
    | LPAREN expression RPAREN
    | NUMBER
    | IDENTIFIER
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
        exit(1);
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Error opening file");
        exit(1);
    }

    yyin = file;  // Set Lex to read from the file
    if (yyparse() == 0) { // Parsing successful
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }

    fclose(file); // Close the file after parsing
    return 0;
}
