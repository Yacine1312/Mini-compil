%{
#include<stdio.h>
#include<stdlib.h>
int nb_line = 1, Col = 1;
int yylex();
int yyerror(){printf("Erreur syntax a la ligne %d la colonne %d \n",nb_line,Col); return 1;}
%}

%union {
         int     integer;
         char*   str;
         float   reel;
}
%token kw_program <str>idf <str>kw_chaine kw_begin kw_var <integer>integer <reel>reel kw_end kw_int kw_float kw_if kw_else kw_while kw_for kw_read kw_write kw_const and or not opt sopt optcompar dpoint assig sc cm acc_op acc_cl par_op par_cl hook_op hook_cl 
%left opt
%left sopt
%left not and or
%left  optcompar
%%
S: kw_program idf  kw_var acc_op LIST_DEC acc_cl kw_begin LIST_INST kw_end {
    printf("syntax correct\n");
    printf("\n --------------------------- \n");
    printf("\n Compilation reussie !.\n");
    printf("\n --------------------------- \n") YYACCEPT;}
;
/* les regles de declartion */
LIST_DEC: T DEC1 LIST_DEC|  
;
DEC1: DVAR|DTAB|DCNST
;
DVAR:T LVAR|LVAR
;
T:kw_int|kw_float
;
DTAB:T LTAB|LTAB
;
DCNST:kw_const CAS1
;
/* CAS:CAS1|CAS2
; */
LVAR:idf sc |idf cm LVAR
;
LTAB:idf hook_op integer hook_cl sc | idf hook_op integer hook_cl cm LTAB
;
CAS1:idf assig integer sc| idf assig integer cm CAS1
;
/* CAS2:idf cm CAS2| idf sc
; */
CHF: integer|reel
/* liste instruction */
LIST_INST: INST LIST_INST | 
;
INST: INST_AFF|INST_IF|INST_ELSE|INST_FOR|INST_WHILE|INST_READ|INST_WRITE
;
INST_WRITE: kw_write par_op kw_chaine par_cl sc
;
INST_READ:kw_read par_op idf par_cl sc
;
/* instruction affectation */
INST_AFF: idf assig EXP sc 
;
EXP:TERM EXP1
;
EXP1: sopt TERM EXP1|
;
TERM:FACT TERMPREM
;
FACT: par_op EXP par_cl| TYPE
;
TERMPREM:opt FACT TERMPREM |
;
/* if instruction */
INST_IF:kw_if LIST_CND acc_op LIST_INST acc_cl
;
/* liste condition */
LIST_CND: LIST_CND and EXPCOMP
          | EXPCOMP
          |LIST_CND or EXPCOMP
          | not EXPCOMP
;
EXPCOMP:VAL optcompar VAL
        |par_op LIST_CND par_cl
        /* |idf */
;
VAL:TYPE|par_op LIST_CND par_cl
;
TYPE:idf|CHF
;
INST_ELSE:kw_else acc_op LIST_INST acc_cl | kw_else kw_if par_op TYPE par_cl acc_op LIST_INST acc_cl |kw_else acc_op kw_if TYPE acc_op LIST_INST acc_cl acc_cl
;
INST_FOR:kw_for par_op idf dpoint CHF dpoint CHF dpoint idf par_cl acc_op LIST_INST acc_cl
;
INST_WHILE: kw_while par_op LIST_CND par_cl acc_op LIST_INST acc_cl
;
/* OPT: opt | sopt |optcompar
; */
%%
int main() 
{
yyparse();
print();

}
int yywrap()
{}
