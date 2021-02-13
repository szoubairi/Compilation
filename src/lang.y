%code requires{

#include "Table_des_symboles.h"
#include "Attribute.h"
  
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



FILE * testc, *testh;
  
extern int yylex();
extern int yyparse();
extern char * yytext;

void yyerror (char* s) {
  printf ("%s\n",s);
  }
		
%}


%union { 
  struct ATTRIBUTE * val;
  char* str;
  type typ;
  int num;
}

%token <val> NUMI NUMF
%token TINT  
%token <val> ID
%token AO AF PO PF PV VIR
%token RETURN VOID EQ
%token <val> IF ELSE WHILE

%token <val> AND OR NOT DIFF EQUAL SUP INF
%token PLUS MOINS STAR DIV
%token DOT ARR

%type <val> typename
%type <num> pointer else bool_cond while while_cond
%type <val> type exp app aff
%type <str> vlist

%left DIFF EQUAL SUP INF       // low priority on comparison
%left PLUS MOINS               // higher priority on + - 
%left STAR DIV                 // higher priority on * /
%left OR                       // higher priority on ||
%left AND                      // higher priority on &&
%left DOT ARR                  // higher priority on . and -> 
%nonassoc UNA                  // highest priority on unary operator
%nonassoc ELSE

%start prog
 


%%

prog : func_list               {}
;

func_list : func_list fun      {}
| fun                          {}
;


// I. Functions

fun : type fun_head fun_body        {}
;

fun_head : ID PO PF            {$1->type_return = $<val>0->type_val;
                                $1->type_val = FUNC;
				set_symbol_value($1->name, $1,false, false);
				fprintf(testc, "void call_%s() {\n", $1->name);}

| ID po params PF              {$1->type_return = $<val>0->type_val;
                                $1->type_val = FUNC;
				set_symbol_value($1->name, $1,false,false);}
;

po : PO                        {fprintf(testc, "void call_%s() {\n", $<val>0->name);}
;

params: params vir type ID      {
                                set_symbol_value($4->name,$<val>3,false, true); 
                                fprintf(testh,"int");
                                for(int i = 0; i<$<val>3->num_ref; i++){
                                fprintf(testh,"*");
                                }
                                fprintf(testh," r%i;\n",get_symbol_value($4->name, true)->reg_number);
                                fprintf(testc, " sp = sp - r0;\n");
			                        	fprintf(testc, " raddr_count = raddr_count - r0;\n");
                                fprintf(testc, " r%d = *sp;\n", get_symbol_value($4->name, true)->reg_number);}
| type ID                      {
                                set_symbol_value($2->name,$<val>1,false, true);
                                fprintf(testh,"int");
                                for(int i = 0; i<$<val>1->num_ref; i++){
                                fprintf(testh,"*");
                                }
                                fprintf(testh," r%i;\n",get_symbol_value($2->name, true)->reg_number);              
                                fprintf(testc, " sp = sp - r0;\n");
				                        fprintf(testc, " raddr_count = raddr_count - r0;\n");
                                fprintf(testc, " r%d = *sp;\n",  get_symbol_value($2->name, true)->reg_number);}

vlist: vlist vir ID            {if(existing_symbol_in_same_block($3->name, curr_block())){
                                    fprintf(stderr,"ERROR: Symbol already declared\n");
				                            exit(-1);}
                                set_symbol_value($3->name,$<val>0,false, false);
                                $3->reg_number = newReg();
                                fprintf(testh,"int");
                                for(int i = 0; i<$<val>3->num_ref; i++){
                                  fprintf(testh,"*");
                                }
                                fprintf(testh," r%i;\n",$3->reg_number);
                                fprintf(testh,"int");
                                for(int i = 0; i<$<val>3->num_ref; i++){
                                  fprintf(testh,"*");
                                }
                                fprintf(testh," %s%d;\n",$3->name,get_symbol_value($3->name, false)->num_block);}

| ID                           {if(existing_symbol_in_same_block($1->name, curr_block())){
                                    fprintf(stderr,"ERROR: Symbol already declared\n");
				                            exit(-1);}
                                set_symbol_value($1->name,$<val>0,false, false);

                                fprintf(testh,"int");
                                for(int i = 0; i<$<val>0->num_ref; i++){
                                  fprintf(testh,"*");
                                }
                                fprintf(testh," r%i;\n",get_symbol_value($1->name, false)->reg_number);
                                fprintf(testh,"int");
                                for(int i = 0; i<$<val>0->num_ref; i++){
                                  fprintf(testh,"*");
                                }
                                fprintf(testh," %s%d;\n",$1->name,get_symbol_value($1->name, false)->num_block);
                                }

