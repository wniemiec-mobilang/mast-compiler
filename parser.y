%{
	#include <stdio.h>
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
%%

query: body;

body: component body | ;

component: 	TK_VIEW_OPEN component TK_VIEW_CLOSE
			| TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE;

%%
void yyerror (char const *s)
{
    printf("[Line %d] %s\n", yylineno, s);
}
