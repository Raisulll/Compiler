//lex3
%option noyywrap
%{
#include<stdio.h>
#include<string.h>
#include "yacc.tab.h"
int line=1;
%}

integer [0-9]+
decimal [0-9]+\.[0-9]+([eE][+-]?[0-9]+)?
identifier [A-Za-z_][A-Za-z0-9_]*

%%
\n { line++; }

[ \t]+ { }

int {
  return INT;
}

float {
  return FLOAT;
}

double {
  return DOUBLE;
}

{integer} {
  return CONST_INT;
}

{decimal} {
  return CONST_FLOAT;
}

{identifier} {
  yylval.string_val = yytext;
  return ID;
  }

[+-] {
  return ADDOP;
}

[*/%] {
  return MULOP;
}

"&&"|"||" {
  return LOGICOP;
}

\( {
  return LPAREN;
}

\) {
  return RPAREN;
}

\{ {
  return LCURL;
}

\} {
  return RCURL;
}

\[ {
  return LTHIRD;
}

\] {
  return RTHIRD;
}

, {
  return COMMA;
}

= {
  return ASSIGN;
}

; {
  return SEMICOLON;
}

. { }
%%
