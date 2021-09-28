%{
	#include "parser.tab.h"
	int get_line_number();	
%}
space [ \n\r]+
view_open \<view\>
text_open \<text\>
view_close \<\/view\>
text_close \<\/text\>
string [A-z0-9\-\_]+
%option yylineno
%%
{space} { }
{view_open} { return TK_VIEW_OPEN; }
{view_close} { return TK_VIEW_CLOSE; }
{text_open} { return TK_TEXT_OPEN; }
{text_close} { return TK_TEXT_CLOSE; }
{string} { return TK_STRING; }

%%
int get_line_number() {
	return yylineno;
}
