%{
	#include <stdio.h>
	#include "conteudo_lexico.h"
	#include "arvore/arvore_n_aria.h"
	int yylex(void);
	void yyerror (char const *s);
	extern int yylineno;


%}
%error-verbose
%token TK_STRING
%token TK_VIEW_OPEN
%token TK_VIEW_CLOSE
%token TK_TEXT_OPEN
%token TK_TEXT_CLOSE
%start query

%union {
    conteudo_lexico valor_lexico;
	PONT nodo_ptr;
}

%type<valor_lexico> component
%type<nodo_ptr> body;
%%

query: body;

body: component body | ;

component: 	TK_VIEW_OPEN body TK_VIEW_CLOSE 
			| TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE;

%%
void yyerror (char const *s)
{
    printf("[Line %d] %s\n", yylineno, s);
}
