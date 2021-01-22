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
%token OP_PLUS OP_MINUS OP_MULTIPLY  SP_LEFT SP_RIGHT RETURN   VOID epsilon  DEC_INT
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
TYPE : DEC_INT {}
	| VOID {}
	;
%%



// debug only !!!

void CallInMain();



int main() {


 // comment this .
 //CallInMain();
	
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



// ************************ DS 
//******* 


// classic MAP<STRING,int> 

#pragma region  diction ary 

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

#pragma endregion diction ary 






#pragma region  program block 

#define max_arr_size 200
#define max_op_size 10





//   struct  (op,add1,add2,add3)







//************ pb struct 

struct PB {
	
    char op[max_op_size];
    int* add1;
	int* add2;
	int* add3;
};


struct PB* _pb_arr[max_arr_size];
int _cur_pb_arr_ind = 0;




void AddPB(struct PB*  _pb){
		// check null 
		if(_pb == NULL){
			return ;
		}
		_pb_arr[_cur_pb_arr_ind++] = _pb;
		return;
}



struct PB*  _make_pb(const char* _op,int* add1,int* add2,int* add3 ){
	struct PB* _res  = malloc(sizeof(struct PB));
	//pb.op = _op 
	  memset(_res->op,'\0',max_op_size);
	  strcat(_res->op,_op);


	_res->add1 = add1;
	_res->add2 = add2;  
	_res->add3 = add3;



	return _res;  

	
}



void SetPB(struct PB* _pb,int _ind ){
	// check null 
		if(_pb == NULL){
			return ;
		}
	// check for valid index
		if(_cur_pb_arr_ind <= _ind   || _ind < 0 ){
			return;
		}

		_pb_arr[_ind] = _pb;

}




// debug only !!!!

void print_pb(){
	int i = 0;
	while(i<_cur_pb_arr_ind){
		printf(" %s %p %p %p \n",_pb_arr[i]->op,_pb_arr[i]->add1,_pb_arr[i]->add2,_pb_arr[i]->add3);
		i++;
	}
}





#pragma endregion program block 





#pragma region  debug 


void CallInMain(){
	int* p  = malloc(sizeof(int));
	AddPB(_make_pb("+",p,p,p));
	print_pb();
	SetPB(_make_pb("-",p,p,p),0);
	print_pb();





	exit(0);
}










#pragma endregion debug 




