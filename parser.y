%{
	#include <stdio.h>
	#include "conteudo_lexico.h"
	#include "arvore/arvore_n_aria.h"
	int yylex(void);
	void yyerror (char const *s);
	PONT to_node(conteudo_lexico lexical);
	PONT create_node(PONT node, PONT father);
	PONT create_2node(PONT child1, PONT child2, PONT father);
	PONT create_3node(PONT child1, PONT child2, PONT child3, PONT father);
	extern int yylineno;
	PONT arvore;
%}
%error-verbose
%token TK_STRING
%token TK_VIEW_OPEN
%token TK_VIEW_CLOSE
%token TK_TEXT_OPEN
%token TK_TEXT_CLOSE
%token TK_SCREEN_OPEN;
%token TK_SCREEN_CLOSE;
%token TK_BODY_OPEN;
%token TK_BODY_CLOSE;
%token TK_SUBSCREENS_OPEN;
%token TK_SUBSCREENS_CLOSE;
%token TK_SUBSCREEN_OPEN;
%token TK_SUBSCREEN_CLOSE;
%token TK_QUERY_OPEN;
%token TK_QUERY_CLOSE;
%token TK_TITLE_OPEN;
%token TK_TITLE_CLOSE;

%start query

%union {
    conteudo_lexico valor_lexico;
	PONT nodo_ptr;
}

%type<nodo_ptr> screens screen title body subscreens subscreens_def subscreen components component;
%%

query: TK_QUERY_OPEN screens TK_QUERY_CLOSE { arvore = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); };

screens: screen screens { $$ = create_node($<nodo_ptr>2, $<nodo_ptr>1); } | { $$ = NULL; };
screen: TK_SCREEN_OPEN title body subscreens TK_SCREEN_CLOSE { $$ = create_3node($<nodo_ptr>2, $<nodo_ptr>3, $<nodo_ptr>4, to_node($<valor_lexico>1)); };

title: TK_TITLE_OPEN TK_STRING TK_TITLE_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };
body: TK_BODY_OPEN components TK_BODY_CLOSE { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); };

subscreens: 
	TK_SUBSCREENS_OPEN subscreens_def TK_SUBSCREENS_CLOSE { $$ = create_2node($<nodo_ptr>2, $<nodo_ptr>3, to_node($<valor_lexico>1)); } 
	| { $$ = NULL; };
subscreens_def: 
	subscreen subscreens_def { $$ = create_2node($<nodo_ptr>1, $<nodo_ptr>2, $<nodo_ptr>1); } 
	| { $$ = NULL; };
subscreen: TK_SUBSCREEN_OPEN title body TK_SUBSCREEN_CLOSE { $$ = create_2node($<nodo_ptr>2, $<nodo_ptr>3, to_node($<valor_lexico>1)); };;

components: component components { $$ = create_node($<nodo_ptr>1, $<nodo_ptr>2); } | { $<nodo_ptr>$ = NULL; } ;
component: 	TK_VIEW_OPEN components TK_VIEW_CLOSE { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); }
			| TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

%%
void yyerror (char const *s)
{
    printf("[Line %d] %s\n", yylineno, s);
}

PONT to_node(conteudo_lexico lexical)
{
	conteudo_lexico chave;
    chave.label = lexical.label;
    chave.numero_linha = lexical.numero_linha;
    
    return inicializa(chave);
}

PONT create_node(PONT node, PONT father)
{
	if (father == NULL)
		return node;

	PONT p = father->primFilho;
	if (!p) {
		father->primFilho = node;
	}
	else {
		while (p->proxIrmao)
			p = p->proxIrmao;

		p->proxIrmao = node;
	}
	return father;
}

PONT create_2node(PONT child1, PONT child2, PONT father)
{
	if (father == NULL)
	{
		child1->proxIrmao = child2;
		return child1;
	}

	PONT p = father->primFilho;
	if (!p) {
		father->primFilho = child1;
		father->primFilho->proxIrmao = child2;
	}
	else {
		while (p->proxIrmao)
			p = p->proxIrmao;

		p->proxIrmao = child1;
		p->proxIrmao->proxIrmao = child2;
	}
	return father;
}

PONT create_3node(PONT child1, PONT child2, PONT child3, PONT father)
{
	if (father == NULL)
	{
		child1->proxIrmao = child2;
		return child1;
	}

	PONT p = father->primFilho;
	if (!p) {
		father->primFilho = child1;
		father->primFilho->proxIrmao = child2;
		father->primFilho->proxIrmao->proxIrmao = child3;
	}
	else {
		while (p->proxIrmao)
			p = p->proxIrmao;

		p->proxIrmao = child1;
		p->proxIrmao->proxIrmao = child2;
		p->proxIrmao->proxIrmao->proxIrmao = child3;
	}
	return father;
}
