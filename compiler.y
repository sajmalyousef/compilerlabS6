	
%{
	#define YYSTYPE struct Tnode*
	#include "abstree.c"
	#define VOID -1
	#define T_INT -1003
	#define T_BOOL -1004

	#define TRUE -1006
	#define FALSE -1007
	#define INTARR 1001
	#define BOOLARR 1002
	#include <stdlib.h>
	#include <stdio.h>	
	int v_type;
	extern FILE* yyin;

%}

%token NUM ID READ WRITE ASGN NEWLINE IF THEN ELSE ENDIF WHILE DO ENDWHILE LT GT NEQ EQ STATEMENT BEG END INT BOOL  DECL ENDDECL CONTINUE BREAK BOOLEAN
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


type : INT  {v_type=T_INT;}
      |BOOL {v_type=T_BOOL;}

decl : type idlist';' {}
	;

idlist: idlist','ID      {   //  printf("%s installed as  variable\n", $3->NAME); 
				Ginstall($3->NAME, v_type, sizeof(int));
				 }
	|idlist','ID'['NUM']'  {//	printf("installed as variable\n");
					if($5->TYPE!=T_INT)
					{printf("Type error in array\n");
					exit(0); }
					if(v_type==T_INT)
						Ginstall($3->NAME, INTARR, sizeof(int)*$5->VALUE);
					else if(v_type==T_BOOL)
						Ginstall($3->NAME, BOOLARR, sizeof(int)*$5->VALUE);
				} 

	| ID		 {      //printf("%s installed as variable\n", $1->NAME);
				 Ginstall($1->NAME, v_type, sizeof(int)); 
				 
					}
	|ID'['NUM']'	{	//printf(" installed as variable\n");
				if($3->TYPE!=T_INT)
					{printf("Type error in array declaration.\n");
					exit(0); }
				if(v_type==T_INT)
						Ginstall($1->NAME, INTARR, sizeof(int)*$3->VALUE);
				else if(v_type==T_BOOL)
						Ginstall($1->NAME, BOOLARR, sizeof(int)*$3->VALUE);
			} 





	;
main :BEG slist END { evaluate($2); exit(0);}
	     ;
slist 	: slist stmt		{ if($1->TYPE !=VOID||$2->TYPE!=VOID)
					{printf("TYPE ERROR");
					 exit(0);
					} 
      				  $$ = TreeCreate(VOID, STATEMENT, 0,NULL, NULL, $1, $2, NULL);
				}
	| stmt			{ $$ = $1; }
     	;


expr	: expr PLUS expr	{  //printf("%s",$1->TYPE);
			         if($1->TYPE != T_INT || $3->TYPE!=T_INT)
						{printf("ARITHMETIC ERROR + ");
						exit(0);} 	
				 $$ = makeOperatorNode(PLUS, $1, $3,T_INT); }
     	| expr MUL expr		{if($1->TYPE != T_INT || $3->TYPE!=T_INT)
						{printf("ARITHMETIC ERROR * ");
						exit(0);} 
				 $$ = makeOperatorNode(MUL, $1, $3,T_INT); }
     	| expr EQ expr		{if($1->TYPE != T_INT || $3->TYPE==T_INT)
						{printf(" ERROR ==");
						exit(0);} $$ = makeOperatorNode(EQ, $1, $3,BOOL); }
	|expr NEQ expr		{if($1->TYPE != T_INT || $3->TYPE!=T_INT)
						{printf(" ERROR !=");
						exit(0);} $$ = makeOperatorNode(NEQ, $1, $3,T_BOOL); }
		
     	| expr LT expr		{if($1->TYPE != T_INT || $3->TYPE!=T_INT)
						{printf("ERROR <");
						exit(0);}
				 $$ = makeOperatorNode(LT, $1, $3,T_BOOL); 
				}
     	| expr GT expr		{ if($1->TYPE != T_INT || $3->TYPE!=T_INT)
						{printf("ERROR >");
						exit(0);}
				$$ = makeOperatorNode(GT, $1, $3,T_BOOL); 
				}
	| '(' expr ')'		{ $$ = $2; }
	| NUM			{ $$ = $1; }
	| BOOLEAN 			{$$ = $1;}
	| ID			{$1->TYPE = Glookup($1->NAME)->TYPE;
				  $$ = $1;
				}
	|ID'['expr']'		{    if(Glookup($1->NAME)->SIZE/sizeof(int)<$3->VALUE)
					{
						printf("ARRAY OVERFLOEW");
						exit(0);
					}   
					//printf("%d",$1->VALUE);
					if($3->TYPE!=T_INT)
					{printf("type error :[]");
					 exit(0);}
					
								
					$$=TreeCreate(VOID,ID,0,$1->NAME,NULL,$3,NULL,NULL);}

