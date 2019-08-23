/*

- Para gerar o fonte digite
$ lex ex01.l

- Para compilar o fonte me C gerado digite
$ gcc ex01.yy.c

- Para executar
$ ./a.out

*/   


/* SEÇÃO DE DEFINIÇÕES */

%{
    /*
        Definições que estarão disponíveis 
            - variáveis
            - constantes
        O que for aqui será copiado para o arquivo *.yy.c
    
        Variáveis declaradas aqui estarão acessível nas funções yylex() e 
        main().
    */
    #include "parser.tab.h"
%}

/* Definições de Nomes */

IDENTIFICADOR	        "inteiro"|"real"|"ABC"
PALAVRA_RESERVADA       "inicio"|"tela"|"leia"|"fim"
NUMERO				    ([0-9]+)*
PONTO_FLUTUANTE			([0-9]+)*[.]([0-9]+)
VARIAVEL		        [_a-zA-Z][_a-zA-Z0-9]*
OPERADOR_UNARIO			("++"|"--")([a-zA-Z]*)|([a-zA-Z]*)("++"|"--")
OPERADOR_LOGICO			")"|"("|"=)"|"(="|"="|"#"|"&&"|"||"
OPERADOR_ATRIBUICAO		"~"|":"
CONDICIONAL				"se"|"entao"|"fim_se"|"senao"
LOOP					"enquanto"|"para"|"ate"|"faca"|"passo"|"fim_para"
ESPACAMENTO				[" "]+
STRING				    \"(\\.|[^"\\])*\"
CARACTER 				(\')(.)(\')
VETOR 					([a-zA-Z][_a-zA-Z0-9]*)(\<)([0-9]+)|([a-zA-Z]+)(\>)
TAMANHO_VETOR		    (\<)([0-9]+)(\>)
EXCLAMACAO              "!"

/* FIM DA SEÇÃO DE DEFINIÇÕES */

%%
    /* SEÇAO DE REGRAS 
        Uma entrada por linha no formato:
        
        padrão  ação

    */

{IDENTIFICADOR}			{return IDENTIFICADOR;}         
{PALAVRA_RESERVADA}		{return PALAVRA_RESERVADA;}
{NUMERO}                {strncpy(yylval.simbolo, yytext, 50); return NUMERO;}
{PONTO_FLUTUANTE}       {strncpy(yylval.simbolo, yytext, 50); return PONTO_FLUTUANTE;}
{VARIAVEL}				{strncpy(yylval.simbolo, yytext, 50); return VARIAVEL;}
{OPERADOR_UNARIO}       {return OPERADOR_UNARIO;}
{OPERADOR_LOGICO}		{return OPERADOR_LOGICO;}
{OPERADOR_ATRIBUICAO}	{return OPERADOR_ATRIBUICAO;}
{CONDICIONAL} 	        {return CONDICIONAL;}
{LOOP}				    {strncpy(yylval.simbolo, yytext, 50); return LOOP;}
{STRING}				{strncpy(yylval.simbolo, yytext, 50); return STRING;}
{CARACTER}				{strncpy(yylval.simbolo, yytext, 50); return CARACTER;}
{VETOR}                 {return VETOR;}
{TAMANHO_VETOR}         {return TAMANHO_VETOR;}
{EXCLAMACAO}            {return EXCLAMACAO;}
"\n"                    {return EOL;}
<<EOF>>					return 0;

%%

/*
Seção de Código do Usuário
*/

int yywrap() {}