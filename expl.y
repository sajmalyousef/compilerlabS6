%{
	#include <stdio.h>
	#include <stdlib.h>
	
	int yylex(void);
	int *var[26];
%}




%union{ char character;
	int integer;}
	
                              
                                        
%type <integer> expr
%type <integer> NUM
%type <character> ID

%token  PLUS NUM ID MUL READ WRITE ASGN 
%left PLUS 
%left MUL 
%%
Program : slist '\n'     {exit(0);}
                 ;
slist   : slist stmt
         | stmt
         ;




stmt : ID ASGN expr ';'         {
				if(var[$1-'a'] ==NULL)
					var[$1-'a'] = malloc(sizeof(int));
				*var[$1-'a'] = $3;
				}
      | READ '(' ID ')' ';'	{if(var[$3-'a'] == NULL){
    					var[$3-'a'] = malloc(sizeof(int));
					}
				scanf("%d",var[$3-'a']);
				}
      | WRITE '(' expr ')' ';'  { printf("%d",$3);}
      ;
expr : expr PLUS expr		{$$ = $1 + $3;}
	 | expr MUL expr	{$$ = $1 * $3;}
	 | '(' expr ')'	         {$$ = $2;}
	 | ID		{
            			if( var[$1-'a'] == NULL)
                			printf("unassinged varaiable");
           			else
               				 $$ = *var[$1-'a'];
         		 }
	 |NUM		{$$=$1;}	
	 ;



%%


yyerror(char const *s)
{
    printf("yyerror %s",s);
}


int main(void) {
	yyparse();
	return 0;
}
