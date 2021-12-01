%{
	#include "lexeme.h"
	#include "util/n_tree/n_tree.h"
	#include "parser.tab.h"
	
	int get_line_number();
	void value_parser(int token_type);
%}

space [ \t\n\r]+
tag_property [A-z\-\_]+\=\"[A-z0-9\-\_]+\"
mobilang_open \<mobilang\>
mobilang_close \<\/mobilang\>
screens_open \<screens\>
screens_close \<\/screens\>
screen_open \<screen[ ]+{tag_property}*\>
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
{mobilang_open} 	{ value_parser(TK_MOBILANG_OPEN); return TK_MOBILANG_OPEN; }
{mobilang_close} 	{ value_parser(TK_MOBILANG_CLOSE); return TK_MOBILANG_CLOSE; }
{screens_open}		{ value_parser(TK_SCREENS_OPEN); return TK_SCREENS_OPEN; }
{screens_close}		{ value_parser(TK_SCREENS_CLOSE); return TK_SCREENS_CLOSE; }
{screen_open} 		{ value_parser(TK_SCREEN_OPEN); return TK_SCREEN_OPEN; }
{screen_close} 		{ value_parser(TK_SCREEN_CLOSE); return TK_SCREEN_CLOSE; }
{structure_open}	{ value_parser(TK_STRUCTURE_OPEN); return TK_STRUCTURE_OPEN; }
{structure_close}	{ value_parser(TK_STRUCTURE_CLOSE); return TK_STRUCTURE_CLOSE; }
{style_open}		{ value_parser(TK_STYLE_OPEN); return TK_STYLE_OPEN; }
{style_close}		{ value_parser(TK_STYLE_CLOSE); return TK_STYLE_CLOSE; }
{behavior_open}		{ value_parser(TK_BEHAVIOR_OPEN); return TK_BEHAVIOR_OPEN; }
{behavior_close}	{ value_parser(TK_BEHAVIOR_CLOSE); return TK_BEHAVIOR_CLOSE; }
{properties_open}	{ value_parser(TK_PROPERTIES_OPEN); return TK_PROPERTIES_OPEN; }
{properties_close}	{ value_parser(TK_PROPERTIES_CLOSE); return TK_PROPERTIES_CLOSE; }
{persistence_open}	{ value_parser(TK_PERSISTENCE_OPEN); return TK_PERSISTENCE_OPEN; }
{persistence_close}	{ value_parser(TK_PERSISTENCE_CLOSE); return TK_PERSISTENCE_CLOSE; }
{tag_property} 		{ value_parser(TK_TAG_PROPERTY); return TK_TAG_PROPERTY; }
{text} 				{ value_parser(TK_TEXT); return TK_TEXT; }

%%

int get_line_number() {
	return yylineno;
}

void value_parser(int token_type)
{
	yylval.lex_value.token_type = token_type;
	yylval.lex_value.line_number = get_line_number();
	yylval.lex_value.label = strdup(yytext);
}

