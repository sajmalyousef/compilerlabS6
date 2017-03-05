
#include <stdlib.h>
#include <stdio.h>
#include "abstree.h"
#include "Symboltable.c"
extern int* var[26];





struct Tnode *TreeCreate(int TYPE, int NODETYPE,int VALUE,char* NAME,struct Tnode *ArgList, struct Tnode *Ptr1, struct Tnode *Ptr2, struct Tnode *Ptr3)

	{

		 struct Tnode *temp;
		 temp = (struct Tnode*)malloc(sizeof(struct Tnode));
		 temp->NAME = NAME;
		 //printf("%s",temp->NAME);
		 temp->TYPE = TYPE;
		 temp->NODETYPE=NODETYPE;
		 temp->ArgList=ArgList;
		 temp->Ptr1=Ptr1;
		 temp->Ptr2=Ptr2;
		 temp->Ptr3=Ptr3;
		 return temp;
	}


struct Tnode* makeLeafNode(int n,int TYPE){
    struct Tnode *temp;
    temp = (struct Tnode*)malloc(sizeof(struct Tnode));
    bzero(temp, sizeof(struct Tnode));
    temp->TYPE = TYPE;
    temp->NODETYPE = NUM;
    temp->VALUE = n;

    return temp;
}

struct Tnode* makeOperatorNode(int op, struct Tnode *l, struct Tnode *r,int TYPE)
{
   
   struct Tnode *temp;
    temp = (struct Tnode*)malloc(sizeof(struct Tnode));
    bzero(temp, sizeof(struct Tnode));
    temp->TYPE = TYPE;
    temp->NODETYPE = op;
    temp->Ptr1= l;
    temp->Ptr2 = r;
    return temp;
}


int evaluate(struct Tnode *t){
	struct Tnode *temp;
	char name;
	int tmp;
	//printf("in evaluate");
        switch(t->NODETYPE){
	    case NUM : return t->VALUE;
		       break;

            case PLUS : return evaluate(t->Ptr1) + evaluate(t->Ptr2);
                       break;
            case LT : return evaluate(t->Ptr1) < evaluate(t->Ptr2);
                       break;
            case MUL : return evaluate(t->Ptr1) * evaluate(t->Ptr2);
                       break;
            case GT : return evaluate(t->Ptr1) > evaluate(t->Ptr2);
                       break;
	    case EQ : return evaluate(t->Ptr1) == evaluate(t->Ptr2);
                       break;
	    case NEQ: return evaluate(t->Ptr1)!=evaluate(t->Ptr2);
	    case READ:{
			if(Glookup(t->Ptr1->NAME)==NULL)                            //search for symbol table entry
				{printf("Unallocated variable");
				exit(0);}
			if(t->Ptr1->Ptr1!=NULL)
				{
				  int index=evaluate(t->Ptr1->Ptr1);
				  scanf("%d",Glookup(t->Ptr1->NAME)->BINDING+index);
				}
			else
				scanf("%d", Glookup(t->Ptr1->NAME)->BINDING);			
			return 0;
			break;
		      }

	    case WRITE:{
			printf("%d",evaluate(t->Ptr1));
			return 0;
			break;
			}
	    case ASGN : {
			 
			 if(Glookup(t->Ptr1->NAME)==NULL)
				{
					printf("Unallocated variable '%s'", t->NAME);
					exit(0);
				}
			 if(t->Ptr1->Ptr1==NULL)					//not an array	
			 	*(Glookup(t->Ptr1->NAME)->BINDING) = evaluate(t->Ptr2);
			 else								//an integer array
				{int index=evaluate(t->Ptr1->Ptr1);
				 *(Glookup(t->Ptr1->NAME)->BINDING+index) = evaluate(t->Ptr2);
				}
		
			 //return 0;
			 break;

                        }
	  case IF :     {
			if(evaluate(t->Ptr1))
				return evaluate(t->Ptr2);
			else if(t->Ptr3!=NULL)
				return evaluate(t->Ptr3);
			return 0;
			break;
			}
	
	case WHILE:	{
			while(evaluate(t->Ptr1))
				{int tmp=evaluate(t->Ptr2);
				if(tmp==BREAK)
					break;
				if(tmp==CONTINUE)
					continue;
				}
			return 0;
			break;
			}
	case ID:       	{													
			if(Glookup(t->NAME)  == NULL)
			{
				exit(0);
			}
			if(t->Ptr1==NULL)							//check if it has a subnode(array's index)
				return *(Glookup(t->NAME) -> BINDING);
			else
				{
				 int index=evaluate(t->Ptr1);
				 return *(Glookup(t->NAME)->BINDING+index);
				}
			break;
			}
      case BREAK: return BREAK;
	          break;
      case CONTINUE: return CONTINUE;
      			break;
      case STATEMENT:
	        tmp=evaluate(t->Ptr1);
		if(tmp==BREAK)
			return BREAK;
		if(tmp==CONTINUE)
			return CONTINUE;
	        evaluate(t->Ptr2);
		return 0;
		break;

     default: exit(0);
    }
}







