%{
#include "y.tab.h"
%}

%%

"int"            { return INT; }
"float"          { return FLOAT; }
"="              { return ASSIGN; }
[0-9]+           { yylval = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return MUL; }
"/"              { return DIV; }
";"              { return SEMICOLON; }
"("              { return LPAREN; }
")"              { return RPAREN; }
[ \t\n]          { /* Ignore whitespace */ }
.                { return yytext[0]; } /* For other single characters */

%%

int yywrap() {
    return 1;
}
