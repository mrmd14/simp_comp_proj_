all: comp

comp.tab.c comp.tab.h:	comp.y
	bison -t -v -d comp.y

lex.yy.c: comp.l comp.tab.h
	flex comp.l

comp: lex.yy.c comp.tab.c comp.tab.h
	gcc -o comp comp.tab.c lex.yy.c  -lm

clean:
	rm comp comp.tab.c lex.yy.c comp.tab.h comp.output
