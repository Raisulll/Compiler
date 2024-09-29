%option noyywrap
%{
#include<stdio.h>
#include "SymbolTable.h"
SymbolTable table;
int c=1;
int err_cnt=0;
%}

integer [0-9]+
decimal [0-9]+\.[0-9]+([eE][+-]?[0-9]+)?
identifier [A-Za-z_][A-Za-z0-9_]*
lt <
le <=
gt >
ge >=
eq ==
ne !=
singleline (\/\/([^\r\n\\]|\\[\r\n])*) 
multiline (\/\/.*)|(\/\*([^*]|\*+[^/])*?\*\/)

%%
\n {
  c++;
  fprintf(yyout,"\n");
}

[ \t]+ {
  ;
}

if {
  fprintf(yyout,"<IF>");
  fprintf(fp,"Line %d: Token IF lexeme if found\n",c);
}

else {
  fprintf(yyout,"<ELSE>");
  fprintf(fp,"Line %d: Token ELSE lexeme else found\n",c);
}

for {
  fprintf(yyout,"<FOR>");
  fprintf(fp,"Line %d: Token FOR lexeme for found\n",c);
}

while {
  fprintf(yyout,"<WHILE>");
  fprintf(fp,"Line %d: Token WHILE lexeme while found\n",c);
}

do {
  fprintf(yyout,"<DO>");
  fprintf(fp,"Line %d: Token DO lexeme dO found\n",c);
}

int {
  fprintf(yyout,"<INT>");
  fprintf(fp,"Line %d: Token INT lexeme int found\n",c);
}

float {
  fprintf(yyout,"<FLOAT>");
  fprintf(fp,"Line %d: Token FLOAT lexeme float found\n",c);
}

void {
  fprintf(yyout,"<VOID>");
  fprintf(fp,"Line %d: Token VOID lexeme void found\n",c);
}

switch {
  fprintf(yyout,"<SWITCH>");
  fprintf(fp,"Line %d: Token SWITCH lexeme switch found\n",c);
}

default {
  fprintf(yyout,"<DEFAULT>");
  fprintf(fp,"Line %d: Token DEFAULT lexeme default found\n",c);
}

break {
  fprintf(yyout,"<BREAK>");
  fprintf(fp,"Line %d: Token BREAK lexeme break found\n",c);
}

char {
  fprintf(yyout,"<CHAR>");
  fprintf(fp,"Line %d: Token CHAR lexeme char found\n",c);
}

double {
  fprintf(yyout,"<DOUBLE>");
  fprintf(fp,"Line %d: Token DOUBLE lexeme double found\n",c);
}

return {
  fprintf(yyout,"<RETURN>");
  fprintf(fp,"Line %d: Token RETURN lexeme return found\n",c);
}

case {
  fprintf(yyout,"<CASE>");
  fprintf(fp,"Line %d: Token CASE lexeme case found\n",c);
}

continue {
  fprintf(yyout,"<CONTINUE>");
  fprintf(fp,"Line %d: Token CONTINUE lexeme continue found\n",c);
}

{integer}{identifier} {
  fprintf(fp,"Error at line %d: Invalid prefix on ID or invalid suffix on Number %s \n",c,yytext);
  err_cnt++;
}

[0-9]+\.?[0-9]*?[eE][+-]?[0-9]+.[0-9]+ {
  fprintf(fp,"Error at line %d: Ill formed name %s \n",c,yytext);
  err_cnt++;
}

'' {
  fprintf(fp,"Error at line %d: Empty character constant %s \n",c,yytext);
  err_cnt++;
}

{integer} {
  fprintf(yyout,"<CONST_INT, %s> ", yytext); 
  table.insert("CONST_INT", yytext);
  fprintf(fp,"Line %d: Token CONST_INT lexeme %s found\n",c,yytext);
}

