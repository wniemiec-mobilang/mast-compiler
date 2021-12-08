%{
#include <stdio.h>
#include <string.h>
#include "../syntax/lexeme.h"
#include "../data/n_tree/n_tree.h"
#include "../data/text/string_utils.h"


/*---------------------------------------------------------------------------*/
/*		Prototypes                                                           */
/*---------------------------------------------------------------------------*/
extern int yylineno;
extern node* tree;

int yylex(void);
void yyerror (char const *s);
node* to_node(lexeme lexical, bool escape_quotes);
node* to_node_with_properties(lexeme lex, char* properties);
lexeme generate_key_from_lexeme(lexeme lexeme, bool escape_quotes);
node* merge_nodes_label(node* n1, node* n2);
%}


/*---------------------------------------------------------------------------*/
/*		Tokens definition                                                    */
/*---------------------------------------------------------------------------*/
%token TK_MOBILANG_OPEN
%token TK_MOBILANG_CLOSE
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
%token TK_TAG_PROPERTY
%token TK_TEXT


/*---------------------------------------------------------------------------*/
/*		Grammar type definition                                              */
/*---------------------------------------------------------------------------*/
%union {
    lexeme lex_value;
	node* node;
	char* str;
}

%type<node> screens;
%type<node> screens_inner;
%type<node> screen;
%type<node> structure;
%type<node> content;
%type<node> style;
%type<node> behavior;
%type<node> properties;
%type<node> persistence;


/*---------------------------------------------------------------------------*/
/*		Settings                                                             */
/*---------------------------------------------------------------------------*/
%define parse.error verbose
%start query


/*---------------------------------------------------------------------------*/
/*		Grammar                                                              */
/*---------------------------------------------------------------------------*/
%%
query: 
	TK_MOBILANG_OPEN screens persistence properties TK_MOBILANG_CLOSE 	{ tree = create_3node($2, $3, $4, to_node($<lex_value>1, false)); }
	| TK_MOBILANG_OPEN screens properties persistence TK_MOBILANG_CLOSE	{ tree = create_3node($2, $3, $4, to_node($<lex_value>1, false)); }
	| TK_MOBILANG_OPEN properties screens persistence TK_MOBILANG_CLOSE	{ tree = create_3node($2, $3, $4, to_node($<lex_value>1, false)); }
	| TK_MOBILANG_OPEN properties persistence screens TK_MOBILANG_CLOSE	{ tree = create_3node($2, $3, $4, to_node($<lex_value>1, false)); }
	| TK_MOBILANG_OPEN persistence properties screens TK_MOBILANG_CLOSE	{ tree = create_3node($2, $3, $4, to_node($<lex_value>1, false)); }
	| TK_MOBILANG_OPEN persistence screens properties TK_MOBILANG_CLOSE	{ tree = create_3node($2, $3, $4, to_node($<lex_value>1, false)); }
	| 																	{ tree = NULL; };

screens: 
	TK_SCREENS_OPEN screens_inner TK_SCREENS_CLOSE	{ $$ = create_node($2, to_node($<lex_value>1, false)); }
;

screens_inner:
	screen screens_inner	{ $$ = create_node($2, $1); }
	| 						{ $$ = NULL; };
;

screen: 
	TK_SCREEN_OPEN structure style behavior TK_SCREEN_CLOSE 	{ $$ = create_3node($2, $3, $4, to_node($<lex_value>1, true)); }
	| TK_SCREEN_OPEN structure behavior style TK_SCREEN_CLOSE 	{ $$ = create_3node($2, $3, $4, to_node($<lex_value>1, true)); }
	| TK_SCREEN_OPEN style structure behavior TK_SCREEN_CLOSE 	{ $$ = create_3node($2, $3, $4, to_node($<lex_value>1, true)); }
	| TK_SCREEN_OPEN style behavior structure TK_SCREEN_CLOSE 	{ $$ = create_3node($2, $3, $4, to_node($<lex_value>1, true)); }
	| TK_SCREEN_OPEN behavior structure style TK_SCREEN_CLOSE 	{ $$ = create_3node($2, $3, $4, to_node($<lex_value>1, true)); }
	| TK_SCREEN_OPEN behavior style structure TK_SCREEN_CLOSE 	{ $$ = create_3node($2, $3, $4, to_node($<lex_value>1, true)); }
;

structure: 
	TK_STRUCTURE_OPEN content TK_STRUCTURE_CLOSE { $$ = create_node($2, to_node($<lex_value>1, false)); }
;

content: 
	TK_TEXT content	{ $$ = merge_nodes_label(to_node($<lex_value>1, false), $2); }
	| 				{ $$ = NULL; }
;

style: 
	TK_STYLE_OPEN content TK_STYLE_CLOSE { $$ = create_node($2, to_node($<lex_value>1, false)); }
;

behavior:
	TK_BEHAVIOR_OPEN content TK_BEHAVIOR_CLOSE { $$ = create_node($2, to_node($<lex_value>1, false)); }
;

properties: 
	TK_PROPERTIES_OPEN content TK_PROPERTIES_CLOSE { $$ = create_json_node($2, to_node($<lex_value>1, false)); }
;

persistence: 
	TK_PERSISTENCE_OPEN content TK_PERSISTENCE_CLOSE { $$ = create_json_node($2, to_node($<lex_value>1, false)); }
;
%%


/*---------------------------------------------------------------------------*/
/*		Functions                                                            */
/*---------------------------------------------------------------------------*/
void yyerror (char const *s)
{
    printf("[Line %d] %s\n", yylineno, s);
}
