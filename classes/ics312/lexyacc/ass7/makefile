exprtoc: lex.yy.o y.tab.o
	gcc lex.yy.o y.tab.o -ll -o expretoc
lex.yy.o: lex.yy.c y.tab.h
	gcc lex.yy.c -c
y.tab.o: y.tab.c
	gcc y.tab.c -c
y.tab.h: pa7.y
	yacc -d pa7.y
lex.yy.c: pa7.l
	lex pa7.l
