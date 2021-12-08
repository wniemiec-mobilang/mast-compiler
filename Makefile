MAIN		= ./src/main
RESOURCES	= ./src/resources
DATA		= $(MAIN)/data
EXPORT		= $(MAIN)/export
SEMANTIC	= $(MAIN)/semantic
SYNTAX		= $(MAIN)/syntax
FLEX_FILE 	= $(SYNTAX)/scanner.l
BISON_FILE	= $(SEMANTIC)/parser.y
OBJS 		= $(SYNTAX)/lex.yy.o $(SEMANTIC)/parser.tab.o $(MAIN)/main.o $(DATA)/text/string_utils.o $(DATA)/n_tree/n_tree.o
TMP_SRC		= $(SYNTAX)/lex.yy.c $(SEMANTIC)/parser.tab.c $(SEMANTIC)/parser.tab.h
OUT			= mast
CC	 	 	= gcc 
FLAGS		= -c
LFLAGS		= -lfl

all:
	bison -d $(BISON_FILE) -o $(SEMANTIC)/parser.tab.c
	flex -o $(SYNTAX)/lex.yy.c $(FLEX_FILE) 
	$(MAKE) -C $(DATA)/text
	$(MAKE) -C $(DATA)/n_tree
	$(CC) -c $(SYNTAX)/lex.yy.c -o $(SYNTAX)/lex.yy.o
	$(CC) -c $(SEMANTIC)/parser.tab.c -o $(SEMANTIC)/parser.tab.o
	$(CC) -c $(MAIN)/main.c -o $(MAIN)/main.o
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

clean:
	rm -f $(OBJS) $(TMP_SRC) $(OUT) $(SEMANTIC)/parser $(SEMANTIC)/parser.output *.ast *.dot
	$(MAKE) -C $(DATA)/n_tree clean
	$(MAKE) -C $(DATA)/text clean

run: 
	./$(OUT)

debug:
	bison -v -d $(BISON_FILE) -o $(SEMANTIC)/parser.tab.c
	flex -o $(SYNTAX)/lex.yy.c $(FLEX_FILE) 
	$(MAKE) -C $(DATA)/text
	$(MAKE) -C $(DATA)/n_tree
	$(CC) -c $(SYNTAX)/lex.yy.c -o $(SYNTAX)/lex.yy.o
	$(CC) -c $(SEMANTIC)/parser.tab.c -o $(SEMANTIC)/parser.tab.o
	$(CC) -c $(MAIN)/main.c -o $(MAIN)/main.o
	$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

close2dinoapp:
	./$(OUT) < $(RESOURCES)/close2dinoapp.xml > close2dinoapp.ast
	sudo python3 $(EXPORT)/dot/txt_to_diag.py close2dinoapp.ast close2dinoapp.dot
	node $(EXPORT)/html close2dinoapp.dot
	node $(EXPORT)/css close2dinoapp.dot
	node $(EXPORT)/javascript close2dinoapp.dot

ast:
	./$(OUT) < $(RESOURCES)/simple_test.xml > simple_test.ast
	./$(OUT) < $(RESOURCES)/simple_test_2.xml > simple_test_2.ast

dot:
	sudo python3 $(EXPORT)/dot/txt_to_diag.py simple_test.ast simple_test.dot
	sudo python3 $(EXPORT)/dot/txt_to_diag.py simple_test_2.ast simple_test_2.dot
