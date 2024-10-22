%{
#include <stdio.h> int yylex(void);
int yyerror(const char *s); int success = 1;
%}
%token int_const char_const float_const id string storage_const type_const qual_const struct_const enum_const DEFINE
%token IF FOR DO WHILE BREAK SWITCH CONTINUE RETURN CASE DEFAULT GOTO SIZEOF PUNC or_const and_const eq_const shift_const rel_const inc_const
%token point_const ELSE HEADER
%left '+' '-'
%left '*' '/'
%right UMINUS %nonassoc THEN ELSE
%start program_unit %%
/* Program Unit */ program_unit
: HEADER program_unit
| DEFINE primary_exp program_unit
| translation_unit ;
/* Translation Unit */ translation_unit
: external_decl
| translation_unit external_decl ;
/* External Declaration */ external_decl
: function_definition | decl
 ;
/* Function Definition */ function_definition
: decl_specs declarator compound_stat ;
/* Declaration */ decl
: decl_specs init_declarator_list ';' | decl_specs ';'
;
/* Declaration List */ decl_list
: decl
| decl_list decl ;
/* Declaration Specifications */ decl_specs
: storage_class_spec decl_specs
| storage_class_spec
| type_spec decl_specs
| type_spec
| type_qualifier decl_specs
| type_qualifier
| struct_or_union_spec
| enum_spec
;
/* Storage Class Specification */ storage_class_spec
: storage_const | type_const
;
/* Type Specification */ type_spec
: type_const
| struct_or_union_spec
| enum_spec
| /* Add other type specifications like 'int', 'float', etc. */ ;

 /* Type Qualifier */ type_qualifier
: qual_const ;
/* Struct or Union Specification */ struct_or_union_spec
: struct_or_union id '{' struct_decl_list '}' ';' | struct_or_union id ';'
;
/* Struct or Union */ struct_or_union
: struct_const
;
/* Struct Declaration List */ struct_decl_list
: struct_decl
| struct_decl_list struct_decl ;
/* Struct Declaration */ struct_decl
: spec_qualifier_list struct_declarator_list ';' ;
/* Specifier Qualifier List */ spec_qualifier_list
: type_spec spec_qualifier_list
| type_qualifier spec_qualifier_list
| type_spec
| type_qualifier ;
/* Struct Declarator List */ struct_declarator_list
: struct_declarator
| struct_declarator_list ',' struct_declarator ;
/* Struct Declarator */ struct_declarator

 : declarator
| declarator '=' initializer ;
/* Enum Specification */ enum_spec
: enum_const id '{' enumerator_list '}' ';'
| enum_const '{' enumerator_list '}' ';'
| enum_const id ';' ;
/* Enumerator List */ enumerator_list
: enumerator
| enumerator_list ',' enumerator ;
/* Enumerator */ enumerator
: id
| id '=' conditional_exp ;
/* Init Declarator List */ init_declarator_list
: init_declarator
| init_declarator_list ',' init_declarator ;
/* Init Declarator */ init_declarator
: declarator
| declarator '=' initializer ;
/* Declarator */ declarator
: pointer direct_declarator | direct_declarator
;
/* Direct Declarator */ direct_declarator
: id

 | '(' declarator ')'
| direct_declarator '[' conditional_exp ']'
| direct_declarator '[' ']'
| direct_declarator '(' param_list ')'
| direct_declarator '(' id_list ')'
| direct_declarator '(' ')' ;
/* Pointer */ pointer
: '*' type_qualifier_list
| '*'
| '*' type_qualifier_list pointer
| '*' pointer ;
/* Type Qualifier List */ type_qualifier_list
: type_qualifier
| type_qualifier_list type_qualifier ;
/* Parameter List */ param_list
: param_decl
| param_list ',' param_decl ;
/* Parameter Declaration */ param_decl
: decl_specs declarator
| decl_specs abstract_declarator
| decl_specs ;
/* Identifier List */ id_list
: id
| id_list ',' id ;
/* Initializer */ initializer
: assignment_exp

 | '{' initializer_list '}'
| '{' initializer_list ',' '}' ;
/* Initializer List */ initializer_list
: initializer
| initializer_list ',' initializer ;
/* Type Name */ type_name
: spec_qualifier_list abstract_declarator | spec_qualifier_list
;
/* Abstract Declarator */ abstract_declarator
: pointer
| pointer direct_abstract_declarator
| direct_abstract_declarator ;
/* Direct Abstract Declarator */ direct_abstract_declarator
: '(' abstract_declarator ')'
| '[' conditional_exp ']'
| '[' ']'
| '(' param_list ')'
| '(' ')'
| direct_abstract_declarator '[' conditional_exp ']'
| direct_abstract_declarator '[' ']'
| direct_abstract_declarator '(' param_list ')'
| direct_abstract_declarator '(' ')' ;
/* Statement */ stat
: labeled_stat
| exp_stat
| compound_stat | selection_stat
| iteration_stat
| jump_stat

 ;
