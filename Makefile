MAIN		= ./src/main
RESOURCES	= ./src/resources
PARSER		= $(MAIN)/parser
FLEX_FILE 	= $(MAIN)/scanner.l
BISON_FILE	= $(MAIN)/parser.y
OBJS 		= $(MAIN)/lex.yy.o $(MAIN)/parser.tab.o $(MAIN)/main.o $(MAIN)/util/n_tree/n_tree.o
TMP_SRC		= $(MAIN)/lex.yy.c $(MAIN)/parser.tab.c $(MAIN)/parser.tab.h
OUT			= mast
CC	 	 	= gcc 
FLAGS		= -c
LFLAGS		= -lfl

all:
	bison -d $(BISON_FILE) -o $(MAIN)/parser.tab.c
	flex -o $(MAIN)/lex.yy.c $(FLEX_FILE) 
	$(MAKE) -C $(MAIN)/util/n_tree
	$(CC) -c $(MAIN)/lex.yy.c -o $(MAIN)/lex.yy.o
	$(CC) -c $(MAIN)/parser.tab.c -o $(MAIN)/parser.tab.o
	$(CC) -c $(MAIN)/main.c -o $(MAIN)/main.o
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

clean:
	rm -f $(OBJS) $(TMP_SRC) $(OUT) parser parser.output *.ast *.dot
	$(MAKE) -C $(MAIN)/util/n_tree clean

run: 
	./$(OUT)

debug:
	bison -v -d $(BISON_FILE) -o $(MAIN)/parser.tab.c
	flex -o $(MAIN)/lex.yy.c $(FLEX_FILE) 
	$(MAKE) -C $(MAIN)/util/n_tree
	$(CC) -c $(MAIN)/lex.yy.c -o $(MAIN)/lex.yy.o
	$(CC) -c $(MAIN)/parser.tab.c -o $(MAIN)/parser.tab.o
	$(CC) -c $(MAIN)/main.c -o $(MAIN)/main.o
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

close2dinoapp:
	./$(OUT) < $(RESOURCES)/close2dinoapp.xml > close2dinoapp.ast
	sudo python3 $(MAIN)/dot/txt_to_diag.py close2dinoapp.ast close2dinoapp.dot
	node $(PARSER)/html close2dinoapp.dot
	node $(PARSER)/css close2dinoapp.dot
	node $(PARSER)/javascript close2dinoapp.dot

ast:
	./$(OUT) < $(RESOURCES)/simple_test.xml > simple_test.ast
	./$(OUT) < $(RESOURCES)/simple_test_2.xml > simple_test_2.ast

dot:
	sudo python3 $(MAIN)/dot/txt_to_diag.py simple_test.ast simple_test.dot
	sudo python3 $(MAIN)/dot/txt_to_diag.py simple_test_2.ast simple_test_2.dot
