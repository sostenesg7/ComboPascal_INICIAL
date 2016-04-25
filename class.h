#include <map>
#include <iostream>

//singleton
class Context {
	
	private:
		static Context *instancia;
		map <string, double> tabela;
		Context();
	public:
		static Context & getContext(){
			if(instancia == NULL){
				instancia = new Context();
			}
			return *instancia;
		}
	//set/get context	
}

class Valor{
	public:
		enum tipo{
			NONE,
			INT,
			DOUBLE,
		};
		virtual tipo getTipo() = 0;
}

class intValue : public Valor{
	private:
		int value;
	public:
		int getValue()const{
			return this->value;
		}
		int value(int value):value(value){			
		}
		virtual tipo getTipo(){
		};
		return INT;
}

class doubleValue : public Valor{
	private:
		int value;
	public:
		int getValue()const{
			return this->value;
		}
		int value(int value):value(value){			
		}
		virtual tipo getTipo(){
			return INT;
		};
		
}


/*going of four
design patterns
eric gamma*/