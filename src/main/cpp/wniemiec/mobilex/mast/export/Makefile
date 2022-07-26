APP_ROOT			= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/../../../../..
C_SRC				= $(APP_ROOT)/cpp
MAST_SRC			= $(C_SRC)/wniemiec/mobilex/mast
EXPORT				= $(MAST_SRC)/export
PYTHON_SRC			= $(APP_ROOT)/python
JAVSCRIPT_SRC		= $(APP_ROOT)/javascript
CC					= g++
FLAGS				= -c
LFLAGS				= -lfl

all:
		# $(CC) -c $(EXPORT)/DotExport.cpp -o $(EXPORT)/DotExport.o
		python3 $(PYTHON_SRC)/ast-dot/txt_to_diag.py $(file).ast $(output)/$(name).dot ; \
		node $(JAVSCRIPT_SRC)/html-parser $(output)/$(name).dot; \
		node $(JAVSCRIPT_SRC)/css-parser $(output)/$(name).dot; \
		node $(JAVSCRIPT_SRC)/javascript-parser $(output)/$(name).dot
