%{
	int yylex(void);
	void yyerror (char const *s);
	extern int yylineno;
%}
%error-verbose
%token TK_VIEW
%%

query: page body subpages;

page: TK_STRING;

body: type content style action;

type: TK_STRING;
content: TK_STRING | int | type content content | ;

action: type content;

subpages: query subpages | ;


component: 	'<' TK_VIEW '>' component '<' '/' TK_VIEW '>'
			| '<' TK_LIST '>' list '<' '/' TK_LIST '>'
			| '<' TK_SCROLL_VIEW '>' component '<' '/' TK_SCROLL_VIEW '>'
			| text
			| '<' TK_LIST '>' list '<' '/' TK_LIST '>'
			| textinput
			| '<' TK_BUTTON '>' text '<' '/' TK_BUTTON '>';
			| ;

image: '<' TK_IMAGE '>' TK_URL '<' '/' TK_IMAGE '>';
images: image images | ;


list: text list | text;
text: TK_STRING;
%%
void yyerror (char const *s)
{
    printf("[Line %d] %s\n", yylineno, s);
}