{decimal} {
  fprintf(yyout,"<CONST_FLOAT, %s> ", yytext); 
  table.insert("CONST_FLOAT", yytext);
  fprintf(fp,"Line %d: Token CONST_FLOAT lexeme %s found\n",c,yytext);
}

{identifier} {
  fprintf(yyout,"<ID, %s> ", yytext); 
  table.insert("ID", yytext);
  fprintf(fp,"Line %d: Token ID lexeme %s found\n",c,yytext);
  }

(--)|(\+\+) {
  fprintf(yyout,"<INCOP, %s> ", yytext); 
  fprintf(fp,"Line %d: Token INCOP lexeme %s found\n",c,yytext);
}

[+-] {
  fprintf(yyout,"<ADDOP, %s> ", yytext); 
  fprintf(fp,"Line %d: Token ADDOP lexeme %s found\n",c,yytext);
}

[*/%] {
  fprintf(yyout,"<MULOP, %s> ", yytext); 
  fprintf(fp,"Line %d: Token MULOP lexeme %s found\n",c,yytext);
}

({le}|{lt}|({ge})|{gt}|({eq})|({ne})) {
  fprintf(yyout,"<RELOP, %s> ", yytext); 
  fprintf(fp,"Line %d: Token RELOP lexeme %s found\n",c,yytext);
}

(&&)|(\|\|) {
  fprintf(yyout,"<LOGICOP, %s> ", yytext); 
  fprintf(fp,"Line %d: Token LOGICOP lexeme %s found\n",c,yytext);
}

! {
  fprintf(yyout,"<NOT, %s> ", yytext); 
  fprintf(fp,"Line %d: Token NOT lexeme %s found\n",c,yytext);
}

\( {
  fprintf(yyout,"<LPAREN, %s> ", yytext); 
  fprintf(fp,"Line %d: Token LPAREN lexeme %s found\n",c,yytext);
}

\) {
  fprintf(yyout,"<RPAREN, %s> ", yytext); 
  fprintf(fp,"Line %d: Token RPAREN lexeme %s found\n",c,yytext);
}

\{ {
  fprintf(yyout,"<LCURL, %s> ", yytext); 
  fprintf(fp,"Line %d: Token LCURL lexeme %s found\n",c,yytext);
}

\} {
  fprintf(yyout,"<RCURL, %s> ", yytext); 
  fprintf(fp,"Line %d: Token RCURL lexeme %s found\n",c,yytext);
}

\[ {
  fprintf(yyout,"<RTHIRD, %s> ", yytext); 
  fprintf(fp,"Line %d: Token RTHIRD lexeme %s found\n",c,yytext);
}

\] {
  fprintf(yyout,"<LTHIRD, %s> ", yytext); 
  fprintf(fp,"Line %d: Token LTHIRD lexeme %s found\n",c,yytext);
}

{singleline}|{multiline} {
  fprintf(fp,"Line %d: Token COMMENT lexeme %s found\n",c,yytext);
  for(int i=0; i<strlen(yytext); i++){
    if(yytext[i] == '\n') c++;
  }
}

, {
  fprintf(yyout,"<COMMA, %s> ", yytext); 
  fprintf(fp,"Line %d: Token COMMA lexeme %s found\n",c,yytext);
}

= {
  fprintf(yyout,"<ASSINOP, %s> ", yytext);
  table.insert("ID", yytext);
  fprintf(fp,"Line %d: Token ASSIGNOP lexeme %s found\n",c,yytext);
}

; {
  fprintf(yyout,"<SEMICOLON, %s> ", yytext);
  fprintf(fp,"Line %d: Token SEMICOLON lexeme %s found\n",c,yytext);
}

. {
  fprintf(fp,"Error at line %d: Unrecognized character %s \n",c,yytext);
  err_cnt++;
}


%%
int main(){
  yyin=fopen("input.txt","r");
  yyout=fopen("202214052_token.txt","w");
  yylex();
  fclose(yyin);
  fclose(yyout);
  fclose(fp);
}