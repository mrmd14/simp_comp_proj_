%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h> /* For strcmp in symbol table */



#define epsilon  EP



extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
void  lookupId(const char * _id,int _set);
int getIdVal(const char* _id);


%}

%union {
	int ival;
	char * id;   
	float fval;
}

%token<ival> VAL_INT
%token<fval> VAL_FLOAT
%token <id> ID
%type<ival> EXP   
%token OP_PLUS OP_MINUS OP_MULTIPLY  SP_LEFT SP_RIGHT RETURN   VOID epsilon
%token SP_P0 SP_P1 SP_B0 SP_B1 SIGN_DOLL SIGN_COM
%token CMPOP_EE CMPOP_G CMPOP_GE CMPOP_L CMPOP_LE CMPOP_NE
%token CND_AND CND_OR 
%token OP_AND OP_OR  OP_POWER OP_NOT 
%token  OP_DIV
%token SP_NEWLINE 
%token ASSIGN; /*=*/
%left OP_PLUS OP_MINUS
%left OP_MULTIPLY OP_DIV
%type<id> ide









%%


PROGRAM : STMT_DECLARE  PGM {}
		  ;
PGM  : TYPE ID SP_P0 SP_P1  SP_B0 STMTS  SP_B1  PGM {}
	| epsilon {}
	;

STMTS : STMT STMTS {} 
    | epsilon {}
	;
STMT : STMT_DECLARE {}
	| STMT_ASSIGN {}
	|  STMT_RETURN {}
	| SIGN_DOLL {}
	;
EXP  : EXP  CMPOP_L EXP {}
	| EXP  CMPOP_LE EXP {}
	| EXP  CMPOP_G EXP {}
	| EXP  CMPOP_GE EXP {}
	| EXP  CMPOP_EE EXP {}
	| EXP  CMPOP_NE EXP {}
	| EXP  OP_PLUS EXP {}
	| EXP  OP_MINUS EXP {}
	| EXP  OP_MULTIPLY EXP {}
	| EXP  CND_AND EXP {}
	| EXP  CND_OR EXP {}
	| EXP  OP_OR EXP {}
	| EXP  OP_AND EXP {}
	| EXP  OP_POWER EXP {}
	| OP_NOT  EXP {}
	| OP_MINUS  OP_POWER EXP {}
	| SP_P0 EXP  SP_P1 {}
	| ID {}
	;

STMT_DECLARE : TYPE ID IDS {}
  ;
IDS : SIGN_DOLL {}
	  | SIGN_COM ID IDS {}
	  ;
STMT_ASSIGN : ID ASSIGN EXP SIGN_DOLL {}
;
STMT_RETURN : RETURN EXP SIGN_DOLL {}
;
TYPE : VAL_INT {}
	| VOID {}
	;
%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}



// classic MAP<STRING,int> 



#define FOUND 0


#define NOT_FOUND -1

#define MAXBUFF 256 

struct entry {
    char str[MAXBUFF];
    int n;
};





struct entry mp_s_i[MAXBUFF];
int mp_roof = 0;


int  findInd (const char* _s){
		
int  i = 0;
	while(i<mp_roof){

			
		if (strcmp  (mp_s_i[i].str,_s) == FOUND  ){
				
			return i;

		}// if str cmp 
		i++;
		}// while i 
		
		return NOT_FOUND;
}


// fix over flow 
void    lookupId(const char* _s,int _set ) {
		int i =findInd(_s);
		int j = 0;
		if(i == NOT_FOUND){
		
			// deep copy 
			
		//	bzero(mp_s_i[i].str,MAXBUFF-1);
			while(_s[j] != '\0' ){
				mp_s_i[mp_roof].str[j] = _s[j];
				j++;
			}
				mp_s_i[mp_roof].str[j] = '\0';
			
			
			mp_s_i[mp_roof++].n = _set;
			return _set;
		}// if  404 

		else {
			
			 mp_s_i[i].n = _set;
			 
			 return;
		
		}
		


	}


int getIdVal(const char* _s){
		int i = findInd(_s);
		
		if(i == NOT_FOUND){
				return 0;
		}// if  404 

		else {
			
			return mp_s_i[i].n;
		}
}


