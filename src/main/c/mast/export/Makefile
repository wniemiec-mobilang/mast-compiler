APP_ROOT			= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/../../..
PYTHON_SRC			= $(APP_ROOT)/python
JAVSCRIPT_SRC		= $(APP_ROOT)/javascript

all:
		sudo python3 $(PYTHON_SRC)/ast-dot/txt_to_diag.py $(file).ast $(output)/$(name).dot ; \
		node $(JAVSCRIPT_SRC)/html-parser $(output)/$(name).dot; \
		node $(JAVSCRIPT_SRC)/css-parser $(output)/$(name).dot; \
		node $(JAVSCRIPT_SRC)/javascript-parser $(output)/$(name).dot
