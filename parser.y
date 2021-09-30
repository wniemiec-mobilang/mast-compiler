%{
	#include <stdio.h>
	#include "conteudo_lexico.h"
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
}

%type<valor_lexico> component
%%

query: body;

body: component body | ;

component: 	TK_VIEW_OPEN component TK_VIEW_CLOSE { printf("%s\n", $<valor_lexico>1.label); } 
			| TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE { printf("%s\n", $<valor_lexico>2.label); printf("%s\n", $<valor_lexico>1.label); };

%%
void yyerror (char const *s)
{
    printf("[Line %d] %s\n", yylineno, s);
}
