FLEX_FILE 	= ./src/main/scanner.l
BISON_FILE	= ./src/main/parser.y
OBJS 		= ./src/main/lex.yy.o ./src/main/parser.tab.o ./src/main/main.o ./src/main/util/n_tree/n_tree.o
TMP_SRC		= ./src/main/lex.yy.c ./src/main/parser.tab.c ./src/main/parser.tab.h
OUT			= mast
CC	 	 	= gcc 
FLAGS		= -c
LFLAGS		= -lfl

all:
	bison -d $(BISON_FILE) -o ./src/main/parser.tab.c
	flex -o ./src/main/lex.yy.c $(FLEX_FILE) 
	$(MAKE) -C ./src/main/util/n_tree
	$(CC) -c ./src/main/lex.yy.c -o ./src/main/lex.yy.o
	$(CC) -c ./src/main/parser.tab.c -o ./src/main/parser.tab.o
	$(CC) -c ./src/main/main.c -o ./src/main/main.o
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

clean:
	rm -f $(OBJS) $(TMP_SRC) $(OUT) parser parser.output *.ast *.dot
	$(MAKE) -C ./src/main/util/n_tree clean

run: 
	./$(OUT)

debug:
	bison -v -d $(BISON_FILE)
	flex $(FLEX_FILE)
	$(CC) -c /src/main/lex.yy.c
	$(CC) -c /src/main/parser.tab.c
	$(CC) -c /src/main/main.c
	$(CC) -c /src/main/n_tree.cpp
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

test:
	./$(OUT) < ./src/resources/simple_test.xml
	./$(OUT) < ./src/resources/simple_test_2.xml

ast:
	./$(OUT) < ./src/resources/simple_test.xml > simple_test.ast
	./$(OUT) < ./src/resources/simple_test_2.xml > simple_test_2.ast

dot:
	sudo python3 ./txt_to_diag.py simple_test.ast simple_test.dot
	sudo python3 ./txt_to_diag.py simple_test_2.ast simple_test_2.dot