/* Labeled Statement */ labeled_stat
: id ':' stat
| CASE int_const ':' stat
| DEFAULT ':' stat ;
/* Expression Statement */ exp_stat
: exp ';' | ';'
;
/* Compound Statement */ compound_stat
: '{' decl_list stat_list '}'
| '{' stat_list '}'
| '{' decl_list '}'
| '{' '}'
;
/* Statement List */ stat_list
: stat
| stat_list stat ;
/* Selection Statement */ selection_stat
: IF '(' exp ')' stat %prec THEN
| IF '(' exp ')' stat ELSE stat
| SWITCH '(' exp ')' stat ;
/* Iteration Statement */ iteration_stat
: WHILE '(' exp ')' stat
| DO stat WHILE '(' exp ')' ';'
| FOR '(' exp ';' exp ';' exp ')' stat | FOR '(' exp ';' exp ';' ')' stat
| FOR '(' exp ';' ';' exp ')' stat

 | FOR '(' exp ';' ';' ')' stat
| FOR '(' ';' exp ';' exp ')' stat
| FOR '(' ';' exp ';' ')' stat
| FOR '(' ';' ';' exp ')' stat
| FOR '(' ';' ';' ')' stat ;
/* Jump Statement */ jump_stat
: GOTO id ';'
| CONTINUE ';'
| BREAK ';'
| RETURN exp ';'
| RETURN ';' ;
/* Expression */ exp
: assignment_exp
| exp ',' assignment_exp ;
/* Assignment Expression */ assignment_exp
: conditional_exp
| unary_exp assignment_operator assignment_exp ;
/* Assignment Operator */ assignment_operator
: '='
| PUNC ;
/* Conditional Expression */ conditional_exp
: logical_or_exp
| logical_or_exp '?' exp ':' conditional_exp ;
/* Logical OR Expression */ logical_or_exp
: logical_and_exp
| logical_or_exp or_const logical_and_exp

 ;
/* Logical AND Expression */ logical_and_exp
: inclusive_or_exp
| logical_and_exp and_const inclusive_or_exp ;
/* Inclusive OR Expression */ inclusive_or_exp
: exclusive_or_exp
| inclusive_or_exp '|' exclusive_or_exp ;
/* Exclusive OR Expression */ exclusive_or_exp
: and_exp
| exclusive_or_exp '^' and_exp ;
/* AND Expression */ and_exp
: equality_exp
| and_exp '&' equality_exp ;
/* Equality Expression */ equality_exp
: relational_exp
| equality_exp eq_const relational_exp ;
/* Relational Expression */ relational_exp
: shift_expression
| relational_exp '<' shift_expression
| relational_exp '>' shift_expression
| relational_exp rel_const shift_expression ;
/* Shift Expression */ shift_expression
: additive_exp
| shift_expression shift_const additive_exp

 ;
/* Additive Expression */ additive_exp
: mult_exp
| additive_exp '+' mult_exp
| additive_exp '-' mult_exp ;
/* Multiplicative Expression */ mult_exp
: cast_exp
| mult_exp '*' cast_exp
| mult_exp '/' cast_exp
| mult_exp '%' cast_exp ;
/* Cast Expression */ cast_exp
: unary_exp
| '(' type_name ')' cast_exp ;
/* Unary Expression */ unary_exp
: postfix_exp
| inc_const unary_exp
| unary_operator cast_exp
| SIZEOF unary_exp
| SIZEOF '(' type_name ')' ;
/* Unary Operator */ unary_operator
: '&'
| '*'
| '+'
| '-'
| '~'
| '!' ;
/* Postfix Expression */ postfix_exp

 : primary_exp
| postfix_exp '[' exp ']'
| postfix_exp '(' argument_exp_list ')'
| postfix_exp '(' ')'
| postfix_exp '.' id
| postfix_exp point_const id
| postfix_exp inc_const ;
/* Primary Expression */ primary_exp
: id
| consts
| string
| '(' exp ')' ;
/* Argument Expression List */ argument_exp_list
: assignment_exp
| argument_exp_list ',' assignment_exp ;
/* Constants */ consts
: int_const
| char_const
| float_const
| enum_const ;
%%
/* Main Function */ int main()
{
yyparse(); if(success)
printf("Parsing Successful\n"); return 0;
}
/* Error Handling */
int yyerror(const char *msg)

{
extern int yylineno;
printf("Parsing Failed\nLine Number: %d %s\n", yylineno, msg); success = 0;
return 0;
}