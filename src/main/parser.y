%{
	#include <stdio.h>
	#include "lexeme.h"
	#include "util/n_tree/n_tree.h"
	
	int yylex(void);
	void yyerror (char const *s);
	node* to_node(lexeme lexical);
	lexeme generate_key_from_lexeme(lexeme lexeme);
	
	extern int yylineno;
	extern node* tree;
%}

%define parse.error verbose

%token TK_QUERY_OPEN
%token TK_QUERY_CLOSE
%token TK_SCREENS_OPEN
%token TK_SCREENS_CLOSE
%token TK_SCREEN_OPEN
%token TK_SCREEN_CLOSE
%token TK_STRUCTURE_OPEN
%token TK_STRUCTURE_CLOSE
%token TK_STYLE_OPEN
%token TK_STYLE_CLOSE
%token TK_BEHAVIOR_OPEN
%token TK_BEHAVIOR_CLOSE
%token TK_PROPERTIES_OPEN
%token TK_PROPERTIES_CLOSE
%token TK_PERSISTENCE_OPEN
%token TK_PERSISTENCE_CLOSE
%token TK_TEXT

%start query

%union {
    lexeme valor_lexico;
	node* nodo_ptr;
}

//%type<nodo_ptr> screens, screens_inner;

%%

query: 
	TK_QUERY_OPEN query_inner TK_QUERY_CLOSE
	| ;

query_inner: 
	screens properties persistence
	| properties screens persistence
	| properties persistence screens
	| screens persistence properties
	| persistence properties screens
	| persistence screens properties
;

screens: 
	TK_SCREENS_OPEN screens_inner TK_SCREENS_CLOSE
;

screens_inner:
	screen screens_inner
	| screen;
;

screen: 
	TK_SCREEN_OPEN screen_inner TK_SCREEN_CLOSE
;

screen_inner: 
	structure style behavior
	| structure behavior style
	| style structure behavior
	| style behavior structure
	| behavior structure style
	| behavior style structure
;

structure: 
	TK_STRUCTURE_OPEN content TK_STRUCTURE_CLOSE
;

content: TK_TEXT content | ;

style: 
	TK_STYLE_OPEN content TK_STYLE_CLOSE
;

behavior:
	TK_BEHAVIOR_OPEN content TK_BEHAVIOR_CLOSE
;

properties: 
	TK_PROPERTIES_OPEN content TK_PROPERTIES_CLOSE
;

persistence: 
	TK_PERSISTENCE_OPEN content TK_PERSISTENCE_CLOSE
;

%%

void yyerror (char const *s)
{
    printf("[Line %d] %s\n", yylineno, s);
}

node* to_node(lexeme lex)
{
	node* new_node = (node*) malloc(sizeof(node));
	
	new_node->child = NULL;
	new_node->brother = NULL;
	new_node->key = generate_key_from_lexeme(lex);

	return new_node;
}

lexeme generate_key_from_lexeme(lexeme lex)
{
	lexeme key;

    key.label = lex.label;
    key.line_number = lex.line_number;

	return key;
}
