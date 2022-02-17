MAIN 				= ./src/main
PYTHON_SRC			= $(MAIN)/python
JAVSCRIPT_SRC		= $(MAIN)/javascript

all:
		cd ../../../../../../..; \
		sudo python3 $(PYTHON_SRC)/ast-dot/txt_to_diag.py $(file).ast $(file).dot ; \
		node $(JAVSCRIPT_SRC)/html-parser $(file).dot; \
		node $(JAVSCRIPT_SRC)/css-parser $(file).dot; \
		node $(JAVSCRIPT_SRC)/javascript-parser $(file).dot
