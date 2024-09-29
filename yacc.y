//y3
%{
  #include <stdio.h>
  #include <string.h>
  #include "SymbolTable.h"

  SymbolTable table;
  extern FILE *yyin, *yyout;
  FILE *fp;
  extern int line;
  int yylex();
  void yyerror(const char *s) {
    fprintf(yyout, "Error: %s\n", s);
  }
%}

%union {
  int int_val;
  float float_val;
  char *string_val;
  double double_val;
}

%token <string_val> ID
%token CONST_INT CONST_FLOAT CONST_DOUBLE INT FLOAT DOUBLE
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD SEMICOLON COMMA
%right ASSIGN
%left ADDOP LOGICOP 
%left MULOP


%%

mul_stmt : mul_stmt func_decl   { fprintf(yyout, "Line Number: %d \n mul_stmt: mul_stmt func_decl\n", line); }
         | func_decl 
         /* { fprintf(yyout, "Line Number: %d \n mul_stmt: func_decl\n", line); } */
         | error { yyerrok;yyclearin; }
         ;

func_decl : type_spec term LPAREN RPAREN LCURL stmt RCURL {
    fprintf(yyout, "Line Number: %d \n func_decl: type_spec term LPAREN RPAREN LCURL stmt RCURL\n", line);
};

stmt : stmt unit {
    fprintf(yyout, "Line Number: %d \n stmt: stmt unit \n", line);
} | unit {
    fprintf(yyout, "Line Number: %d \n stmt: unit\n", line);
};

unit: var_decl   {fprintf(yyout, "Line Number: %d \n unit: var_decl\n", line);}
    | expr_decl     {fprintf(yyout, "Line Number: %d \n unit: expr_decl\n", line);}
    ;

var_decl: type_spec decl_list SEMICOLON {
    fprintf(yyout, "Line Number: %d \n var_decl: type_spec decl_list SEMICOLON\n", line);
} 
| error { yyerrok;yyclearin; };

type_spec: INT { fprintf(yyout, "Line Number: %d \n type_spec: INT\n", line);}
         | FLOAT { fprintf(yyout, "Line Number: %d \n type_spec: FLOAT\n", line); }
         | DOUBLE { fprintf(yyout, "Line Number: %d \n type_spec: DOUBLE\n", line); }
         ;

decl_list: decl_list COMMA term {
    fprintf(yyout, "Line Number: %d \n decl_list: decl_list COMMA term \n", line);
} | decl_list COMMA term LTHIRD CONST_INT RTHIRD {
    fprintf(yyout, "Line Number: %d \n decl_list: decl_list COMMA term LTHIRD CONST_INT RTHIRD\n", line);
} | term {
    fprintf(yyout, "Line Number: %d \n decl_list: term\n", line);
} | term LTHIRD CONST_INT RTHIRD {
    fprintf(yyout, "Line Number: %d \n decl_list: term LTHIRD CONST_INT RTHIRD\n", line);
} | ass_list {
    fprintf(yyout, "Line Number: %d \n decl_list: ass_list\n", line);
};

ass_list: term ASSIGN expr {
    fprintf(yyout, "Line Number: %d \n ass_list: term ASSIGN expr \n", line);
};

expr: CONST_INT {
    fprintf(yyout, "Line Number: %d \n expr: CONST_INT\n", line);
} | CONST_FLOAT {
    fprintf(yyout, "Line Number: %d \n expr: CONST_FLOAT\n", line);
} | expr ADDOP expr {
    fprintf(yyout, "Line Number: %d \n expr: expr ADDOP expr\n", line);
} | expr LOGICOP expr {
    fprintf(yyout, "Line Number: %d \n expr: expr LOGICOP expr\n", line);
} | expr MULOP expr {
    fprintf(yyout, "Line Number: %d \n expr: expr MULOP expr\n", line);
} | LPAREN expr RPAREN {
    fprintf(yyout, "Line Number: %d \n expr: LPAREN expr RPAREN\n", line);
} | term {
    fprintf(yyout, "Line Number: %d \n expr: term\n", line);
};

term: ID {
    if (table.search($1)) {
        fprintf(yyout, "%s is already declared\n", $1);
    } else {
        fprintf(yyout, "Line Number: %d \n term: ID %s\n", line, $1);
        table.insert($1,"ID");
    }
};

expr_decl: term ASSIGN expr SEMICOLON {
    fprintf(yyout, "Line Number: %d \n expr_decl: term ASSIGN expr SEMICOLON\n", line);
};

%%

int main() {
  yyin = fopen("input.txt", "r");
  yyout = fopen("output.txt", "w");
  fp =fopen("log.txt","w");
  yyparse();
  fclose(yyin);
  fclose(yyout);
  table.print();
  return 0;
}
