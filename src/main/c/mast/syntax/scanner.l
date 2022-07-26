%{
#include "lexeme.h"
#include "../data/n_tree/n_tree.h"
#include "../semantic/parser.tab.h"


/*---------------------------------------------------------------------------*/
/*		Prototypes                                                           */
/*---------------------------------------------------------------------------*/
extern "C" int yylex();
int get_line_number();
int parse_token(int token_type);
%}


/*---------------------------------------------------------------------------*/
/*		Regular expressions                                                  */
/*---------------------------------------------------------------------------*/
space [ \t\n\r\b]+
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
text .+


/*---------------------------------------------------------------------------*/
/*		Settings                                                             */
/*---------------------------------------------------------------------------*/
%option yylineno


/*---------------------------------------------------------------------------*/
/*		Actions                                                              */
/*---------------------------------------------------------------------------*/
%%
{space} 				{ }
{mobilang_open} 		{ return parse_token(TK_MOBILANG_OPEN); }
{mobilang_close} 		{ return parse_token(TK_MOBILANG_CLOSE); }
{screens_open}			{ return parse_token(TK_SCREENS_OPEN); }
{screens_close}			{ return parse_token(TK_SCREENS_CLOSE); }
{screen_open} 			{ return parse_token(TK_SCREEN_OPEN); }
{screen_close} 			{ return parse_token(TK_SCREEN_CLOSE); }
{structure_open}		{ return parse_token(TK_STRUCTURE_OPEN); }
{structure_close}		{ return parse_token(TK_STRUCTURE_CLOSE); }
{style_open}			{ return parse_token(TK_STYLE_OPEN); }
{style_close}			{ return parse_token(TK_STYLE_CLOSE); }
{behavior_open}			{ return parse_token(TK_BEHAVIOR_OPEN); }
{behavior_close}		{ return parse_token(TK_BEHAVIOR_CLOSE); }
{properties_open}		{ return parse_token(TK_PROPERTIES_OPEN); }
{properties_close}		{ return parse_token(TK_PROPERTIES_CLOSE); }
{tag_property} 			{ return parse_token(TK_TAG_PROPERTY); }
{text} 					{ return parse_token(TK_TEXT); }
%%


/*---------------------------------------------------------------------------*/
/*		Functions                                                            */
/*---------------------------------------------------------------------------*/
int get_line_number() {
	return yylineno;
}

int parse_token(int token_type)
{
	yylval.lex_value.token_type = token_type;
	yylval.lex_value.line_number = get_line_number();
	yylval.lex_value.label = strdup(yytext);

	return token_type;
}
