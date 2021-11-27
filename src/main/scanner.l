%{
	#include "lexeme.h"
	#include "util/n_tree/n_tree.h"
	#include "parser.tab.h"
	
	int get_line_number();
	void value_parser(int token_type, char* token);
%}

space [ \n\r]+
query_open \<mobilang\>
query_close \<\/mobilang\>
screens_open \<screens\>
screens_close \<\/screens\>
screen_open \<screen\>
screen_close \<\/screen\>
structure_open \<structure\>
structure_close \<\/structure\>
style_open \<style\>
style_close \<\/style\>
behavior_open \<behavior\>
behavior_close \<\/behavior\>
properties_open \<properties\>
properties_close \<\/properties\>
persistence_open \<persistence\>
persistence_close \<\/persistence\>
text .+

%option yylineno

%%

{space} 			{ }
{query_open} 		{ value_parser(TK_QUERY_OPEN, "<mobilang>"); return TK_QUERY_OPEN; }
{query_close} 		{ value_parser(TK_QUERY_CLOSE, "</mobilang>"); return TK_QUERY_CLOSE; }
{screens_open}		{ value_parser(TK_SCREENS_OPEN, "<screens>"); return TK_SCREENS_OPEN; }
{screens_close}		{ value_parser(TK_SCREENS_CLOSE, "</screens>"); return TK_SCREENS_CLOSE; }
{screen_open} 		{ value_parser(TK_SCREEN_OPEN, "<screen>"); return TK_SCREEN_OPEN; }
{screen_close} 		{ value_parser(TK_SCREEN_CLOSE, "</screen>"); return TK_SCREEN_CLOSE; }
{structure_open}	{ value_parser(TK_STRUCTURE_OPEN, "<structure>"); return TK_STRUCTURE_OPEN; }
{structure_close}	{ value_parser(TK_STRUCTURE_CLOSE, "</structure>"); return TK_STRUCTURE_CLOSE; }
{style_open}		{ value_parser(TK_STYLE_OPEN, "<style>"); return TK_STYLE_OPEN; }
{style_close}		{ value_parser(TK_STYLE_CLOSE, "</style>"); return TK_STYLE_CLOSE; }
{behavior_open}		{ value_parser(TK_BEHAVIOR_OPEN, "<behavior>"); return TK_BEHAVIOR_OPEN; }
{behavior_close}	{ value_parser(TK_BEHAVIOR_CLOSE, "</behavior>"); return TK_BEHAVIOR_CLOSE; }
{properties_open}	{ value_parser(TK_PROPERTIES_OPEN, "<properties>"); return TK_PROPERTIES_OPEN; }
{properties_close}	{ value_parser(TK_PROPERTIES_CLOSE, "</properties>"); return TK_PROPERTIES_CLOSE; }
{persistence_open}	{ value_parser(TK_PERSISTENCE_OPEN, "<persistence>"); return TK_PERSISTENCE_OPEN; }
{persistence_close}	{ value_parser(TK_PERSISTENCE_CLOSE, "</persistence>"); return TK_PERSISTENCE_CLOSE; }
{text} 				{ value_parser(TK_TEXT, strdup(yytext)); return TK_TEXT; }

%%

int get_line_number() {
	return yylineno;
}

void value_parser(int token_type, char* label)
{
	yylval.lex_value.token_type = token_type;
	yylval.lex_value.line_number = get_line_number();
	yylval.lex_value.label = label;
}