;

vir : VIR                      {}
;

fun_body : ao block af         {fprintf(testc, "}\n");}
;

ao : AO                        {new_block();}
;
af : AF                        {end_block();}
;
// Block
block:
decl_list inst_list            {}
;

// I. Declarations

decl_list : decl_list decl     {}
|                              {}
;

decl: var_decl PV              {}
;

var_decl : type vlist          {}
;


type
: typename pointer             {$$ = $1; 
                                $$->num_ref = $2;}
| typename                     {$$ = $1;}
;


typename
: TINT                          {$$ = new_attribute();
                                 $$->type_val = INT;
                                 $$->reg_number = newReg();}
| VOID                          {$$ = new_attribute();
                                 $$->type_val = VD;
                                 $$->reg_number = newReg();}
;

pointer
: pointer STAR                   {$$ = $1 + 1; }
| STAR                           {$$ = 1;}
;




// II. Intructions

inst_list: inst PV inst_list {}
| inst pvo                   {}
;

pvo : PV
|
;


inst:
exp                           {}
| ao block af                 {}
| aff                         {}
| ret                         {}
| cond                        {}
| loop                        {}
| PV                          {}
;

// II.1 Affectations


aff : ID EQ exp               {test_type(get_symbol_value($1->name, false),$3);           
                              fprintf(testc," r%i = r%i;\n",get_symbol_value($1->name, false)->reg_number,
                              $3->reg_number);     
                              fprintf(testc," %s%d = r%i;\n", $1->name, get_symbol_value($1->name, false)->num_block ,
                              get_symbol_value($1->name, false)->reg_number);}


| STAR exp  EQ exp            {fprintf(testc," *r%d = r%d;\n", $2->reg_number, $4->reg_number);}
;



// II.2 Return
ret : RETURN exp              {fprintf(testc, " *fp = r%d;\n", $2->reg_number);}
| RETURN PO PF                {}
;

// II.3. Conditionelles
//           N.B. ces rêgles génèrent un conflit déclage reduction qui est résolu comme on le souhaite
//           i.e. en lisant un ELSE en entrée, si on peut faire une reduction elsop, on la fait...

cond :
if bool_cond inst elsop {}
;

elsop : else inst             {fprintf(testc, "label%d:\n;", $<num>1);}
|                             {fprintf(testc, "label%d:\n;", $<num>-1);}
;

bool_cond : PO exp PF         {$$ = new_label();
                               fprintf(testc, " if (!r%d) goto label%d;\n", $2->reg_number, $$);}
;

if : IF                       {}
;

else : ELSE                   {$$ = new_label();
                               fprintf(testc, "goto label%d;\nlabel%d:\n", $$, $<num>-1);}
;

// II.4. Iterations

loop : while while_cond inst  {fprintf(testc, "goto label%d;\nlabel%d:\n;", $1, $2);}
;

while_cond : PO exp PF        {$$ = new_label();
                               fprintf(testc, " if(!r%d) goto label%d;\n", $2->reg_number, $$);}

while : WHILE                 {$$ = new_label();
                               fprintf(testc, "label%d:\n", $$);}
;


