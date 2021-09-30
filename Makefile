FLEX_FILE 	= scanner.l
BISON_FILE	= parser.y
OBJS 		= lex.yy.o parser.tab.o main.o arvore/arvore_n_aria.o
OUT			= mobilang
CC	 	 	= gcc 
FLAGS		= -c
LFLAGS		= -lfl

all:
	$(MAKE) -C ./arvore
	bison -d $(BISON_FILE)
	flex $(FLEX_FILE)
	$(CC) -c lex.yy.c
	$(CC) -c parser.tab.c
	$(CC) -c main.c
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

clean:
	rm -f $(OBJS) $(OUT) parser parser.output
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
	./$(OUT) < test.txt