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
string [A-z0-9\-\_]+
%option yylineno
%%
{space} { }
{view_open} { value_parser(TK_VIEW_OPEN, "<view>"); return TK_VIEW_OPEN; }
{view_close} { value_parser(TK_VIEW_CLOSE, "</view>"); return TK_VIEW_CLOSE; }
{text_open} { value_parser(TK_TEXT_OPEN, "<text>"); return TK_TEXT_OPEN; }
{text_close} { value_parser(TK_TEXT_CLOSE, "</text>"); return TK_TEXT_CLOSE; }
{string} { value_parser(TK_STRING, strdup(yytext)); return TK_STRING; }

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

