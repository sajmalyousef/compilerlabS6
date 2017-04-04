#include "y.tab.h"
#include "sym_table.h"
#include "lsym_table.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

extern struct Gsymbol *GST;		//global variable
int nextFreeLocation = 4096;		//space for global variable starts from 4096

struct Gsymbol *Glookup(char *name){ // Look up for a global identifier
	struct Gsymbol *tmp = GST;
	while (tmp != NULL){
		if (strcmp(tmp->name, name) == 0){			//if matching name found from GST
			return tmp;
		}
		tmp = tmp->next;
	}
	return NULL;
}

void Ginstall(char* name, int type, int size, struct Paramstruct *paramlist) {	//install a global variable or a globalfunction
 	struct Gsymbol *i;

 	if (GST == NULL) {				//if no previous entry in GST
 		GST = malloc(sizeof(struct Gsymbol));
 		i = GST;
 	}
 	else {			
 		i = GST;
 		while(i->next != NULL){
 			if (name == i -> name){		//if the entry already exists
	 			printf("Variable %s already declared once globally\n", name);
	 			exit(-1);
	 		}
 			i = i->next;
	 	}

 		i->next = malloc(sizeof(struct Gsymbol));
 		i = i->next;
 	}

 	i->name = name;
 	i->type = type;
 	i->size = size;
 	i->paramlist = paramlist;//in case of functions paramlist is present
 	if (paramlist != NULL){
	 	i->binding = -1;	//binding set as -1
	 	i->flabel = -1;
 	}

 	else if(type == INT || type == BOOL || type == INTARR || type == BOOLARR){		// integer
 		i->binding = nextFreeLocation;	//for global variables
 		nextFreeLocation += size;
 	}
 	else
 		printf("Wrong type\n");
}
