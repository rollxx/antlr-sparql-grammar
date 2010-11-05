grammar RootSparql;

options {
  language = Java;
//  backtrack=true;
//  memoize=true;
}



import Tokenizer, Sparql11, //Sparql10, 
Virtuoso;

parse
@init{
	bool sparql11= true;
	bool sparqlVirtuoso = false;
}
	:
	{sparql11}?=> top //| start  
	| {sparqlVirtuoso}?=>queryV
EOF
;