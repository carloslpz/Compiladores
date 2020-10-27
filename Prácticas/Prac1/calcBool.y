/*
nombre completo:	Carlos Isaí López Reséndiz
Practica numero:	1
tema:							YACC Básico
opcion:						2: Calculadora para expresiones booleanas
fecha:						26 de octubre de 2020
grupo:						3cm7
materia: 					Compiladores
*/



%{
#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#define YYSTYPE bool //Elemento en la pila: Booleano

void yyerror (char *s);
int yylex ();
void warning(char *s, char *t);
%}
/*Tokens: Booleano y operadores*/
%token BOOL
%left 'v'
%left '^'
%left '-'
%%
list:
				| list'\n'
        | list exp '\n'  { printf("%s\n", $2 ? "true" : "false"); } /*Imprimir el resultado como cadena*/
	;
exp:      BOOL          	{ $$ = $1;  }
        | exp '^' exp     { $$ = $1 && $3;  }
        | exp 'v' exp    { $$ = $1 || $3;  }
        | '-' exp     { $$ = !$2;  }
        | '(' exp ')'     { $$ = $2;  }
	;
%%

#include <stdio.h>
#include <ctype.h>
char *progname;
int lineno = 1;

void main (int argc, char *argv[]){
	progname=argv[0];
  	yyparse ();
}
int yylex (){
  	int c;

  	while ((c = getchar ()) == ' ' || c == '\t')
  		;
 		if (c == EOF)
    		return 0;
  	if (c == 't') {		//Si encontramos t
			yylval = true;
  		return BOOL;
  	}
		if(c == 'f'){			//Si encontramos f
			yylval = false;
			return BOOL;
		}
  	if(c == '\n')
		lineno++;
  	return c;
}
void yyerror (char *s) {
	warning(s, (char *) 0);
}
void warning(char *s, char *t){
	fprintf (stderr, "%s: %s", progname, s);
	if(t)
		fprintf (stderr, " %s", t);
	fprintf (stderr, "cerca de la linea %d\n", lineno);
}
