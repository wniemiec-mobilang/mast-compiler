%{
	#include "conteudo_lexico.h"
	#include "arvore/arvore_n_aria.h"
	#include "parser.tab.h"
	int get_line_number();
	void value_parser(int tipo_token, char* token);
%}
space [ \n\r]+
view_open \<view\>
text_open \<text\>
view_close \<\/view\>
text_close \<\/text\>
string [^<>\n\r]+
screen_open \<screen\>
screen_close \<\/screen\>
body_open \<body\>
body_close \<\/body\>
subscreens_open \<subscreens\>
subscreens_close \<\/subscreens\>
subscreen_open \<subscreen\>
subscreen_close \<\/subscreen\>
query_open \<mobilang\>
query_close \<\/mobilang\>
title_open \<title\>
title_close \<\/title\>

%option yylineno
%%
{space} { }
{screen_open} 		{ value_parser(TK_SCREEN_OPEN, "<screen>"); return TK_SCREEN_OPEN; }
{screen_close} 		{ value_parser(TK_SCREEN_CLOSE, "</screen>"); return TK_SCREEN_CLOSE; }
{body_open} 		{ value_parser(TK_BODY_OPEN, "<body>"); return TK_BODY_OPEN; }
{body_close} 		{ value_parser(TK_BODY_CLOSE, "</body>"); return TK_BODY_CLOSE; }
{subscreens_open} 	{ value_parser(TK_SUBSCREENS_OPEN, "<subscreens>"); return TK_SUBSCREENS_OPEN; }
{subscreens_close} 	{ value_parser(TK_SUBSCREENS_CLOSE, "</subscreens>"); return TK_SUBSCREENS_CLOSE; }
{subscreen_open} 	{ value_parser(TK_SUBSCREEN_OPEN, "<subscreen>"); return TK_SUBSCREEN_OPEN; }
{subscreen_close} 	{ value_parser(TK_SUBSCREEN_CLOSE, "</subscreen>"); return TK_SUBSCREEN_CLOSE; }
{view_open} 		{ value_parser(TK_VIEW_OPEN, "<view>"); return TK_VIEW_OPEN; }
{view_close} 		{ value_parser(TK_VIEW_CLOSE, "</view>"); return TK_VIEW_CLOSE; }
{text_open} 		{ value_parser(TK_TEXT_OPEN, "<text>"); return TK_TEXT_OPEN; }
{text_close} 		{ value_parser(TK_TEXT_CLOSE, "</text>"); return TK_TEXT_CLOSE; }
{query_open} 		{ value_parser(TK_QUERY_OPEN, "<mobilang>"); return TK_QUERY_OPEN; }
{query_close} 		{ value_parser(TK_QUERY_CLOSE, "</mobilang>"); return TK_QUERY_CLOSE; }
{title_open}		{ value_parser(TK_TITLE_OPEN, "<title>"); return TK_TITLE_OPEN; }
{title_close}		{ value_parser(TK_TITLE_CLOSE, "</title>"); return TK_TITLE_CLOSE; }
{string} 			{ value_parser(TK_STRING, strdup(yytext)); return TK_STRING; }

%%
int get_line_number() {
	return yylineno;
}

void value_parser(int tipo_token, char* label)
{
	yylval.valor_lexico.tipo_token = tipo_token;
	yylval.valor_lexico.numero_linha = get_line_number();
	yylval.valor_lexico.label = label;
}

