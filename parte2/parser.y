%{

#include <stdio.h>
#include <stdlib.h>

typedef struct No {
    char token[50];
    int num_filhos;
    struct No** filhos;
} No;


No* allocar_no();
void liberar_no(No* no);
void imprimir_arvore(No* raiz);
No* novo_no(char[50], No**, int);

%}

/* Declaração de Tokens no formato %token NOME_DO_TOKEN */

%union 
{
    int NUMERO;
    char simbolo[50];
    struct No* no;
}

%token IDENTIFICADOR
%token PALAVRA_RESERVADA
%token NUMERO
%token PONTO_FLUTUANTE
%token VARIAVEL
%token OPERADOR_UNARIO
%token OPERADOR_LOGICO
%token OPERADOR_ATRIBUICAO
%token OPERADOR_SOMA
%token OPERADOR_MUL
%token OPERADOR_SUB
%token OPERADOR_DIV
%token CONDICIONAL
%token LOOP
%token STRING
%token CARACTER
%token VETOR
%token TAMANHO_VETOR
%token EXCLAMACAO
%token EOL

%type<no> calc
%type<no> fator
%type<no> exp
%type<no> termo
%type<no> stmt
%type<no> operador
%type<no> loop

%type<simbolo> LOOP
%type<simbolo> OPERADOR_LOGICO
%type<simbolo> OPERADOR_ATRIBUICAO
%type<simbolo> OPERADOR_SOMA
%type<simbolo> OPERADOR_MUL
%type<simbolo> OPERADOR_DIV
%type<simbolo> CONDICIONAL
%type<simbolo> OPERADOR_SUB
%type<simbolo> IDENTIFICADOR
%type<simbolo> VARIAVEL
%type<simbolo> NUMERO
%type<simbolo> PONTO_FLUTUANTE
%type<simbolo> STRING
%type<simbolo> CARACTER
%type<simbolo> VETOR
%type<simbolo> TAMANHO_VETOR
%type<simbolo> EXCLAMACAO

%%
/* Regras de Sintaxe */

calc:
    | calc stmt EOL       { imprimir_arvore($2); }
    ;   

stmt: exp
    | loop exp loop loop fator stmt loop{
                            No** filhos = (No**) malloc(sizeof(No*) * 7);
                            filhos[0] = $1;
                            filhos[1] = $2;
                            filhos[2] = $3;
                            filhos[3] = $4;
                            filhos[4] = $5;
                            filhos[5] = $6;
                            filhos[6] = $7;
                            
                            $$ = novo_no("stmt", filhos, 7);
    }

    | loop exp loop stmt loop{
                            No** filhos = (No**) malloc(sizeof(No*) * 5);
                            filhos[0] = $1;
                            filhos[1] = $2;
                            filhos[2] = $3;
                            filhos[3] = $4;
                            filhos[4] = $5;

                            $$ = novo_no("stmt", filhos, 5);
    }

    | CONDICIONAL exp CONDICIONAL stmt CONDICIONAL{                               
                            No** filhos = (No**) malloc(sizeof(No*) * 5);
                            filhos[0] = novo_no("se", NULL, 0);
                            filhos[1] = $2;
                            filhos[2] = $3;
                            filhos[3] = $4;
                            filhos[4] = $5;

                            $$ = novo_no("stmt", filhos, 5);
    }
;

exp: fator
    | exp OPERADOR_SOMA fator {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("+", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
                            }
    | exp OPERADOR_SUB fator {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("-", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);                            
    }

    | exp OPERADOR_ATRIBUICAO fator {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("~", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
    }
    | exp operador fator {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = $2;
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
    }
;

fator: termo 
    | fator OPERADOR_MUL termo {
                                No** filhos = (No**) malloc(sizeof(No*)*3);
                                filhos[0] = $1;
                                filhos[1] = novo_no("*", NULL, 0);
                                filhos[2] = $3;

                                $$ = novo_no("termo", filhos, 3);
    }
    | fator OPERADOR_DIV termo {
                                No** filhos = (No**) malloc(sizeof(No*)*3);
                                filhos[0] = $1;
                                filhos[1] = novo_no("/", NULL, 0);
                                filhos[2] = $3;

                                $$ = novo_no("termo", filhos, 3);
                                }
    
;

loop: LOOP { $$ = novo_no($1, NULL, 0); }
    ;
operador: OPERADOR_LOGICO { $$ = novo_no($1, NULL, 0); }
    ;
termo: NUMERO { $$ = novo_no($1, NULL, 0);}
    | PONTO_FLUTUANTE { $$ = novo_no($1, NULL, 0); }
    | VARIAVEL { $$ = novo_no($1, NULL, 0); }
    ;

%%

/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */

No* allocar_no(int num_filhos) {
    return (No*) malloc(sizeof(No)* num_filhos);
}

void liberar_no(No* no) {
    free(no);
}

No* novo_no(char token[50], No** filhos, int num_filhos) {
    No* no = allocar_no(1);    
    snprintf(no->token, 50, "%s", token);
    no->num_filhos= num_filhos;
    no->filhos = filhos;

    return no;
}

void imprimir_arvore(No* raiz) {
    
    if(raiz == NULL) { printf("***"); return; }
    printf("(%s)", raiz->token);
    int i = 0;
    if (raiz->filhos != NULL)
    {
        printf(" -> ");
        imprimir_arvore(raiz->filhos[0]);
        imprimir_arvore(raiz->filhos[1]);
        imprimir_arvore(raiz->filhos[2]);
        imprimir_arvore(raiz->filhos[3]);
        imprimir_arvore(raiz->filhos[4]);
        imprimir_arvore(raiz->filhos[5]);
        imprimir_arvore(raiz->filhos[6]);
        imprimir_arvore(raiz->filhos[7]);
        
        printf("$\n");
    } else {
        printf(" ");
    }
    // printf("\n");
}

int main(int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}

