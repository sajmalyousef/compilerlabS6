#include "y.tab.h"
#include "sym_table.h"
#include "lsym_table.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

extern struct Lsymbol *LST;
extern int nextLocation;

struct Lsymbol* Linstall(char *name, int type, int size){
	struct Lsymbol *i;

 	if (LST == NULL) {						//check if LST is empty
 		LST = malloc(sizeof(struct Lsymbol));
 		i = LST;
 	}
 	else {
 		i = LST;					//if variable already exist exit 
 		while(i->next != NULL){				//find empty space in LST
 			if (name == i -> name){
	 			printf("Variable %s already declared once locally\n", name);
	 			exit(-1);
	 		}
 			i = i->next;
	 	}

 		i->next = malloc(sizeof(struct Lsymbol));
 		i = i->next;
 	}

 	i->name = name;				//set LST entry
 	i->type = type;

 	if(type == INT || type == BOOL || type == INTARR || type == BOOLARR){		// integer
 		i->binding = nextLocation;		//binding starts from 1 
 		nextLocation += size;			//increment it by size
 	}
 	else
 		printf("Wrong type\n");			//if type is not valid exit
}

struct Lsymbol* LLookup(char *name){		//search in LST for a variable by name
	struct Lsymbol *tmp = LST;		
	while (tmp != NULL){
		if (strcmp(tmp->name, name) == 0){		//if names in LST and given name matches return it
			return tmp;
		}
		tmp = tmp->next;
	}
	return NULL;		//match not found return NULL
}
