%{
	#define YYSTYPE struct Tnode*
	#include "abstree.h"
	#include "y.tab.h"
	#include "Symboltable.h"
	#define VOID -1
	#include <stdlib.h>
	#define T_INT -1003
	#define T_BOOL -1004
	#define TRUE -1006
	#define FALSE -1007
	#define INTARR 1001
	#define BOOLARR 1002
	struct Gsymbol * GST = NULL;
%}

%%

"integer" 		{ return INT; }
"boolean"		{return BOOL;}
"decl"		{ return DECL; }
"enddecl"	{ return ENDDECL; }
"begin"		{ return BEG; }
"break"		{return BREAK;}
"continue"	{return CONTINUE;}
"end"		{ return END; }
"read" 		{ return READ; }
"write"		{ return WRITE; }
"if" 		{ return IF; }
"then" 		{ return THEN; }
"else" 		{ return ELSE; }
"endif"		{ return ENDIF; }
"while" 	{ return WHILE; }
"do" 		{ return DO; }
"endwhile" 	{ return ENDWHILE; }
"true"		{ yylval = makeLeafNode(TRUE, T_BOOL); return BOOLEAN;}
"false"		{yylval = makeLeafNode(FALSE, T_BOOL); return BOOLEAN;}

[a-zA-Z_][a-zA-Z_0-9]*	{ 	char * varName = malloc(sizeof(char)*strlen(yytext)+1);
			strcpy(varName, yytext);
			yylval = TreeCreate(INT, ID,0, varName,  NULL, NULL, NULL, NULL); 
			return ID;
		}
[0-9]+		{ yylval = makeLeafNode(atoi(yytext), T_INT); return NUM; }
[=]		{ return ASGN; }
"+"		{ return PLUS; }
"*"		{ return MUL; }
"=="		{ return EQ; }
"!="		{return NEQ;}
"<"		{ return LT; }
">"		{ return GT; }
[ \t\n]		{}
.		{ return *yytext; }
%%

int yywrap()
{
	return 1;
}
