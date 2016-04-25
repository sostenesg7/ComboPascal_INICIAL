//bison -d -o arq.c arq.y (arquivo do bison)

%{
	#include <stdio.h>
	#include <math.h>
	void yyerror(const char *isso) {printf("%s\n", isso);}
%}

%token PLUS
%token MINUS
%token MULT
%token DIV
%token EXP
%token IDENTIFIER
%token DOUBLE_VAL
%token LPAR 
%token RPAR
%token EXPUN
%token LOG2
%token LF
%token INT_VAL


%union {
	int int_val;
	double double_val;
	char * str_val;
	Valor * valor;
};

%type <double_val> Valor 
%type <double_val> DOUBLE_VAL
%type <double_val> ExpUn
%type <double_val> Factor
%type <double_val> Exp
%type <int_val> INT_VAL
%type <str_val> IDENTIFIER
%type <valor> Valor
%type <valor> Exp

%%

programa : ListaExp;

ListaExp : comando
		 |ListaExp LF comando;
		 
comando :Exp {printf ("%1f",$1);};
		|Atrib
		
Atrib :: IDENTIFIER EQ Exp {map<string, double>&t = context :: getcontext().gettabela(); t[$1] = $3}		
		
Exp : Exp PLUS Factor {
		
		if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::INT){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue()+ static_cast <IntValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::DOUBLE){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() + static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::INT){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() + static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::DOUBLE){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue() + static_cast <DoubleValue*> ($3)->getValue());
		}
	}
	  |Exp MINUS Factor {
	  
	  if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::INT){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue() - static_cast <IntValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::DOUBLE){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() - static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::INT){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() - static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::DOUBLE){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue() - static_cast <DoubleValue*> ($3)->getValue());
		}
	  
	  }
	  |Factor {$$ = $1;};
	
Factor : Factor MULT ExpUn {

		if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::INT){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue() * static_cast <IntValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::DOUBLE){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() * static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::INT){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() * static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::DOUBLE){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue() * static_cast <DoubleValue*> ($3)->getValue());
		}

	     |Factor DIV ExpUn {
		 
		 if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::INT){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue() / static_cast <IntValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::DOUBLE){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() / static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::DOUBLE && $3->gettipo() == valor::INT){
			$$ = new DoubleValue(static_cast <DoubleValue*> ($1)->getValue() / static_cast <DoubleValue*> ($3)->getValue());
		}else if($1 -> gettipo() == valor::INT && $3->gettipo() == valor::DOUBLE){
			$$ = new IntValue(static_cast <IntValue*> ($1)->getValue() / static_cast <DoubleValue*> ($3)->getValue());
		}
		 
		 }
	     |ExpUn {$$ = $1;};
	   
ExpUn : PLUS Valor {$$ = $2;}
	    |MINUS Valor {$$ = -$2;}
	    |LOG2 LPAR Exp RPAR {$$ = log($3);}
	    |EXP LPAR Exp RPAR {$$ = exp($3);}
	    |Valor {$$ = $1;};
	  
Valor : INT_VAL {$$ = (double)$1;}
	    |IDENTIFIER{map<string, double>&t = context :: getcontext().gettabela();
			if(t.find($1)) == map<string,double>:: end(){
				yyerror("variavel nao existe");
				exit (1);
			}
			$$ = t[$1];
		}	
		|DOUBLE_VAL {$$ = $1;}
	    |LPAR Exp RPAR {$$ = $2;};
		|INT_VALUE = {$$ == new IntValue($1);}
%%

		