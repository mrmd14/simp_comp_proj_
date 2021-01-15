%option noyywrap

%{
#include <stdio.h>
#include <string.h> /* for strdup */
#include <math.h>

#define YY_DECL int yylex()

#include "comp.tab.h"

%}

 

%%

[ \t]	; 
\n		{return SP_NEWLINE;}
"function"   {return FUNC;}
[0-9]+	{yylval.ival = atoi(yytext); return VAL_INT;}
[0-9]+\.[0-9]+	{yylval.fval = atof(yytext); return VAL_FLOAT;}
[a-z][a-z0-9]*     {yylval.id = (char *)  strdup(yytext); return ID;}
"+"		{return OP_PLUS;}
"("		{return SP_P0;}
")"		{return SP_P1;}
"{"		{return SP_B0;}
"}"		{return SP_B1;}
"$"		{return SIGN_DOLL;}
"<"		{return CMPOP_L;}
"<="		{return CMPOP_LE;}
">"		{return CMPOP_G;}
">="		{return CMPOP_GE;}
"=="		{return CMPOP_EE;}
"&&"		{return CND_AND;}
"||"		{return CND_OR;}
"!="		{return CMPOP_NE;}
"|"		{return OP_OR;}
"&"		{return OP_AND;}
"^"		{return OP_POWER;}
"!"		{return OP_NOT;}
"/"		{return OP_DIV;}
"=" {return ASSIGN;}
"-"		{return OP_MINUS;}
"*"		{return OP_MULTIPLY;}
","		{return  SIGN_COM;}



%%
