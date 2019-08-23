compile: parser.y projeto.l
	bison -d parser.y
	flex projeto.l
	gcc -o parser.x parser.tab.c lex.yy.c -ll 