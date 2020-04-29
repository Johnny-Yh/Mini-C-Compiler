%{
#include <stdio.h>
int lineno=1;
void comment();
%}

%%
[ \t\r]+ {}
[\n] {lineno++;}
"/*" {comment();printf("一段注释\n");}
"else" {printf("%s\t\t关键字\n",yytext);}
"if" {printf("%s\t\t关键字\n",yytext);}
"int" {printf("%s\t\t关键字\n",yytext);}
"return" {printf("%s\t\t关键字\n",yytext);} 
"void" {printf("%s\t\t关键字\n",yytext);}
"while" {printf("%s\t\t关键字\n",yytext);}
"=" {printf("%s\t\t操作符\n",yytext);}
">" {printf("%s\t\t操作符\n",yytext);}
">=" {printf("%s\t\t操作符\n",yytext);}
"<" {printf("%s\t\t操作符\n",yytext);}
"<=" {printf("%s\t\t操作符\n",yytext);}
"==" {printf("%s\t\t操作符\n",yytext);}
"!=" {printf("%s\t\t操作符\n",yytext);}
"(" {printf("%s\t\t特殊符号\n",yytext);}
")" {printf("%s\t\t特殊符号\n",yytext);}
"[" {printf("%s\t\t特殊符号\n",yytext);}
"]" {printf("%s\t\t特殊符号\n",yytext);}
"{" {printf("%s\t\t特殊符号\n",yytext);}
"}" {printf("%s\t\t特殊符号\n",yytext);}
"," {printf("%s\t\t特殊符号\n",yytext);}
";" {printf("%s\t\t特殊符号\n",yytext);}
"+" {printf("%s\t\t操作符\n",yytext);}
"-" {printf("%s\t\t操作符\n",yytext);}
"*" {printf("%s\t\t操作符\n",yytext);}
"/" {printf("%s\t\t操作符\n",yytext);}
"main(void)" {printf("%s\t主函数\n",yytext);}
[A-Za-z]+ {printf("%s\t\t标识符\n",yytext);}
[0-9]+ {printf("%s\t\t整数\n",yytext);}
. {printf("unknown symbol detected!\n");}

%%
void comment()//读取多行注释
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
int main()
{
	int scan;
	yyin = fopen("test.c","r");
	scan = yylex();
}
int yywrap()
{
	return 1;
}
