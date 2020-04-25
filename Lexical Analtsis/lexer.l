%{
int lineno = 1;
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define ELSE 1
#define IF 2
#define INT 3
#define RETURN 4
#define VOID 5
#define WHILE 6
#define ID 7
#define MLCS 8
#define MLCE 9
#define LEQ 10
#define GEQ 11
#define EQEQ 12
#define NEQ 13
#define ASSIGN 14
#define PLUS 15
#define SUB 16
#define MULT 17
#define DIV 18
#define LESSER 19
#define GREATER 20
#define COMMA 21
#define SEMI 22
#define MAIN 23
#define OUTPUT 24
#define INPUT 25
#define NUMBER 26
#define OBO 28
#define OBC 29
#define CBO 30
#define CBC 31
#define OB 32
#define CB 33

#define ARR 34
#define FUNC 35
%}

letter [A-Za-z]
digit [0-9]
space [ ]
tab [	]
line [\n]


%%
{space}* {}
{tab}* {}
{line} {lineno++;}

else return ELSE;
if return IF;
int return INT;
return return RETURN;
void return VOID;
while return WHILE;
output return OUTPUT;


{letter}+ return ID;
{digit}+ return NUMBER;

"/*" return MLCS;
"*/" return MLCE;
"<=" return LEQ;
">=" return GEQ;
"==" return EQEQ;
"!=" return NEQ;
"=" return ASSIGN;
"+" return PLUS;
"-" return SUB;
"*" return MULT;
"/" return DIV;
"<" return LESSER;
">" return GREATER;
"," return COMMA;
";" return SEMI;
"main(void)" return MAIN;
"input()" return INPUT;

"(" return OBO;
")" return OBC;
"{" return CBO;
"}" return CBC;
"[" return OB;
"]" return CB;

{letter}({letter}|{digit})*\[{digit}*\] return ARR;
{letter}({letter}|{digit})*\(({letter}|{digit}|{space})*\) return FUNC;
%%

int main()
{
	int scan, slcline=0, mlc=0, mlcline=0;
	yyin = fopen("test.c","r");
	printf("\n\n");
	scan = yylex();
	while(scan)
	{
		if(lineno == slcline)
		{
			scan = yylex();
			continue;
		}
		if((scan>=1 && scan<=6) && mlc==0)
		{
			printf("%s\t\t\t关键字\t\t\t\tLine %d\n", yytext, lineno);
		}
		if(scan==7 && mlc==0)
		{
			printf("%s\t\t\t标识符\t\t\t\tLine %d\n", yytext, lineno);
		}
		if(scan==8 && mlc==0)
		{
			printf("%s\t\t\t注释开始\t\t\tLine %d\n", yytext, lineno);
			mlcline = lineno;
			mlc = 1;
		}
		if(scan==9 && mlc==0)
		{
			printf("\n******** 不匹配的注释！ at Line %d ********\n\n", lineno);
		}
		if(scan==9 && mlc==1)
		{
			mlc = 0;
			printf("%s\t\t\t注释结束\t\t\tLine %d\n", yytext, lineno);
		}
		if((scan>=10 && scan<=20) && mlc==0)
		{
			printf("%s\t\t\t操作符\t\t\t\tLine %d\n", yytext, lineno);
			
		}
		if((scan==21||scan==22||(scan>=28 && scan<=33)) && mlc==0)
		{
			printf("%s\t\t\t特殊符号\t\t\tLine %d\n", yytext, lineno);
			
		}
		if(scan==23 && mlc==0)
		{
			printf("%s\t\t主函数\t\t\t\tLine %d\n", yytext, lineno);
			
		}
		if((scan==24 || scan==25) && mlc==0)
		{
			printf("%s\t\t\t输入输出函数\t\t\tLine %d\n", yytext, lineno);
		}
		if(scan==26 && mlc==0)
		{
			printf("%s\t\t\t整数\t\t\t\tLine %d\n", yytext, lineno);
		}

		if(scan==34 && mlc==0)
		{
			printf("%s\t\t\t数组\t\t\t\tLine %d\n", yytext, lineno);
		}
		if(scan==35 && mlc==0)
		{
			printf("%s\t\t\t自定义函数\t\t\tLine %d\n", yytext, lineno);
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n******** 不匹配的注释！ at Line %d ********\n\n",mlcline);
}
int yywrap()
{
	return 1;
}
