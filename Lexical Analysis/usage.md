Windows使用方法：
安装flex，并把felx的bin目录添加到环境变量中
安装gcc，并把gcc的bin目录添加到环境变量
在CMD窗口：
felx lexer.l
gcc lex.yy.c
a.exe test.c

Linux使用方法：
lex lexer.l
cc lex.yy.c
./a.out