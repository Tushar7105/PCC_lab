%{
#include<stdio.h>
int flag = 0;
extern int yylex(void);
extern void yyerror(const char *s); %}
%token NUMBER %left '+' '-'
%left '*' '/'
%left '(' ')'
%%
ArithmeticExpression: E { printf("Result = %d\n", $$);
return 0; };
E: E '*' E { $$ = $1 * $3; } | '(' E ')' { $$ = $2; }
| E '/' E { $$ = $1 / $3; }
| E '+' E { $$ = $1 + $3; } | E '-' E { $$ = $1 - $3; } | NUMBER { $$ = $1; }
;
%%
int main() {
printf("\nEnter Any Arithmetic Expression:\n"); yyparse();
if (flag == 0) {
printf("\nEntered arithmetic expression is Valid\n\n"); }
}
void yyerror(const char *s) {
printf("\nEntered arithmetic expression is Invalid\n\n"); flag = 1;
}