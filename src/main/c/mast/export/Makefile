MAIN 				= ./src/main
PYTHON_SRC			= $(MAIN)/python
JAVSCRIPT_SRC		= $(MAIN)/javascript

all:
		cd ../../../../../../..; \
		sudo python3 $(PYTHON_SRC)/ast-dot/txt_to_diag.py $(file).ast $(output)/$(name).dot ; \
		node $(JAVSCRIPT_SRC)/html-parser $(output)/$(name).dot; \
		node $(JAVSCRIPT_SRC)/css-parser $(output)/$(name).dot; \
		node $(JAVSCRIPT_SRC)/javascript-parser $(output)/$(name).dot
