
%{
	#define YYSTYPE struct Tnode*
	#include "abstree.h"
	#include "Symboltable.h"
	#include <stdlib.h>
	#include <stdio.h>	
	int *var[26];
%}

%token NUM ID READ WRITE ASGN NEWLINE IF THEN ELSE ENDIF WHILE DO ENDWHILE LT GT EQ STATEMENT VOID INT BOOL 
%nonassoc LT GT EQ
%left PLUS
%left MUL 
%%
Program : slist NEWLINE { evaluate($1); exit(0);}
	     ;
slist 	: slist stmt		{
      				  $$ = TreeCreate(VOID, STATEMENT, 0,NULL, NULL, $1, $2, NULL);
				}
	| stmt			{ $$ = $1; }
     	;


expr	: expr PLUS expr	{ 	if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ERROR");
						exit(0);}
					$$ = makeOperatorNode(PLUS, $1, $3); }
     	| expr MUL expr		{
					if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ERROR");
						exit(0);}
				 $$ = makeOperatorNode(MUL, $1, $3); }
     	| expr EQ expr		{ if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ERROR");
						exit(0);}
				  $$ = makeOperatorNode(EQ, $1, $3); }
     	| expr LT expr		{if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ERROR");
						exit(0);}
				  $$ = makeOperatorNode(LT, $1, $3); }
     	| expr GT expr		{if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ERROR");
						exit(0);}
				 $$ = makeOperatorNode(GT, $1, $3); }
	| '(' expr ')'		{ $$ = $2; }
	| NUM			{ $$ = $1; }
	| ID			{
				  $$ = $1;
				}

stmt 	: ID ASGN expr ';'	{ if($1->TYPE!=INT || $3->TYPE!=INT)
					{printf("ASSIGNMENT ERROR");
					 exit(0);
					}
					
      				  $$ = TreeCreate(VOID, ASGN,0, NULL, NULL, $1, $3, NULL);
				}
	| READ '(' ID ')' ';' 	{ 
				  $$ = TreeCreate(VOID, READ, 0,NULL,  NULL, $3, NULL, NULL);
				}
     	| WRITE '(' expr ')' ';'{ $$ = TreeCreate(VOID, WRITE,0, NULL, NULL, $3, NULL, NULL);
				}
	| IF '(' expr ')' THEN slist ELSE slist ENDIF ';'
				{ 
				  $$ = TreeCreate(VOID, IF, 0,NULL, NULL, $3, $6, $8);
				}
	
	| WHILE '(' expr ')' DO slist ENDWHILE ';'
				{ 
				  $$ = TreeCreate(VOID, WHILE, 0, NULL, NULL, $3, $6, NULL);
				}
     	;


	

%%

int yyerror(char const *s)
{
	printf("yyerror %s", s);
}

int main()
{
	yyparse();
	return 1;
}
