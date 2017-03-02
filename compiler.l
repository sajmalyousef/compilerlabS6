

%option noyywrap
%{
	#define YYSTYPE struct Tnode *
	#include "abstree.c"
	#include "y.tab.h"
	#include <stdlib.h>
%}

%%
[a-z]   {
		char * varName = malloc(sizeof(char));
		*varName = *yytext;
		yylval = TreeCreate(INT, ID,0,varName, NULL, NULL, NULL, NULL); 
		return ID;
	} 
[0-9]+ {        yylval = makeLeafNode(atoi(yytext));
		return NUM;
	
	}

"+"     {return PLUS;}
	
"*"	 {return MUL;}

"<"	 {return LT;}

">"	 {return GT;}

"=="	 {return EQ;}

"="	 {return ASGN;}

"("	 {return *yytext;}

 
")"	 {return *yytext;}
 
"if"	 {return IF;}

"then"	 {return THEN;}

"endif"	{return ENDIF;}

"while"	{return WHILE;}

"do" 	{return DO;}

"endwhile" {return ENDWHILE;}


"read" {return READ;}
"else" {return ELSE;}
"write" {return WRITE;}	
[\n] {return NEWLINE;}
[ \t] {}
. {return *yytext;}

%%





