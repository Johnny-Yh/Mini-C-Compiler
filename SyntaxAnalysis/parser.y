%{
//int yylineno;
%}

%token ELSE IF RETURN INT VOID WHILE ID NUM OP CP OB CB OC CC COMMA SEMI ADD SUB MUL DIV
%right ASSIGN
%nonassoc LT LE GT GE EQ NE
%nonassoc THEN
%nonassoc ELSE
%error-verbose

%%
 
program
    :declaration_list
    ;

declaration_list
    :declaration_list declaration
    |declaration
    ;

declaration
    :var_declaration
    |fun_declaration
    ;

var_declaration
    :type_specifier id SEMI
    |type_specifier id OB NUM CB SEMI
    ;

type_specifier
    :INT
    |VOID
    ;

fun_declaration
    :type_specifier id OP params CP
    |compound_stmt
    ;

params
    :params_list
    |VOID
    ;

params_list
    :params_list COMMA param
    |param
    ;

param
    :type_specifier id
    |type_specifier id OB CB
    ;

compound_stmt
    :OC local_declarations statement_list CC
    ;

local_declarations
    :local_declarations var_declaration
    |empty
    ;

statement_list
    :statement_list statement
    |empty
    ;

statement
    :expression_stmt
    |compound_stmt
    |selection_stmt
    |iteration_stmt
    |return_stmt
    ;

expression_stmt
    :expression SEMI
    |SEMI
    ;

selection_stmt
    :IF OP expression CP statement  %prec THEN
    |IF OP expression CP statement ELSE statement 
    ;

iteration_stmt
    :WHILE OP expression CP statement
    ;

return_stmt
    :RETURN SEMI
    |RETURN expression SEMI
    ;

expression
    :var ASSIGN expression
    |simple_expression
    ;

var
    :id
    |id OB expression CB
    ;

simple_expression
    :additive_expression relop additive_expression
    |additive_expression
    ;

relop
    :LE
    |LT
    |GT
    |GE
    |EQ
    |NE
    ;

additive_expression
    :additive_expression addop term
    |term
    ;

addop
    :ADD
    |SUB
    ;

term
    :term mulop factor
    |factor
    ;

mulop
    :MUL
    |DIV
    ;

factor
    :OP expression CP
    |var
    |call
    |NUM
    ;

call
    :id OP args CP
    ;

args
    :arg_list
    |empty
    ;

arg_list
    :arg_list COMMA expression
    |expression

id
    :ID
    ;

empty
    ://empty
    ;
%%


#include "lex.yy.c"
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[])
{
    //yydebug = 1;
    //编译时加上-DYYDEBUG=1参数可以查看规约动作
    yyin = fopen(argv[1], "r");
    if(!yyparse())
		printf("语法分析完成!\n");
	else
		printf("语法分析失败!\n");
	fclose(yyin);
    return 0;
}

void yyerror(const char* msg)
{
    printf("出现错误: %s 行号:%d\n", msg, yylineno);
}


