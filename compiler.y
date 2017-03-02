
%{
	#define YYSTYPE struct Tnode*
	#include "abstree.c"
	#define VOID -1
	#define INTARR 1001
	#include <stdlib.h>
	#include <stdio.h>	
	int v_type;
	extern FILE* yyin;

%}

%token NUM ID READ WRITE ASGN NEWLINE IF THEN ELSE ENDIF WHILE DO ENDWHILE LT GT NEQ EQ STATEMENT BEG END INT BOOL  DECL ENDDECL CONTINUE BREAK 
%nonassoc LT GT EQ NEQ
%left PLUS
%left MUL 
%%
program:decls main    {exit(1);}
	|main 	      {exit(1);}
	;
decls :DECL declist ENDDECL {}
	;
declist :decl declist     {}
	 |decl            {}
	;


type : INT  {v_type=INT;}
      |BOOL {v_type=BOOL;}

decl : type idlist';' {}
	;

idlist: idlist','ID      {   //  printf("%s installed as  variable\n", $3->NAME); 
				Ginstall($3->NAME, v_type, sizeof(int));
				 }
	|idlist','ID'['NUM']'  {//	printf("installed as variable\n");
					Ginstall($3->NAME, INTARR, sizeof(int)*$5->VALUE);} 

	| ID		 {      //printf("%s installed as variable\n", $1->NAME);
				 Ginstall($1->NAME, v_type, sizeof(int)); 
					}
	|ID'['NUM']'	{	//printf(" installed as variable\n");
				Ginstall($1->NAME, INTARR, sizeof(int)*$3->VALUE);
			} 





	;
main :BEG slist END { evaluate($2); exit(0);}
	     ;
slist 	: slist stmt		{
      				  $$ = TreeCreate(VOID, STATEMENT, 0,NULL, NULL, $1, $2, NULL);
				}
	| stmt			{ $$ = $1; }
     	;


expr	: expr PLUS expr	{if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ARITHMETIC ERROR ");
						exit(0);}
				 $$ = makeOperatorNode(PLUS, $1, $3,BOOL); }
     	| expr MUL expr		{if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ARITHMETIC ERROR ");
						exit(0);} 
				 $$ = makeOperatorNode(MUL, $1, $3,INT); }
     	| expr EQ expr		{if(!(($1->TYPE == INT && $3->TYPE==INT)||($1->TYPE==BOOL && $3->TYPE==BOOL)))
						{printf(" ERROR ");
						exit(0);} $$ = makeOperatorNode(EQ, $1, $3,BOOL); }
	|expr NEQ expr		{if(!(($1->TYPE == INT && $3->TYPE==INT)||($1->TYPE==BOOL && $3->TYPE==BOOL)))
						{printf(" ERROR ");
						exit(0);} $$ = makeOperatorNode(NEQ, $1, $3,BOOL); }
		
     	| expr LT expr		{if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ERROR ");
						exit(0);}
				 $$ = makeOperatorNode(LT, $1, $3,BOOL); 
				}
     	| expr GT expr		{ if($1->TYPE != INT || $3->TYPE!=INT)
						{printf("ERROR ");
						exit(0);}
				$$ = makeOperatorNode(GT, $1, $3,BOOL); 
				}
	| '(' expr ')'		{ $$ = $2; }
	| NUM			{ $$ = $1; }
	| BOOL 			{$$ = $1;}
	| ID			{
				  $$ = $1;
				}
	|ID'['expr']'		{$$=TreeCreate(VOID,ID,0,$1->NAME,NULL,$3,NULL,NULL);}

stmt 	: ID ASGN expr ';'	{ //printf("assignment");
      				  $$ = TreeCreate(VOID, ASGN,0, NULL, NULL, $1, $3, NULL);
				}
	|ID'['expr']' ASGN expr ';' {
					struct Tnode *new_id_node = TreeCreate(-1, ID, -1, $1 -> NAME, NULL, $3, NULL, NULL);
					$$ = TreeCreate(VOID, ASGN, -1, NULL, NULL, new_id_node, $6, NULL);
				    }
				
	| READ '(' ID ')' ';' 	{ 
				  $$ = TreeCreate(VOID, READ, 0,NULL,  NULL, $3, NULL, NULL);
				}
	|READ '(' ID'['expr']'')'';'
					{
						struct Tnode *new_id_node = TreeCreate(VOID, ID, -1, $3 -> NAME, NULL, $5, NULL, NULL);
						$$ = TreeCreate(VOID, READ, -1, NULL, NULL, new_id_node, NULL, NULL);
					}
     	| WRITE '(' expr ')' ';'{ $$ = TreeCreate(VOID, WRITE,0, NULL, NULL, $3, NULL, NULL);
				}
	| IF '(' expr ')' THEN slist ENDIF ';'
				{
				  $$ = TreeCreate(VOID, IF, 0,NULL, NULL, $3, $6, NULL);
				}
	| IF '(' expr ')' THEN slist ELSE slist ENDIF ';'
				{
				  $$ = TreeCreate(VOID, IF,0, NULL, NULL, $3, $6, $8);
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

int main(int argc, char** argv)
{
	yyin = fopen(argv[1], "r");
	yyparse();
	return 1;
}
