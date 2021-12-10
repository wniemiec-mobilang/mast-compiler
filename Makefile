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

compilation:
	./$(OUT) < $(filename).xml > $(filename).ast
	sudo python3 $(EXPORT)/dot/txt_to_diag.py $(filename).ast $(filename).dot
	node $(EXPORT)/html $(filename).dot
	node $(EXPORT)/css $(filename).dot
	node $(EXPORT)/javascript $(filename).dot

