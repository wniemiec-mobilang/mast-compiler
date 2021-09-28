%{
	#include "parser.tab.h"
	int get_line_number();	
%}
space [ \n\r]+
view view
string \".*\"
image image
scrollview scrollview
list list
button button
url 0
%option yylineno
%%
{space} { }
{view} { return TK_VIEW; }
{string} { return TK_STRING; }
{image} { return TK_IMAGE; }
{scrollview} { return TK_SCROLLVIEW; }
{list} { return TK_LIST; }
{button} { return TK_BUTTON; }
{url} { return TK_URL; }

%%
int get_line_number() {
	return yylineno;
}
