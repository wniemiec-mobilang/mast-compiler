%{
	#include <stdio.h>
	#include "conteudo_lexico.h"
	#include "arvore/arvore_n_aria.h"
	int yylex(void);
	void yyerror (char const *s);
	PONT to_node(conteudo_lexico lexical);
	PONT create_node(PONT node, PONT father);
	extern int yylineno;
	PONT arvore;
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

%type<nodo_ptr> body component;
%%

query: body { arvore = $<nodo_ptr>1; };

body: component body { $$ = create_node($<nodo_ptr>1, $<nodo_ptr>2); } | { $<nodo_ptr>$ = NULL; } ;

component: 	TK_VIEW_OPEN body TK_VIEW_CLOSE { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); }
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
