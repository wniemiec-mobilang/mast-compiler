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
%token TK_DIV_OPEN
%token TK_DIV_CLOSE
%token TK_BUTTON_OPEN
%token TK_BUTTON_CLOSE
%token TK_ACTIONS_OPEN
%token TK_ACTIONS_CLOSE
%token TK_ONPRESS_OPEN
%token TK_ONPRESS_CLOSE
%token TK_ALERT_OPEN
%token TK_ALERT_CLOSE
%token TK_ICON_OPEN
%token TK_ICON_CLOSE
%token TK_SCREENS_OPEN
%token TK_SCREENS_CLOSE
%token TK_GOTO_OPEN
%token TK_GOTO_CLOSE

%start query

%union {
    lexeme valor_lexico;
	node* nodo_ptr;
}

%type<nodo_ptr> screens screens_inner screen title body subscreens subscreens_content subscreen content component 
style style_content content_inner_no_div content_inner_div text actions subactions actions_inner alert icon goto;

%%

query: 
	TK_QUERY_OPEN screens icon TK_QUERY_CLOSE { tree = create_2node($2, $3, to_node($<valor_lexico>1)); }
	| TK_QUERY_OPEN screens TK_QUERY_CLOSE { tree = create_node($2, to_node($<valor_lexico>1)); };

icon: TK_ICON_OPEN TK_STRING TK_ICON_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

screens: 
	TK_SCREENS_OPEN screens_inner TK_SCREENS_CLOSE { $$ = create_node($2, to_node($<valor_lexico>1)); } 
	| { $$ = NULL; };

screens_inner: 
	screen screens_inner { $$ = create_node($2, $1); } 
	| { $$ = NULL; };

screen: TK_SCREEN_OPEN title body subscreens TK_SCREEN_CLOSE { $$ = create_3node($2, $3, $4, to_node($<valor_lexico>1)); };

title: TK_TITLE_OPEN TK_STRING TK_TITLE_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

body: TK_BODY_OPEN content style TK_BODY_CLOSE { $$ = create_2node($2, $3, to_node($<valor_lexico>1)); };

subscreens: 
	TK_SUBSCREENS_OPEN subscreens_content TK_SUBSCREENS_CLOSE { $$ = create_node($2, to_node($<valor_lexico>1)); } 
	| { $$ = NULL; };

subscreens_content: 
	subscreen subscreens_content { $$ = create_node($1, $2); } 
	| { $$ = NULL; };
	
subscreen: TK_SUBSCREEN_OPEN title body TK_SUBSCREEN_CLOSE { 
	$$ = create_2node($2, $3, to_node($<valor_lexico>1)); 
};

content: 
	TK_CONTENT_OPEN content_inner_no_div TK_CONTENT_CLOSE { $$ = create_node($2, to_node($<valor_lexico>1)); };

content_inner_no_div:
	component { $$ = $1; } 
	| TK_DIV_OPEN component content_inner_div TK_DIV_CLOSE { $$ = create_2node($2, $3, to_node($<valor_lexico>1)); };

content_inner_div:
	component content_inner_div { $$ = create_node($2, $1); }
	| TK_DIV_OPEN component content_inner_div TK_DIV_CLOSE { $$ = create_2node($2, $3, to_node($<valor_lexico>1)); } 
	| { $$ = NULL; };

component: 	
 	TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); }
	| TK_BUTTON_OPEN text actions TK_BUTTON_CLOSE { $$ = create_2node($2, $3, to_node($<valor_lexico>1)); }
	| TK_DIV_OPEN TK_DIV_CLOSE { $$ = to_node($<valor_lexico>1); };


text: TK_TEXT_OPEN TK_STRING TK_TEXT_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

actions: TK_ACTIONS_OPEN actions_inner TK_ACTIONS_CLOSE { $$ = create_node($2, to_node($<valor_lexico>1)); };

actions_inner: 
	TK_ONPRESS_OPEN subactions TK_ONPRESS_CLOSE actions_inner { $$ = create_node($2, to_node($<valor_lexico>1)); }
	| { $$ = NULL; };

subactions: 
	alert {$$ = $1;}
	| goto {$$ = $1;};

alert: TK_ALERT_OPEN TK_STRING TK_ALERT_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

goto: TK_GOTO_OPEN TK_STRING TK_GOTO_CLOSE { $$ = create_node(to_node($<valor_lexico>2), to_node($<valor_lexico>1)); };

style: 
	TK_STYLE_OPEN style_content TK_STYLE_CLOSE { $$ = create_node($2, to_node($<valor_lexico>1)); }
	| { $$ = NULL; };

style_content:
	TK_STRING style_content { $$ = create_node($2, to_node($<valor_lexico>1)); }
	| { $$ = NULL; };

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
