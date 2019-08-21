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
    int contador = 0;
%}

/* Definições de Nomes */
MACRO					[#]([a-zA-Z]+)
BIBLIOTECA 		        [<]([a-zA-Z]+)[.][h][>]
IDENTIFICADOR	        "inteiro"|"real"|"ABC"
RESERVED_WORDS          "inicio"|"tela"|"leia"|"fim"
NUMBER				    ([0-9]+)*
VARIAVEL		        [_a-zA-Z][_a-zA-Z0-9]*
OPERADOR_MATEMATICO     "+"|"\/"|"-"|"**"
OPERADOR_UNARIO			"++"|"--"
OPERADOR_LOGICO			")"|"("|"=)"|"(="|"="|"#"|"&&"|"||"
OPERADOR_ATRIBUICAO		"~"|":"
CONDICIONAL				"se"|"entao"|"fim_se"|"switch"
LOOP					"enquanto"|"para"|"ate"|"faca"|"passo"|"fim_para"
ABERTURA_FUNCAO			"\("|"\{"
FECHAMENTO_FUNCAO		"\)"|"\}"
ESPACAMENTO				[" "]+
STRING				    \"(\\.|[^"\\])*\"
EXCLAMACAO              "!"

/* FIM DA SEÇÃO DE DEFINIÇÕES */

%%
    /* SEÇAO DE REGRAS 
        Uma entrada por linha no formato:
        
        padrão  ação

    */
{MACRO}																					{printf("<macro, '%s'> ", yytext); contador++;}
{BIBLIOTECA}																			{printf("<biblioteca, '%s'> ", yytext); contador++;}
{IDENTIFICADOR}{ESPACAMENTO}{VARIAVEL}+"()"								                {printf("<função, '%s'> ", yytext); contador++;}
{IDENTIFICADOR}										  									{printf("<identificador_tipo, '%s'> ", yytext); contador++;}
{RESERVED_WORDS}																		{printf("<palavra_reservada, '%s'>", yytext); contador;}
{CONDICIONAL} 																			{printf("<condicional, '%s'> ", yytext); contador++;}
{VARIAVEL}{OPERADOR_UNARIO}|{OPERADOR_UNARIO}{VARIAVEL}		                            {printf("<operação unária, '%s'> ", yytext); contador++;}
{LOOP}																					{printf("<loop, '%s'> ", yytext); contador++;}
{VARIAVEL}																				{printf("<variavel, '%s'> ", yytext); contador++;}
"&"+{VARIAVEL}																			{printf("<leitura de variavel, '%s'> ", yytext); contador++;}
{VARIAVEL}+"<"+{NUMBER}+">"|{VARIAVEL}+"<"+{VARIAVEL}+">"	                            {printf("<vetor, '%s'> ", yytext); contador++;}
"&"+{VARIAVEL}+"<"+{NUMBER}+">"|"&"+{VARIAVEL}+"<"+{VARIAVEL}+">"|"&"+{VARIAVEL}		{printf("<leitura de vetor, '%s'> ", yytext); contador++;}
{OPERADOR_LOGICO}										                                {printf("<operador_logico, '%s'> ", yytext); contador++;}
{OPERADOR_ATRIBUICAO}								                                    {printf("<operador_atribuição,  '%s'> ", yytext); contador++;}
"-"?|"+"?{NUMBER}														                {printf("<numero, '%s'> ", yytext); contador++;}
"<"+{NUMBER}+">"										                                {printf("<tamanho do vetor, '%s'> ", yytext); contador++;}
{NUMBER}+"."+{NUMBER}								                                    {printf("<ponto_flutuante, '%s'> ", yytext); contador++;}
'+{VARIAVEL}+'											                                {printf("<caracter, '%s'> ", yytext); contador++;}
{ABERTURA_FUNCAO}										                                {printf("<abertura de funcao, '%s'> ", yytext); contador++;}
{FECHAMENTO_FUNCAO}									                                    {printf("<fechamento de funcao, '%s'> ", yytext); contador++;}
{STRING}                                                                                {printf("<string, '%s'> ", yytext); contador++;}
{EXCLAMACAO}                                                                            {printf("<fim de linha, '%s'> ", yytext); contador++;}
<<EOF>>															                        return 0;

%%

/*
Seção de Código do Usuário
*/

int yywrap() {}
int main() {
    printf("Iniciando Análise Léxica...\n---\n");
    yylex();
    printf("\nForam encontradas %d ocorrências de tokens.\n", contador);
    printf("---\nÁnalise Finalizada!\n");
    
    return 0;
}


