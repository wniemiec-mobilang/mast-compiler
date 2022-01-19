MAIN 				= ./src/main
RESOURCES			= ./src/resources
C_SRC				= $(MAIN)/c
PYTHON_SRC			= $(MAIN)/python
JAVSCRIPT_SRC		= $(MAIN)/javascript
MAST_SRC			= $(C_SRC)/wniemiec/mobilang/mast
EXPORT				= $(MAST_SRC)/export
DATA				= $(MAST_SRC)/data
SEMANTIC			= $(MAST_SRC)/semantic
SYNTAX				= $(MAST_SRC)/syntax
FLEX_FILE			= $(SYNTAX)/scanner.l
BISON_FILE			= $(SEMANTIC)/parser.y
OBJS				= $(SYNTAX)/lex.yy.o $(SEMANTIC)/parser.tab.o $(MAST_SRC)/main.o $(DATA)/text/string_utils.o $(DATA)/n_tree/n_tree.o
TMP_SRC				= $(SYNTAX)/lex.yy.c $(SEMANTIC)/parser.tab.c $(SEMANTIC)/parser.tab.h
OUT					= mast
CC					= gcc 
FLAGS				= -c
LFLAGS				= -lfl

all:
		bison -d $(BISON_FILE) -o $(SEMANTIC)/parser.tab.c
		flex -o $(SYNTAX)/lex.yy.c $(FLEX_FILE) 
		$(MAKE) -C $(DATA)/text
		$(MAKE) -C $(DATA)/n_tree
		$(CC) -c $(SYNTAX)/lex.yy.c -o $(SYNTAX)/lex.yy.o
		$(CC) -c $(SEMANTIC)/parser.tab.c -o $(SEMANTIC)/parser.tab.o
		$(CC) -c $(MAST_SRC)/main.c -o $(MAST_SRC)/main.o
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
		$(CC) -c $(MAST_SRC)/main.c -o $(MAST_SRC)/main.o
		$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

compilation:
		./$(OUT) < $(file).xml > $(file).ast
		$(MAKE) -C $(EXPORT) file=$(file)

