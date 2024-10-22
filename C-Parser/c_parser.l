%option yylineno %option noyywrap
/* Definition Section */ %{
#include <stdio.h> #include "parser.tab.h" %}
/* Rules Section */ %%
/* Preprocessor directives */
"#include"[ \t]+<([a-zA-Z_][a-zA-Z0-9_.]*)> "#define"[ \t]+([a-zA-Z_][a-zA-Z0-9]*)
/* Storage class specifiers */ "auto"|"register"|"static"|"extern"|"typedef"
{ return HEADER; } { return DEFINE; }
{ return storage_const; }
/* Type specifiers */ "void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned" { return type_const; }
/* Qualifiers */ "const"|"volatile"
/* User-defined types */ "enum"
"struct"|"union"
/* Control flow keywords */
{ return qual_const; }
{ return enum_const; } { return struct_const; }
"case" "default" "if" "switch" "else" "for" "do" "while"
{ return CASE; }
{ return DEFAULT; } { return IF; }
{ return SWITCH; } { return ELSE; }
{ return FOR; } { return DO; }
{ return WHILE; }
 "goto"
/* Control statements */ "continue"
"break"
"return"
"sizeof"
/* Logical operators */ "||"
{ return GOTO; }
{ return CONTINUE; } { return BREAK; }
{ return RETURN; } { return SIZEOF; }
{ return or_const; }
{ return and_const; }
"&&"
/* Comparison operators */
"=="|"!=" "<="|">="|"<"|">" ">>"|"<<" "++"|"--"
"->"
{ return eq_const; }
{ return rel_const; } { return shift_const; }
{ return inc_const; } { return point_const; }
/* Arithmetic and assignment operators */
[*/%&|^!~+\-] { return yytext[0]; } "+="|"-="|"*="|"/="|"%="|"<<="|">>="|"&="|"^="|"|=" { return PUNC; }
/* Constants */ [0-9]+
[0-9]+"."[0-9]+ '(\\.|[^'\\\n])' [a-zA-Z_][a-zA-Z0-9_]* \"([^\\"]|\\.)*\"
/* Comments */ "//".*
"/*"([^*]|\*+[^*/])*\*+"/"
/* Whitespace */ [ \t\n]+
/* Punctuation */ [;{}()\[\]]
{ return int_const; }
{ return float_const; }
{ return char_const; } { return id; }
{ return string; }
{ /* ignore single line comments */ }
{ /* ignore multi-line comments */ }
{ /* ignore whitespace */ }
{ return yytext[0]; }
/* Unrecognized characters */
. { printf("Unrecognized character: %s\n", yytext); }
%%

/* User Code Section */
/* The noyywrap option eliminates the need for yywrap() */
