//lex4
%option noyywrap
%{
    #include <stdio.h>
    #include<bits/stdc++.h>
    #include "symbol.h"
    #define YYSTYPE SymbolInfo
    #include "yacc.tab.h"
    void yyerror(const char *s);
    int line = 1;
%}

digit [0-9]
int {digit}+(E[-+]?{digit}+)?
errorint1 ({digit}*\.{digit}+\.{digit}+)
errorint2 ({digit}+E{digit}+\.{digit}+)
float {digit}*\.{digit}+(E[-]?{digit}+)?
delimiters [ \t\n]
characters [a-zA-Z]
id [a-zA-Z_][a-zA-Z0-9_]*
char '[^{delimiters}]'
unfinished_character '[^'\n ;]*
multiple_character '[^{delimiters}][^']+'
string \"([^"\n]|\\\n)*\"
unfinished_string \"([^"\n])*\n

%%
[\n] {
    line++;
}
int {
   return INT;
}

char {}

float {
   return FLOAT;
}
double {
   return DOUBLE;
}

main {
    return MAIN;
}

"+"|"-" {
   return *yytext;
}

"*"|"%"|"/" {
    return MULOP;
}

"++"|"--" {}

"=="|"!="|"<"|">"|"<="|">=" {}

"&&"|"||" {
    return LOGICOP;
}
"!" {}

"=" {
    return ASSIGNOP;
}
"(" {
    return LPAREN;
}
")" { 
   
    return RPAREN; 
}
"{" {
 
    return LCURL;
}
"}" {
  
    return RCURL;
}
"[" {
   
    return LTHIRD;
}
"]" {
    
    return RTHIRD;
}
";" {
 
    return SEMICOLON;
}
"," {
   
    return COMMA;
}
{errorint1} {}

{errorint2} {}

{int} {
    SymbolInfo obj(yytext, "CONST_INT");
    yylval = obj;
    return CONST_INT;
}
{float} {   
    SymbolInfo obj(yytext, "CONST_FLOAT");
    yylval = obj;
    return CONST_FLOAT;
}

{id} {
    SymbolInfo obj(yytext, "ID");
    yylval = obj;
    return ID;
}

[ \t]+ {}
. {
    yyerror("error\n");
}
%%
