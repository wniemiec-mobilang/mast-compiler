FLEX_FILE 	= scanner.l
BISON_FILE	= parser.y
OBJS 		= lex.yy.o parser.tab.o main.o arvore/arvore_n_aria.o
TMP_SRC		= lex.yy.c parser.tab.c parser.tab.h
OUT			= mobilang
CC	 	 	= gcc 
FLAGS		= -c
LFLAGS		= -lfl

all:
	bison -d $(BISON_FILE)
	flex $(FLEX_FILE)
	$(MAKE) -C ./arvore
	$(CC) -c lex.yy.c
	$(CC) -c parser.tab.c
	$(CC) -c main.c
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

clean:
	rm -f $(OBJS) $(TMP_SRC) $(OUT) parser parser.output
	$(MAKE) -C ./arvore clean

run: 
	./$(OUT)

debug:
	bison -v -d $(BISON_FILE)
	flex $(FLEX_FILE)
	$(CC) -c lex.yy.c
	$(CC) -c parser.tab.c
	$(CC) -c main.c
	$(CC) -c arvore/arvore_n_aria.cpp
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

test:
	./$(OUT) < test.xml