// II.3 Expressions
exp
// II.3.0 Exp. arithmetiques
: MOINS exp %prec UNA         {$$ = new_attribute();
                              fprintf(testc," r%d = - r%d;\n",$$->reg_number = newReg(), $2->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp PLUS exp                {$$ = new_attribute();
                              fprintf(testc," r%d = r%d + r%d;\n",$$->reg_number = newReg(), $1->reg_number, $3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp MOINS exp               {$$ = new_attribute();
                              fprintf(testc," r%d = r%d - r%d;\n",$$->reg_number = newReg(), $1->reg_number, $3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp STAR exp                {$$ = new_attribute();
                              fprintf(testc," r%d = r%d * r%d;\n",$$->reg_number = newReg(), $1->reg_number, $3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp DIV exp                 {$$ = new_attribute();
                              fprintf(testc," r%d = r%d / r%d;\n",$$->reg_number = newReg(), $1->reg_number, $3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| ID                              {$$ = get_symbol_value($1->name, false);$$->name = $1->name;}
| PO exp PF                   {}
| app                         {$$ = $1;}
| NUMI                        {$$=new_attribute();
                              fprintf(testc," r%d = %s;\n",$$->reg_number=newReg(),yytext);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| NUMF                        {$$=new_attribute();
                              fprintf(testc," r%d = %s;\n",$$->reg_number=newReg(),yytext);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
//; II.3.1 Déréférencement

| STAR exp %prec UNA          {$$=get_symbol_value($2->name, false);
                                $$->num_ref--;
                                fprintf(testc," r%d = *r%d;\n", $$->reg_number=newReg(),$2->reg_number);
                                fprintf(testh,"int r%d;\n", $$->reg_number);}

// II.3.2. Booléens

| NOT exp %prec UNA           {$$ = new_attribute(); $$->reg_number = newReg();
                              fprintf(testc," r%d = (!r%d) ;\n",$$->reg_number,$2->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp INF exp                 {$$ = new_attribute(); $$->reg_number = newReg();
                              fprintf(testc," r%d = r%d < r%d ;\n",$$->reg_number,$1->reg_number,$3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp SUP exp                 {$$ = new_attribute(); $$->reg_number = newReg();
                              fprintf(testc," r%d = r%d > r%d ;\n",$$->reg_number,$1->reg_number,$3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp EQUAL exp               {$$ = new_attribute(); $$->reg_number = newReg();
                              fprintf(testc," r%d = r%d == r%d ;\n",$$->reg_number,$1->reg_number,$3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp DIFF exp                {$$ = new_attribute(); $$->reg_number = newReg();
                              fprintf(testc," r%d = r%d != r%d ;\n",$$->reg_number,$1->reg_number,$3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp AND exp                 {$$ = new_attribute(); $$->reg_number = newReg();
                              fprintf(testc," r%d = r%d && r%d ;\n",$$->reg_number,$1->reg_number,$3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}
| exp OR exp                  {$$ = new_attribute(); $$->reg_number = newReg();
                              fprintf(testc," r%d = r%d || r%d ;\n",$$->reg_number,$1->reg_number,$3->reg_number);
                              fprintf(testh,"int r%d;\n",$$->reg_number);}

;

// II.4 Applications de fonctions

app : ID PO args PF          {attribute r = get_symbol_value($1->name, false);
                              attribute x = new_attribute();
			      x->type_val = r->type_return;
			      x->reg_number = newReg();
			      fprintf(testh,"int");
                              for(int i = 0; x->num_ref; i++){
                                fprintf(testh,"*");
                                }
			      fprintf(testh," r%i;\n",x->reg_number);
			      fprintf(testc, "call_%s();\n", get_symbol_value($1->name, false)->name);
			      fprintf(testc, "r%d = *fp;\n", x->reg_number);
			      fprintf(testc, "sp = sp - r0;\n");
			      fprintf(testc, "raddr_count = raddr_count - r0;\n");
			      fprintf(testc, "fp = fp - raddr_count;\n");
			      $$ = x;};

args :  arglist               {}
|                             {}
;

arglist : exp VIR arglist     {fprintf(testc,"*sp = r%d;\n",$1->reg_number);
                               fprintf(testc,"sp = sp + r0; \n");
			                        fprintf(testc, "raddr_count = raddr_count + r0;\n");}
  
| exp                         {//fprintf(testc,"*sp = (int)fp;\n");
                               //fprintf(testc,"sp = sp + r0;\n");
                               fprintf(testc,"fp = sp;\n");
			       fprintf(testc,"sp = sp +1;\n");
			       fprintf(testc, "raddr_count = raddr_count + r0;\n");
			       fprintf(testc,"*sp = r%d;\n",$1->reg_number);
			       fprintf(testc,"sp = sp + r0; \n");
			       fprintf(testc, "raddr_count = raddr_count + r0;\n");}
;



%% 
int main (int argc, char* argv[]) { 
  testc = fopen (argv[2], "w+");
  testh = fopen (argv[1], "w+");
  fprintf(testh, "#ifndef TEST_H\n");
  fprintf(testh, "#define TEST_H\n");
  fprintf(testh, "#include <stdio.h>\n");
  fprintf(testh, "#include <stdlib.h>\n");
  fprintf(testh, "#include <string.h>\n");
  fprintf(testh, "int pile[255];");
  fprintf(testh, "int raddr_count;");
  fprintf(testh, "int*fp; \nint*sp;\n");
  fprintf(testh, "int r0;\n");
  fprintf(testc, "#include \"test.h\"\n");
  yyparse ();
  fprintf(testc, "int main() {\n fp = pile; \n sp= pile;\n raddr_count = 0;\n r0 = 1;\n");
  fprintf(testc, " call_main();\n");
  fprintf(testh, "#endif\n");
  fprintf(testc, " return 0; }\n");
  return 0;
} 
