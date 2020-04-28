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

struct node
{
	char token[100];
    	char attr[100];
	struct node *next;
};

struct hash
{
	struct node *head;
	int count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void insertToHash(char *token, char *attr)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("-------------------------------------------------------------------");
    	printf("\nNo \t|\t符号 \t\t|\t符号类型 \t\n");
        printf("-------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\n", myNode->attr);
            		myNode = myNode->next;
        	}
	}
   	return;
}

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
			insertToHash(yytext, "关键字");
		}
		if(scan==7 && mlc==0)
		{
			printf("%s\t\t\t标识符\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "标识符");
		}
		if(scan==8 && mlc==0)
		{
			printf("%s\t\t\t注释开始\t\t\tLine %d\n", yytext, lineno);
			mlcline = lineno;
			mlc = 1;
		}
		if(scan==9 && mlc==0)
		{
			printf("\n******** ERROR!! UNMATCHED MULTILINE COMMENT END %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==9 && mlc==1)
		{
			mlc = 0;
			printf("%s\t\t\t注释结束\t\t\tLine %d\n", yytext, lineno);
		}
		if((scan>=10 && scan<=20) && mlc==0)
		{
			printf("%s\t\t\t操作符\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "操作符");
		}
		if((scan==21||scan==22||(scan>=28 && scan<=33)) && mlc==0)
		{
			printf("%s\t\t\t特殊符号\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "特殊符号");
		}
		if(scan==23 && mlc==0)
		{
			printf("%s\t\t主函数\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "标识符");
		}
		if((scan==24 || scan==25) && mlc==0)
		{
			printf("%s\t\t\t输入输出函数\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "输入输出函数");
		}
		if(scan==26 && mlc==0)
		{
			printf("%s\t\t\t整数\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "整数");
		}

		if(scan==34 && mlc==0)
		{
			printf("%s\t\t\t数组\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "数组");
		}
		if(scan==35 && mlc==0)
		{
			printf("%s\t\t\t自定义函数\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "自定义函数");
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n******** ERROR!! UNMATCHED COMMENT STARTING at Line %d ********\n\n",mlcline);
	printf("\n");
	printf("\n\t**************** 符号表 ****************\t\t\n");
	display();
        printf("-------------------------------------------------------------------\n\n");
}
int yywrap()
{
	return 1;
}
