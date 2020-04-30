%{
#include <stdio.h>
%}
%option yylineno

%%


[ \t\n\r]+ {}
"/*"  {comment();}
"else" {return ELSE;}
"if" {return IF;}
"int" {return INT;}
"return" {return RETURN;} 
"void" {return VOID;}
"while" {return WHILE;}
"=" {return ASSIGN;}
">" {return GT;}
">=" {return GE;}
"<" {return LT;}
"<=" {return LE;}
"==" {return EQ;}
"!=" {return NE;}
"(" {return OP;}
")" {return CP;}
"[" {return OB;}
"]" {return CB;}
"{" {return OC;}
"}" {return CC;}
"," {return COMMA;}
";" {return SEMI;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
[A-Za-z]+ {return ID;}
[0-9]+ {return NUM;}
. {printf("unknown symbol detected!");}

%%

comment()
{
	char c, c1;
loop:
	while ((c = input()) != '*' && c != 0);
	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}
}

yywrap()
{
	return(1);
}