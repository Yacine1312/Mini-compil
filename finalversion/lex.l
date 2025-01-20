%{
#include<stdio.h>
#include<string.h>
#include "syntax.tab.h"
#include "ts.h"
extern int nb_line;
extern int Col;
extern YYSTYPE yylval;
%}
lettre [a-zA-Z]
chiffre [0-9]
IDF {lettre}({lettre}|{chiffre})*
INTEGER   [0-9]+|\([-+]?[0-9]+\) 
FLOAT [0-9]+\.[0-9]+|\([-+]?[0-9]+.[0-9]+\) 
opt [*/]
sopt [+-]
optcompar "=="|"!="|"<="|">="|"<"|">"
%%
"/*"(.|\n)*"*/" {
      const char* commentContent = yytext + 3; // Skip the "/*" at the beginning
      Col+= yyleng;
      while (*commentContent) {
        Col+= yyleng;
          if (*commentContent == '\n') {
              nb_line++;
              Col= 1;
          }
          commentContent++;
      }
      nb_line=nb_line;
    printf("comment reconnu  %s\n", yytext); 
    }
"//"[^\n].* {printf("comment reconnu  %s\n", yytext); }
PROGRAMME {Col = Col+strlen(yytext);printf("prog reconnu  %s\n", yytext);insert(yytext,"kw_program","",0,2);yylval.str=strdup(yytext);return kw_program;}
VAR {Col = Col + strlen(yytext);printf("boc de var  %s\n", yytext);insert(yytext,"kw_var","",0,2);yylval.str=strdup(yytext);return kw_var;}
"'".*"'" {Col = Col + strlen(yytext); printf("chaine de car reconnu  %s\n", yytext);insert(yytext,"kw_chaine","",0,2);yylval.str=strdup(yytext);return kw_chaine;}
BEGIN {Col = Col + strlen(yytext) ; printf("begin reconnu  %s\n", yytext);insert(yytext,"kw_begin","",0,2);yylval.str=strdup(yytext);return kw_begin;}
END. {Col = Col + strlen(yytext) ;printf("end reconnu  %s\n", yytext);insert(yytext,"kw_end","",0,2);yylval.str=strdup(yytext);return kw_end;}
INTEGER {Col = Col + strlen(yytext); printf("kw_integer reconnu  %s\n", yytext);insert(yytext,"kw_int","",0,2);yylval.str=strdup(yytext);return kw_int;}
FLOAT {Col = Col + strlen(yytext); printf("kw_float reconnu  %s\n", yytext);insert(yytext,"kw_float","",0,2);yylval.str=strdup(yytext);return kw_float;}
IF {Col = Col + strlen(yytext); printf("kw_if reconnu  %s\n", yytext);insert(yytext,"kw_if","",0,2);yylval.str=strdup(yytext);return kw_if;}
ELSE { Col = Col + strlen(yytext); printf("kw_else reconnu  %s\n", yytext);insert(yytext,"kw_else","",0,2);yylval.str=strdup(yytext);return kw_else;}
WHILE {Col = Col + strlen(yytext); printf("kw_while reconnu  %s\n", yytext);insert(yytext,"kw_while","",0,2);yylval.str=strdup(yytext);return kw_while;}
FOR { Col = Col + strlen(yytext);printf("kw_for reconnu  %s\n", yytext); insert(yytext,"kw_for","",0,2);yylval.str=strdup(yytext);return kw_for;}
ReadIn {Col = Col + strlen(yytext); printf("kw_read reconnu  %s\n", yytext);insert(yytext,"kw_read","",0,2);yylval.str=strdup(yytext);return kw_read;}
WriteIn {Col = Col + strlen(yytext);printf("kw_write reconnu  %s\n", yytext);insert(yytext,"kw_write","",0,2);yylval.str=strdup(yytext);return kw_write;}
CONST {Col = Col + strlen(yytext) ; printf("kw_const reconnu  %s\n", yytext);insert(yytext,"kw_const","",0,2);yylval.str=strdup(yytext);return kw_const;}
{INTEGER} {
    Col += strlen(yytext);
    char* x = yytext;
    if(x[0]=='(' && x[1]=='+'){
        int y=atoi(x+2);
        if (y >= -32768 && y <= 32767) {
        printf("entier reconnu  %d\n", y);
        insert(yytext,"kw_int","integer",y,0); 
        yylval.integer= y;
        return integer;
        }
        else{
        printf("Erreur Lexicale : la ligne %d entier hors limites (%s)\n",nb_line, yytext);
        } 
        }
    if(x[0]=='(' && x[1]=='-'){
        int y=atoi(x+2);
        if (y >= -32768 && y <= 32767) {
        printf("entier reconnu  %d\n",y); 
        y=y*(-1);   
        insert(yytext,"kw_int","integer",y,0); 
        yylval.integer= y;
        return integer;}
        else{
       printf("Erreur Lexicale : la ligne %d entier hors limites (%s)\n",nb_line, yytext);
       }
    }
    else {
       int y=atoi(x);
       if (y >= -32768 && y <= 32767)
       {
         printf("entier reconnu  %d\n", atoi(yytext));
        insert(yytext,"kw_int","integer",y,0); 
        yylval.integer= y;
        return integer;
        }
       else{
        printf("Erreur Lexicale : la ligne %d entier hors limites (%s)\n",nb_line, yytext);
        }
}
}
{FLOAT} {Col = Col + strlen(yytext);
        yylval.reel = atof(yytext);
        printf("float reconnu  %f\n", atof(yytext));
        insert(yytext,"kw_float","reel",atof(yytext),0);
	    return reel;}
     