stmt 	: ID ASGN expr ';'	{ //printf("assignment");
				  if(Glookup($1->NAME)->TYPE != $3->TYPE)
       					{
						printf("type error: ASSG");
						exit(0);
					}
      				  $$ = TreeCreate(VOID, ASGN,0, NULL, NULL, $1, $3, NULL);
				}
	|ID'['expr']' ASGN expr ';' {	if(Glookup($1->NAME)->TYPE == INTARR  )
       						{	if($3->TYPE != T_INT || $6->TYPE != T_INT)
								printf("type error: []=");
							exit(0);
						}
					else if(Glookup($1->NAME)->TYPE == BOOLARR  )
       						{	printf("%d",$6->TYPE);
							if($3->TYPE != T_INT || $6->TYPE != T_BOOL)
								printf("type error: []=");
							exit(0);
						}
					else
						{
							printf("type error");
							exit(0);
						}
					struct Tnode *new_id_node = TreeCreate(-1, ID, -1, $1 -> NAME, NULL, $3, NULL, NULL);
					$$ = TreeCreate(VOID, ASGN, -1, NULL, NULL, new_id_node, $6, NULL);
				    }
				
	| READ '(' ID ')' ';' 	{ //printf("%d",$3->TYPE); 
					if($3->TYPE!=T_INT)
							{printf("READING A BOOLEAN NOT ALLOWED");
							 exit(0);}
				  $$ = TreeCreate(VOID, READ, 0,NULL,  NULL, $3, NULL, NULL);
				}
	|READ '(' ID'['expr']'')'';'
					{	if($3->TYPE!=INTARR)
							{printf("READING A BOOLEAN NOT ALLOWED");
							 exit(0);}
						struct Tnode *new_id_node = TreeCreate(VOID, ID, -1, $3 -> NAME, NULL, $5, NULL, NULL);
						$$ = TreeCreate(VOID, READ, -1, NULL, NULL, new_id_node, NULL, NULL);
					}
     	| WRITE '(' expr ')' ';'{ $$ = TreeCreate(VOID, WRITE,0, NULL, NULL, $3, NULL, NULL);
				}
	| IF '(' expr ')' THEN slist ENDIF ';'
				{ if($3->TYPE != T_BOOL)
       					{
						printf("type error:if ");
						exit(0);
					}   
      					if($6->TYPE != VOID)
       					{
						printf("type error");
						exit(0);
					}   
				  $$ = TreeCreate(VOID, IF, 0,NULL, NULL, $3, $6, NULL);
				}
	| IF '(' expr ')' THEN slist ELSE slist ENDIF ';'
				{ if($3->TYPE != T_BOOL)
       					{
						printf("type error:if ");
						exit(0);
					}   
      					if($6->TYPE != VOID)
       					{
						printf("type error");
						exit(0);
					}   
					if($8->TYPE != VOID)
       					{
						printf("type error");
						exit(0);
					} 
				  $$ = TreeCreate(VOID, IF,0, NULL, NULL, $3, $6, $8);
				}
	| WHILE '(' expr ')' DO slist ENDWHILE ';'
				{ if($3->TYPE != T_BOOL)
       					{
						printf("type error: WHILE");
						exit(0);
					}   
      					if($6->TYPE != VOID)
       					{
						printf("type error: WHILE");
						exit(0);
					}   
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
