//y4
%{
    #include<stdio.h>
    #include<bits/stdc++.h>
    using namespace std;
    #include<stdlib.h>
    #include "symbol.h"
    #define YYSTYPE SymbolInfo

    FILE *fp;

    int yylex();
    SymbolTable T;
    extern FILE *yyin, *yyout;
    extern int line;
    int temp_counter=1;
    void yyerror(const char* str){
            printf("Error: %s\n", str);
        }
        char* newTemp(){
        char* temp;
        temp = (char*) malloc(15*sizeof(char));
        sprintf(temp, "t%d", temp_counter);
        temp_counter++;
        return temp;
    }
    %}


    %start prog
    %token  INT  FLOAT  DOUBLE
    %token  ID
    %token  CONST_INT  CONST_FLOAT MAIN
    %token  LCURL RCURL  LTHIRD  RTHIRD  SEMICOLON  COMMA 
    %left '+' '-' 
    %left MULOP LOGICOP
    %right ASSIGNOP 
    %nonassoc LPAREN RPAREN



    %%

    prog : MAIN LPAREN RPAREN LCURL stmt RCURL
        | error {yyerrok;yyclearin;}
        ;

    
    stmt: stmt unit {
    } 
    | unit {
    }
    ;
  

    unit: var_decl   
        | expr_decl   
    ;

    var_decl: type_spec decl_list SEMICOLON {
    };



    type_spec: INT {
    }
    ;

    decl_list: term

    expr: CONST_INT {   // a=b+c;
        char* str = newTemp();      
        SymbolInfo obj(str, "TempID");
        $$ = obj;
        // $1.printInfo();
        cout << $$.getName().c_str() << " = " << $1.getName().c_str() << endl;

        fprintf(yyout, "MOV AX, %s\n", $1.getName().c_str());         
        fprintf(yyout, "MOV %s, AX\n", $$.getName().c_str()); 
    
    } | CONST_FLOAT {
        printf( "Line Number: %d \n expr: CONST_FLOAT  \n", line);
    } | expr '-' expr {
        char* str = newTemp();
	    SymbolInfo obj(str, "TempID");
	    $$ = obj;
	    cout<<$$.getName()<<" = " << $1.getName() << "-" << $3.getName()<<endl;
	
	    fprintf(yyout, "MOV AX, %s\n", $1.getName().c_str());
	    fprintf(yyout, "MOV BX, %s\n", $3.getName().c_str());
	    fprintf(yyout, "SUB AX, BX\n");
	    fprintf(yyout, "MOV %s, AX\n\n", $$.getName().c_str());

    } | expr '+' expr {
        char* str = newTemp();
	    SymbolInfo obj(str, "TempID");  // b + c;    t1
	    $$ = obj;
	    cout<<$$.getName()<<" = " << $1.getName() << "+" << $3.getName()<<endl;

	    fprintf(yyout, "MOV AX, %s\n", $1.getName().c_str());
	    fprintf(yyout, "MOV BX, %s\n", $3.getName().c_str());
	    fprintf(yyout, "ADD AX, BX\n");
	    fprintf(yyout, "MOV %s, AX\n\n", $$.getName().c_str());

    } | expr MULOP expr {
        char* str = newTemp();
        SymbolInfo obj(str, "TempID");
        $$ = obj;
        cout << $$.getName() << " = " << $1.getName() << " * " << $3.getName() << endl;

        fprintf(yyout, "MOV AX, %s\n", $1.getName().c_str());
        fprintf(yyout, "MOV BX, %s\n", $3.getName().c_str());
        fprintf(yyout, "MUL BX\n");  
        fprintf(yyout, "MOV %s, AX\n\n", $$.getName().c_str());
        
    } | LPAREN expr RPAREN {
        
        $$ = $2;
        fprintf(yyout,"MOV AX, %s\n",$2.getName().c_str());

    } | term {
        $$=$1;
        fprintf(yyout,"MOV AX, %s\n",$1.getName().c_str()); 
    };

    term: ID {
        SymbolInfo n;
        n=yylval;
        if(!T.lookupSymbolInfo(n.getName())){
            T.insertSymbol(n);
        }
    };

    expr_decl: term ASSIGNOP expr SEMICOLON {
        fprintf(yyout, "MOV %s, %s\n\n", $1.getName().c_str(), $3.getName().c_str());
        cout<<$1.getName()<<" = "<<$3.getName()<<endl;
	    temp_counter=1;
    };

    %%

    int main() {
    yyin = fopen("input.txt", "r");
    yyout = fopen("code.asm", "w");
    freopen("code.ir", "w", stdout);
    fp=fopen("table.txt","w");
    yyparse();
    fclose(yyin);
    fclose(yyout);
    T.printTable();
    return 0;
}
