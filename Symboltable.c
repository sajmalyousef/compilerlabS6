#include "Symboltable.h"

#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#define T_INT -1003
#define T_BOOL -1004
#define TRUE -1006
#define FALSE -1007
#define INTARR 1001
#define BOOLARR 1002
extern struct Gsymbol * GST;

struct Gsymbol *Glookup(char* NAME)
{
	struct Gsymbol *i = GST;
	while(i != NULL)
	{
		if (strcmp(NAME, i->NAME) == 0)
			return i;
		i = i->NEXT;
	}

	return NULL;
}

void Ginstall(char* NAME, int TYPE, int SIZE)
{
	struct Gsymbol *i;
	if(Glookup(NAME)!=NULL)
		{printf("Variable already exists");
		exit(0);}
	if (GST == NULL)
	{
		GST = malloc(sizeof(struct Gsymbol));
		i = GST;
	}
	else
	{
		i = GST;
		while(i->NEXT != NULL)
			i = i->NEXT;

		i->NEXT = malloc(sizeof(struct Gsymbol));
		i = i->NEXT;
	}

	i->NAME = NAME;
	i->TYPE = TYPE;
	i->SIZE = SIZE;
	//printf("%d",i->TYPE);
	i->BINDING = malloc(SIZE);
}
