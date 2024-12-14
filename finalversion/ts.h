#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct
{
   char name[30];
   char code[30];
   char type[30];
   float value;
 } elt_idf_cst;

typedef struct
{  
   char name[20];
   char code[20];
} elt_sep_kw;

elt_idf_cst ts_idf_cst[1000];
elt_sep_kw ts_sep[40],ts_kw[40];

int count_idf_cst=0, count_kw=0, count_sep=0;

/***Step 2: initialisation de l'état des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupée*/

int search(char entity[], int t){
	int i=0;
	switch (t){
		case 0: //tables des idf et const
			while (i<count_idf_cst) {
				if (strcmp(entity,ts_idf_cst[i].name)==0) return i;
				i++;
			}
			return -1;
		
		case 1: //tables des separt
			while (i<count_sep) {
				if (strcmp(entity,ts_sep[i].name)==0) return i;
				i++;
			}
			return -1;
		case 2: // table des key word (mots cles)
			while (i<count_kw) {
				if (strcmp(entity,ts_kw[i].name)==0) return i;
				i++;
			}
			return -1;
	
	}
}


int insert(char entity[], char code[], char type[], float value, int t){
	switch (t){
		case 0:  
		// table des idf et const 0
			if (search(entity,0)==-1) {
				strcpy(ts_idf_cst[count_idf_cst].name,entity);
				strcpy(ts_idf_cst[count_idf_cst].code,code);
				strcpy(ts_idf_cst[count_idf_cst].type,type);
				ts_idf_cst[count_idf_cst].value= value;
				count_idf_cst++;
			}
			break;
		// table des separateures  1
		case 1:
			if (search(entity,1)==-1) {
				strcpy(ts_sep[count_sep].name,entity);
				strcpy(ts_sep[count_sep].code,code);
				count_sep++;
			}
			break;
		// table des mot cles	
		case 2:
			if (search(entity,2)==-1) {
				strcpy(ts_kw[count_kw].name,entity);
				strcpy(ts_kw[count_kw].code,code);
				count_kw++;
			}
			break;
	}
}

void print(){
	printf("\n/******************Table des symboles IDF*******************");
	printf("\n-------------------------------------------------------------\n");
	printf("\t|    Name   |      Code    |   Type    |    Value   | \n");
	printf("-------------------------------------------------------------\n");
	int i=0;
	while(i<count_idf_cst){
		printf("\t|%10s | %15s |%12s | %12f |\n", ts_idf_cst[i].name,ts_idf_cst[i].code,ts_idf_cst[i].type, 				
		ts_idf_cst[i].value);
		i++;
	}
	printf("\n/**Table des symboles Separateurs**");
	printf("\n------------------------------\n");
	printf("\t|    Name   |      Code    |\n");
	printf("------------------------------\n");
	i=0;
	while(i<count_sep){
		printf("\t|%10s | %12s |\n", ts_sep[i].name,ts_sep[i].code);
		i++;
	}
	printf("\n/**Table des symboles mots cles**");
	printf("\n------------------------------\n");
	printf("\t|    Name   |      Code    |\n");
	printf("------------------------------\n");
	i=0;
	while(i<count_kw){
		printf("\t|%10s | %12s |\n", ts_kw[i].name,ts_kw[i].code);
		i++;
	}
}

int insert_type(char entity[], char type[]){
	int pos=search(entity,0);//la recherche se fait dans la TS des IDF
	if (pos!=-1)
	{
		strcpy(ts_idf_cst[pos].type,type);
	}
}

int check_declaration(char entity[]){
	int pos=search(entity,0);
	if (pos!=-1 && strcmp(ts_idf_cst[pos].type,"")==0) 
		return 0;
	return -1;
}
