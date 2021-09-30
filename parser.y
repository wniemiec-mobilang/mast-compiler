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
%token TK_CONTENT_OPEN
%token TK_CONTENT_CLOSE
%token TK_TEXT_OPEN
%token TK_TEXT_CLOSE
%token TK_SCREEN_OPEN
%token TK_SCREEN_CLOSE
%token TK_BODY_OPEN
%token TK_BODY_CLOSE
%token TK_SUBSCREENS_OPEN
%token TK_SUBSCREENS_CLOSE
%token TK_SUBSCREEN_OPEN
%token TK_SUBSCREEN_CLOSE
%token TK_QUERY_OPEN
%token TK_QUERY_CLOSE
%token TK_TITLE_OPEN
%token TK_TITLE_CLOSE
%token TK_STYLE_OPEN
%token TK_STYLE_CLOSE

%token TK_BUTTON_OPEN
%token TK_BUTTON_CLOSE
%token TK_ACTIONS_OPEN
%token TK_ACTIONS_CLOSE
%token TK_ONPRESS_OPEN
%token TK_ONPRESS_CLOSE
%token TK_ALERT_OPEN
%token TK_ALERT_CLOSE

%start query

%union {
    conteudo_lexico valor_lexico;
	PONT nodo_ptr;
}

%type<nodo_ptr> screens screen title body subscreens subscreens_content subscreen content content_inner style style_content
text actions subactions actions_inner alert;
%%

query: TK_QUERY_OPEN screens TK_QUERY_CLOSE { arvore = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); };

screens: 
	screen screens { $$ = create_node($<nodo_ptr>2, $<nodo_ptr>1); } 
	| { $$ = NULL; };
screen: TK_SCREEN_OPEN title body subscreens TK_SCREEN_CLOSE { 
	$$ = create_3node($<nodo_ptr>2, $<nodo_ptr>3, $<nodo_ptr>4, to_node($<valor_lexico>1)); 
};

title: TK_TITLE_OPEN TK_STRING TK_TITLE_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };
body: TK_BODY_OPEN content style TK_BODY_CLOSE { $$ = create_2node($<nodo_ptr>2, $<nodo_ptr>3, to_node($<valor_lexico>1)); };

subscreens: 
	TK_SUBSCREENS_OPEN subscreens_content TK_SUBSCREENS_CLOSE { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); } 
	| { $$ = NULL; };
subscreens_content: 
	subscreen subscreens_content { $$ = create_node($<nodo_ptr>1, $<nodo_ptr>2); } 
	| { $$ = NULL; };

	
subscreen: TK_SUBSCREEN_OPEN title body TK_SUBSCREEN_CLOSE { 
	$$ = create_2node($<nodo_ptr>2, $<nodo_ptr>3, to_node($<valor_lexico>1)); 
};

content: 
	content_inner content { $<nodo_ptr>$ = create_node($<nodo_ptr>2, $<nodo_ptr>1); } 
	| { $<nodo_ptr>$ = NULL; } ;
content_inner: 	
	TK_CONTENT_OPEN content TK_CONTENT_CLOSE { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); }
	| TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); }
	| TK_BUTTON_OPEN text actions TK_BUTTON_CLOSE { $$ = create_2node($<nodo_ptr>2, $<nodo_ptr>3, to_node($<valor_lexico>1)); };

text: TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

actions: TK_ACTIONS_OPEN actions_inner TK_ACTIONS_CLOSE { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); };
actions_inner: 
	TK_ONPRESS_OPEN subactions TK_ONPRESS_CLOSE actions_inner { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); }
	| { $$ = NULL; };
subactions: alert {$$ = $<nodo_ptr>1;};
alert: TK_ALERT_OPEN TK_STRING TK_ALERT_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

style: 
	TK_STYLE_OPEN style_content TK_STYLE_CLOSE { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); }
	| { $$ = NULL; };

style_content:
	TK_STRING style_content { $$ = create_node($<nodo_ptr>2, to_node($<valor_lexico>1)); }
	| { $$ = NULL; };
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
	
	if (node == NULL)
		return father;

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
	if (child2 == NULL)
		return create_node(child1, father);

	if (child1 == NULL)
		return create_node(child2, father);

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
