%{

#include <stdio.h>
#include <string.h>

%}

%%

"int"|"float"|"return"|"if"|"else"|"return"|"main" { printf("KEYWORD: %s\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*             { printf("IDENTIFIER: %s\n", yytext); }

[0-9]+                             { printf("CONSTANT: %s\n", yytext); }

\"[^\(\)\{\}\"]*\"                   { printf("LITERAL: %s\n", yytext); }

"+"|"-"|"*"|"/"|"="|"=="|"<"|">"    { printf("OPERATOR: %s\n", yytext); }

[ \t\n]+                           { /* Ignore whitespace */ }

.                                  { printf("UNKNOWN: %s\n", yytext); }

%%

int main() {
    yylex(); /* Call the lexical analyzer */
    return 0;
}

int yywrap() {
    return 1;
}