{IDF} {
    if (yyleng > 7) {
        printf("Erreur lexicale : IDF trop long (%s)\n", yytext);
    } else {
        printf("IDF reconnu %s:\n",yytext);
        insert(yytext,"idf","",0,0);
        yylval.str=strdup(yytext);
        return idf;
    }
}
"&&" {Col = Col + strlen(yytext); printf("sp_and reconnu %s\n",yytext);insert(yytext,"and","",0,1);yylval.str=strdup(yytext);return and;}
"||" {Col = Col + strlen(yytext); printf("sp_or reconnu %s\n",yytext);insert(yytext,"or","",0,1);yylval.str=strdup(yytext);return or;}
"!" {Col = Col + strlen(yytext); printf("sp_not reconnu %s\n",yytext);insert(yytext,"not","",0,1); yylval.str=strdup(yytext);return not;}
{opt} {Col = Col + strlen(yytext); printf("sp reconnu %s\n",yytext);insert(yytext,"mul div","",0,1);yylval.str=strdup(yytext);return opt;}
{sopt} {Col = Col + strlen(yytext);printf("sp reconnu %s\n",yytext); insert(yytext,"add minus","",0,1);yylval.str=strdup(yytext);return sopt;}
{optcompar} {Col = Col + strlen(yytext); printf("sp reconnu %s\n",yytext);insert(yytext,"operation_compa","",0,1);yylval.str=strdup(yytext);return optcompar;}
":" {Col = Col + strlen(yytext); printf("sp_dpoint reconnu %s\n",yytext);insert(yytext,"doubl_point","",0,1);yylval.str=strdup(yytext);return dpoint;}
"=" {Col = Col + strlen(yytext); printf("sp_aff reconnu %s\n",yytext);insert(yytext,"assig","",0,1);yylval.str=strdup(yytext);return assig;}
"," {Col = Col + strlen(yytext); printf("cm reconnu %s\n",yytext);insert(yytext,"comma","",0,1);yylval.str=strdup(yytext);return cm;}
"{" {Col = Col + strlen(yytext); printf("sp_acco reconnu %s\n",yytext);insert(yytext,"acc_op","",0,1);yylval.str=strdup(yytext);return acc_op;}
"}" {Col = Col + strlen(yytext); printf("sp_accf reconnu %s\n",yytext);insert(yytext,"acc_cl","",0,1);yylval.str=strdup(yytext);return acc_cl;}
"(" {Col = Col + strlen(yytext); printf("sp_paro reconnu %s\n",yytext);insert(yytext,"par_op","",0,1);yylval.str=strdup(yytext);return par_op;}
")" {Col = Col + strlen(yytext); printf("sp_parf reconnu %s\n",yytext);insert(yytext,"par_cl","",0,1);yylval.str=strdup(yytext);return par_cl;}
"[" {Col = Col + strlen(yytext); printf("sp_croch reconnu %s\n",yytext);insert(yytext,"hook_op","",0,1);yylval.str=strdup(yytext);return hook_op;}
"]" {Col = Col + strlen(yytext); printf("sp_crouch reconnu %s\n",yytext);insert(yytext,"hook_cl","",0,1);yylval.str=strdup(yytext);return hook_cl;}
";" {Col = Col + strlen(yytext); printf("sc reconnu %s\n",yytext);insert(yytext,"sc","",0,1);yylval.str=strdup(yytext);return sc;}
[ \t] {Col = Col + strlen(yytext);}
\n {nb_line++; Col = 1;}
. { printf("Erreur lexicale à la ligne %d et la colomn %d: %s\n", nb_line,Col,yytext);}
