EXEC := filtro

CXX := gcc
FLAGS := -std=c11 -g -Ofast
GLIB := `pkg-config --cflags --libs glib-2.0`
INCD := -I ../include

all:
	@flex filtro.l
	$(CXX) -o $(EXEC) commentThread.c lex.yy.c $(FLAGS) $(GLIB) $(INCD)

clean:
	rm -rf lex.yy.c $(EXEC)