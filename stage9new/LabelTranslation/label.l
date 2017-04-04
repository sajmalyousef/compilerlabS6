%{	
    #include<stdio.h>
    #include<stdlib.h>
    int parse = 0;
    int instruct = 2040;
    int labarr[100];
    int farr[100];
    int main1;
    FILE * fp;
    FILE * bp;

%}

%%
[L][0-9]+[:][\n]?	{if(parse == 0) labarr[atoi(yytext+1)] = instruct;}
[F][0-9]+[:][\n]?	{if(parse==0) farr[atoi(yytext+1)]=instruct;}
"MAIN:"			{if(parse==0) main1=instruct;}		
[L][0-9]		{if(parse==1) fprintf(bp,"%d",labarr[atoi(yytext+1)]);}
[F][0-9]		{if(parse==1) fprintf(bp,"%d",farr[atoi(yytext+1)]);}
"MAIN"			{if(parse==1) fprintf(bp,"%d" ,main1);}
"\n"			{if(parse==0) { instruct += 2;} else fprintf(bp,"\n");}
.			{if(parse==1) fprintf(bp,"%s",yytext);}

%%

int main(int argc, char const *argv[])
{
	
	fp = fopen(argv[1],"r");
        yyin = fp;
        yylex();
        parse = 1;
	fp = fopen(argv[1],"r");
	bp = fopen("out2.xsm","w");
	yyin = fp;
	yylex();
	return 1;
}





int yywrap(){
	return 1;
}
