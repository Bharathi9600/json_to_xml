%{
#include "string.h"
#include "y.tab.h"

char *new_str(const char *str);
%}

blanks          [ \t\n\r]+
V_E_C \\n|\\b|\\\"|\\\\|\\\/|\\f|\\r|\\t|\\u[0-9A-F]{4}
V_C [^\\\"]
LC \{
RC \}
CN :
CM ,
LS \[
RS \]
STRING_LITERAL \"({V_C}|{V_E_C})*\"
BOOLEAN true|false|TRUE|FALSE
NUMBER (-)?0(\.[0-9]*)?([e|E][+|-][0-9]*)?|(-)?[1-9][0-9]*(\.[0-9]*)?([e|E][+|-][0-9]*)?
NULL null|NULL

%%

{blanks}        { /* ignore */ }
{LC} {return '{';}
{RC} {return '}';}
{STRING_LITERAL} {yylval.str=new_str(yytext); return(__STRING_LITERAL);}
{CN} {return ':';}
{CM} {return ',';}
{LS} {return '[';}
{RS} {return ']';}
{BOOLEAN} {yylval.str=new_str(yytext); return(__BOOLEAN);}
{NUMBER} {yylval.str=new_str(yytext); return(__NUMBER); }
{NULL} {yylval.str=new_str(yytext); return(__NULL);}

%%
char *new_str(const char *str)
{
    char *new=malloc(strlen(str)+1);
    strcpy(new,str);
    return new;
}

int yywrap() {
	return 1;
}

