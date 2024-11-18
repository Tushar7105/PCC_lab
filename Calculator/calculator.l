%{ #include<stdio.h> 
#include "calculator.tab.h" 
extern int yylval; 
%}
space " " 
%% 
[0-9]+ {
yylval = atoi(yytext);
return NUMBER; 
}

{space} ;
[\t] ;
[\n] return 0;
. return yytext[0]; 
%%

int yywrap() { 
    return 1;
}