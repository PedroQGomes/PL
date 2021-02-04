CFLAGS=$(shell pkg-config --cflags glib-2.0)
LFLAGS=$(shell pkg-config --libs glib-2.0)

tojson: analisador.l gramatica.y
	flex analisador.l
	yacc gramatica.y -d
	gcc $(CFLAGS) -o tojson y.tab.c $(LFLAGS) -lm
clean:
	rm -f y.tab.c lex.yy.c y.tab.h tojson
