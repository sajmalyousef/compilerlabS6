
#include <stdlib.h>
#include <stdio.h>
#include "abstree.h"

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


struct Tnode* makeLeafNode(int n){
    struct Tnode *temp;
    temp = (struct Tnode*)malloc(sizeof(struct Tnode));
    bzero(temp, sizeof(struct Tnode));
    temp->TYPE = INT;
    temp->NODETYPE = NUM;
    temp->VALUE = n;

    return temp;
}
struct Tnode* makeOperatorNode(int op, struct Tnode *l, struct Tnode *r)
{
    struct Tnode *temp;
    temp = (struct Tnode*)malloc(sizeof(struct Tnode));
    bzero(temp, sizeof(struct Tnode));
    temp->TYPE = BOOL;
    temp->NODETYPE = op;
    temp->Ptr1= l;
    temp->Ptr2 = r;
    return temp;
}


int evaluate(struct Tnode *t){
	struct Tnode *temp;
	char name;
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
	    case READ:{
			temp = t->Ptr1;
			name = (temp->NAME)[0];
			if(var[name - 'a']==NULL)
				var[name - 'a'] = (int *) malloc (sizeof(int));
			scanf("%d", var[name - 'a']);
			return 0;
			break;
		      }

	    case WRITE:{
			printf("%d",evaluate(t->Ptr1));
			return 0;
			break;
			}
	    case ASGN : {
			temp = t->Ptr1;
			name = (temp->NAME)[0];
			 if(var[name - 'a']==NULL)
				var[name - 'a'] = (int *) malloc (sizeof(int));
			 *var[name-'a']=evaluate(t->Ptr2);
			 return 0;
			 break;

                        }
	  case IF :     {
			if(evaluate(t->Ptr1))
				return evaluate(t->Ptr2);
			else
				return evaluate(t->Ptr3);
			return 0;
			break;
			}
	
	case WHILE:	{
			while(evaluate(t->Ptr1))
				evaluate(t->Ptr2);
			return 0;
			break;
			}
	case ID:        {
			 if(var[(t->NAME)[0]-'a']==NULL)
				exit(0);
			 else
				return *var[(t->NAME)[0]-'a'];
			break;
			}
      case STATEMENT:
	        evaluate(t->Ptr1);
	        evaluate(t->Ptr2);
		return 0;
		break;

     default: exit(0);
    }
}







