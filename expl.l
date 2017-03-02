
%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "y.tab.h"
%}



%%

[a-z]    { yylval.character = yytext[0]; return ID;}
[0-9]+   { yylval.integer = atoi(yytext); return NUM;}
"read"    { return READ;}
[=]         { return ASGN;}
"write"   {return WRITE;}
"+"	{return PLUS;}
"*"	{return MUL;}
"("     {return *yytext;}
")"     {return *yytext;}
";"     { return *yytext;}
[ \t] {}
. { return *yytext;}



%%

int yywrap(void) {
	return 1;
}
