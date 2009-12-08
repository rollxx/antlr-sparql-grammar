/*
 * Sparql 1.1 grammar
 *
*/

grammar Sparql;

options {
  language = Php;
  k = 1;
}


// $<Parser

query
    : prologue ( selectQuery | constructQuery | describeQuery | askQuery ) EOF
    ;

prologue
    : baseDecl? prefixDecl*
    ;

baseDecl
    : BASE IRI_REF
    ;

prefixDecl
    : PREFIX PNAME_NS IRI_REF
    ;

updateUnit
    : prologue (update | manage)*
    ;

update
    : modify
    | insert
    | delete
    | load
    | clear
    ;

modify
    : MODIFY (graphIRI)* DELETE constructTemplate INSERT constructTemplate updatePattern?
    ;

delete
    : DELETE (deleteData | deleteTemplate)
    ;

deleteData
    : DATA (FROM? iriRef)* constructTemplate
    ;

deleteTemplate
    : (FROM? iriRef)* constructTemplate updatePattern?
    ;

insert
    : INSERT (insertData | insertTEmplate)
    ;

insertData
    : DATA (INTO? iriRef)* constructTemplate
    ;

insertTemplate
    : (INTO? iriRef)* constructTemplate updatePattern?
    ;

graphIri
    : GRAPH iriRef
    ;

load
    : LOAD iriRef+ (INTO iriRef)?
    ;

clear
    : CLEAR graphIri?
    ;

manage
    : create
    | drop
    ;

create
    : CREATE SILENT? graphIri
    ;

drop
    : DROP SILENT? graphIri
    ;

updatePattern
    : WHERE? groupGraphPattern
    ;


selectQuery
    : SELECT ( DISTINCT | REDUCED )? ( variable+ | ASTERISK ) datasetClause* whereClause solutionModifier 
{
echo "whereClause= " . $whereClause.text . "\n";
echo "selectQuery= " . $selectQuery.text . "\n";
}
    ;

constructQuery
    : CONSTRUCT constructTemplate datasetClause* whereClause solutionModifier
    ;

describeQuery
    : DESCRIBE ( varOrIRIref+ | ASTERISK ) datasetClause* whereClause? solutionModifier
    ;

askQuery
    : ASK datasetClause* whereClause
    ;

datasetClause
    : FROM ( defaultGraphClause | namedGraphClause )
    ;

defaultGraphClause
    : sourceSelector
    ;

namedGraphClause
    : NAMED sourceSelector
    ;

sourceSelector
    : iriRef
    ;

whereClause
    : WHERE? groupGraphPattern
    ;

solutionModifier
    : groupClause? havingClause? orderClause? limitOffsetClauses?
    ;

groupClause
	: GROUP BY groupCondition+
	;

groupCondition
	: (builtInCall | functionCall | OPEN_BRACE expression ( AS variable)? CLOSE_BRACE | variable)
	;
	
havingClause
	: HAVING havingCondition+
	;

havingCondition
	: constraint
	;

limitOffsetClauses
    : ( limitClause offsetClause? | offsetClause limitClause? )
    ;

orderClause
    : ORDER BY orderCondition+
    ;

orderCondition
    : ( ( ASC | DESC ) brackettedExpression )
    | ( constraint | variable )
    ;

limitClause
    : LIMIT INTEGER
    ;

offsetClause
    : OFFSET INTEGER
    ;

groupGraphPattern
	: OPEN_CURLY_BRACE ( subSelect | groupGraphPatternSub ) CLOSE_CURLY_BRACE
    ;

groupGraphPatternSub
	: triplesBlock? ( ( graphPatternNotTriples | filter ) DOT? triplesBlock? )*
    ;

project
	: SELECT (DISTINCT | REDUCED)? (ASTERISK | (variable | builtInCall | functionCall | ( OPEN_BRACE expression (AS variable)? CLOSE_BRACE )+ ))
	;

triplesBlock
    : triplesSameSubject ( DOT triplesBlock? )?
    ;

graphPatternNotTriples
    : optionalGraphPattern | groupOrUnionGraphPattern | graphGraphPattern
    ;

optionalGraphPattern
    : OPTIONAL groupGraphPattern
    ;

graphGraphPattern
    : GRAPH varOrIRIref groupGraphPattern
    ;

groupOrUnionGraphPattern
    : groupGraphPattern ( UNION groupGraphPattern )*
    ;

filter
    : FILTER constraint
    ;

constraint
    : brackettedExpression | builtInCall | functionCall
    ;

functionCall
    : iriRef argList
    ;

argList
    : NIL | OPEN_BRACE expression ( COMMA expression )* CLOSE_BRACE
    ;

constructTemplate
    : OPEN_CURLY_BRACE constructTriples? CLOSE_CURLY_BRACE {}
    ;

constructTriples
    : triplesSameSubject ( DOT constructTriples? )?
    ;

triplesSameSubject
    : varOrTerm propertyListNotEmpty
    | triplesNode propertyList
    ;

propertyListNotEmpty
    : verb objectList ( SEMICOLON ( verb objectList )? )*
    ;

propertyList
    : propertyListNotEmpty?
    ;

objectList
    : object ( COMMA object )*
    ;

object
    : graphNode
    ;

verb
    : varOrIRIref
    | A
    ;

triplesNode
    : collection
    | blankNodePropertyList
    ;

blankNodePropertyList
    : OPEN_SQUARE_BRACE propertyListNotEmpty CLOSE_SQUARE_BRACE
    ;

collection
    : OPEN_BRACE graphNode+ CLOSE_BRACE
    ;

graphNode
    : varOrTerm | triplesNode
    ;

varOrTerm
    : variable
    | graphTerm
    ;

varOrIRIref
    : variable | iriRef
    ;

variable
    : VAR1 {echo "var1 = " . $VAR1.text . "\n";}
    | VAR2 {echo "var2 = " . $VAR2.text . "\n";}
    ;

graphTerm
    : iriRef
    | rdfLiteral
    | numericLiteral
    | booleanLiteral
    | blankNode
    | NIL
    ;

expression
    : conditionalOrExpression
    ;

conditionalOrExpression
    : conditionalAndExpression ( OR conditionalAndExpression )*
    ;

conditionalAndExpression
    : valueLogical ( AND valueLogical )*
    ;

valueLogical
    : relationalExpression
    ;

relationalExpression
    : numericExpression ( EQUAL numericExpression | NOT_EQUAL numericExpression | LESS numericExpression | GREATER numericExpression | LESS_EQUAL numericExpression | GREATER_EQUAL numericExpression )?
    ;

numericExpression
    : additiveExpression
    ;

additiveExpression
    : multiplicativeExpression ( PLUS multiplicativeExpression | MINUS multiplicativeExpression | numericLiteralPositive | numericLiteralNegative )*
    ;

multiplicativeExpression
    : unaryExpression ( ASTERISK unaryExpression | DIVIDE unaryExpression )*
    ;

unaryExpression
    : NOT_SIGN primaryExpression
    | PLUS primaryExpression
    | MINUS primaryExpression
    | primaryExpression
    ;

primaryExpression
    : brackettedExpression | builtInCall | iriRefOrFunction | rdfLiteral | numericLiteral | booleanLiteral | variable
    ;

brackettedExpression
    : OPEN_BRACE expression CLOSE_BRACE
    ;

builtInCall
    : STR OPEN_BRACE expression CLOSE_BRACE
    | LANG OPEN_BRACE expression CLOSE_BRACE
    | LANGMATCHES OPEN_BRACE expression COMMA expression CLOSE_BRACE
    | DATATYPE OPEN_BRACE expression CLOSE_BRACE
    | BOUND OPEN_BRACE variable CLOSE_BRACE
    | SAMETERM OPEN_BRACE expression COMMA expression CLOSE_BRACE
    | ISIRI OPEN_BRACE expression CLOSE_BRACE
    | ISURI OPEN_BRACE expression CLOSE_BRACE
    | ISBLANK OPEN_BRACE expression CLOSE_BRACE
    | ISLITERAL OPEN_BRACE expression CLOSE_BRACE
    | regexExpression
	| SUM OPEN_BRACE aggregateExpression CLOSE_BRACE
	| AVG OPEN_BRACE aggregateExpression CLOSE_BRACE
	| COUNT OPEN_BRACE DISTINCT? (expression | ASTERISK)? CLOSE_BRACE
	| MIN OPEN_BRACE aggregateExpression CLOSE_BRACE
	| MAX OPEN_BRACE aggregateExpression CLOSE_BRACE
    ;

aggregateExpression
	: DISTINCT? expression
	;

subSelect
	: project whereClause solutionModifier
	;



regexExpression
    : REGEX OPEN_BRACE expression COMMA expression ( COMMA expression )? CLOSE_BRACE
    ;

iriRefOrFunction
    : iriRef argList?
    ;

rdfLiteral
    : string ( LANGTAG | ( REFERENCE iriRef ) )?
    ;

numericLiteral
    : numericLiteralUnsigned | numericLiteralPositive | numericLiteralNegative
    ;

numericLiteralUnsigned
    : INTEGER
    | DECIMAL
    | DOUBLE
    ;

numericLiteralPositive
    : INTEGER_POSITIVE
    | DECIMAL_POSITIVE
    | DOUBLE_POSITIVE
    ;

numericLiteralNegative
    : INTEGER_NEGATIVE
    | DECIMAL_NEGATIVE
    | DOUBLE_NEGATIVE
    ;

booleanLiteral
    : TRUE
    | FALSE
    ;

string
    : STRING_LITERAL1
    | STRING_LITERAL2
    | STRING_LITERAL_LONG1
    | STRING_LITERAL_LONG2
    ;

iriRef
    : IRI_REF
    | prefixedName
    ;

prefixedName
    : PNAME_LN
    | PNAME_NS
    ;

blankNode
    : BLANK_NODE_LABEL
    | ANON
    ;

// $>

BASE
    : ('B'|'b')('A'|'a')('S'|'s')('E'|'e')
    ;

PREFIX
    : ('P'|'p')('R'|'r')('E'|'e')('F'|'f')('I'|'i')('X'|'x')
    ;

MODIFY
	: ('M'|'m')('O'|'o')('D'|'d')('I'|'i')('F'|'f')('Y'|'y')
	;

DELETE
	: ('D'|'d')('E'|'e')('L'|'l')('E'|'e')('T'|'t')('E'|'e')
	;

INSERT
	: ('I'|'i')('N'|'n')('S'|'s')('E'|'e')('R'|'r')('T'|'t')
	;

DATA
	: ('D'|'d')('A'|'a')('T'|'t')('A'|'a')
	;

INTO
	:('I'|'i')('N'|'n')('T'|'t')('O'|'o')
	;

LOAD
	: ('L'|'l')('O'|'o')('A'|'a')('D'|'d')
	;

CLEAR
	: ('C'|'c')('L'|'l')('E'|'e')('A'|'a')('R'|'r')
	;
CREATE
	: ('C'|'c')('R'|'r')('E'|'e')('A'|'a')('T'|'t')('E'|'e')
	;

SILENT
	: ('S'|'s')('I'|'i')('L'|'l')('E'|'e')('N'|'n')('T'|'t')
	;

DROP
	: ('D'|'d')('R'|'r')('O'|'o')('P'|'p')
	;

EXISTS
	: ('E'|'e')('X'|'x')('I'|'i')('S'|'s')('T'|'t')('S'|'s')
	;
	
UNSAID
	: ('U'|'u')('N'|'n')('S'|'s')('A'|'a')('I'|'i')('D'|'d')
	;

NOT
	: ('N'|'n')('O'|'o')('T'|'t')
	;

SELECT
    : ('S'|'s')('E'|'e')('L'|'l')('E'|'e')('C'|'c')('T'|'t')
    ;

DISTINCT
    : ('D'|'d')('I'|'i')('S'|'s')('T'|'t')('I'|'i')('N'|'n')('C'|'c')('T'|'t')
    ;

REDUCED
    : ('R'|'r')('E'|'e')('D'|'d')('U'|'u')('C'|'c')('E'|'e')('D'|'d')
    ;

CONSTRUCT
    : ('C'|'c')('O'|'o')('N'|'n')('S'|'s')('T'|'t')('R'|'r')('U'|'u')('C'|'c')('T'|'t')
    ;

DESCRIBE
    : ('D'|'d')('E'|'e')('S'|'s')('C'|'c')('R'|'r')('I'|'i')('B'|'b')('E'|'e')
    ;

ASK
    : ('A'|'a')('S'|'s')('K'|'k')
    ;

FROM
    : ('F'|'f')('R'|'r')('O'|'o')('M'|'m')
    ;

NAMED
    : ('N'|'n')('A'|'a')('M'|'m')('E'|'e')('D'|'d')
    ;   

WHERE
    : ('W'|'w')('H'|'h')('E'|'e')('R'|'r')('E'|'e')
    ;

ORDER
    : ('O'|'o')('R'|'r')('D'|'d')('E'|'e')('R'|'r')
    ;

GROUP
	: ('G'|'g')('R'|'r')('O'|'o')('U'|'u')('P'|'p')
	;

HAVING
	: ('H'|'h')('A'|'a')('V'|'v')('I'|'i')('N'|'n')('G'|'g')
	;

BY
    : ('B'|'b')('Y'|'y')
    ;

ASC
    : ('A'|'a')('S'|'s')('C'|'c')
    ;

DESC
    : ('D'|'d')('E'|'e')('S'|'s')('C'|'c')
    ;

LIMIT
    : ('L'|'l')('I'|'i')('M'|'m')('I'|'i')('T'|'t')
    ;

OFFSET
    : ('O'|'o')('F'|'f')('F'|'f')('S'|'s')('E'|'e')('T'|'t')
    ;

OPTIONAL
    : ('O'|'o')('P'|'p')('T'|'t')('I'|'i')('O'|'o')('N'|'n')('A'|'a')('L'|'l')
    ;  

GRAPH
    : ('G'|'g')('R'|'r')('A'|'a')('P'|'p')('H'|'h')
    ;   

UNION
    : ('U'|'u')('N'|'n')('I'|'i')('O'|'o')('N'|'n')
    ;

FILTER
    : ('F'|'f')('I'|'i')('L'|'l')('T'|'t')('E'|'e')('R'|'r')
    ;

A
    : ('a')
    ;

AS
	: ('A'|'a')('S'|'s')
	;

STR
    : ('S'|'s')('T'|'t')('R'|'r')
    ;

LANG
    : ('L'|'l')('A'|'a')('N'|'n')('G'|'g')
    ;

LANGMATCHES
    : ('L'|'l')('A'|'a')('N'|'n')('G'|'g')('M'|'m')('A'|'a')('T'|'t')('C'|'c')('H'|'h')('E'|'e')('S'|'s')
    ;

DATATYPE
    : ('D'|'d')('A'|'a')('T'|'t')('A'|'a')('T'|'t')('Y'|'y')('P'|'p')('E'|'e')
    ;

BOUND
    : ('B'|'b')('O'|'o')('U'|'u')('N'|'n')('D'|'d')
    ;

SAMETERM
    : ('S'|'s')('A'|'a')('M'|'m')('E'|'e')('T'|'t')('E'|'e')('R'|'r')('M'|'m')
    ;

ISIRI
    : ('I'|'i')('S'|'s')('I'|'i')('R'|'r')('I'|'i')
    ;

ISURI
    : ('I'|'i')('S'|'s')('U'|'u')('R'|'r')('I'|'i')
    ;

ISBLANK
    : ('I'|'i')('S'|'s')('B'|'b')('L'|'l')('A'|'a')('N'|'n')('K'|'k')
    ;

ISLITERAL
    : ('I'|'i')('S'|'s')('L'|'l')('I'|'i')('T'|'t')('E'|'e')('R'|'r')('A'|'a')('L'|'l')
    ;

REGEX
    : ('R'|'r')('E'|'e')('G'|'g')('E'|'e')('X'|'x')
    ;

COUNT
	: ('C'|'c')('O'|'o')('U'|'u')('N'|'n')('T'|'t')
	;

SUM
	:('S'|'s')('U'|'u')('M'|'m')
	;

MIN
	:('M'|'m')('I'|'i')('N'|'n')
	;

MAX
	: ('M'|'m')('A'|'a')('X'|'x')
	;

AVG
	: ('A'|'a')('V'|'v')('G'|'g')
	;

TRUE
    : ('T'|'t')('R'|'r')('U'|'u')('E'|'e')
    ;

FALSE
    : ('F'|'f')('A'|'a')('L'|'l')('S'|'s')('E'|'e')
    ;

IRI_REF
    : LESS ( options {greedy=false;} : ~(LESS | GREATER | '"' | OPEN_CURLY_BRACE | CLOSE_CURLY_BRACE | '|' | '^' | '\\' | '`' | ('\u0000'..'\u0020')) )* GREATER
    {\$this->setText(substr(\$this->getText(), 1, strlen(\$this->getText()) - 2)); }
    ;

PNAME_NS
    : p=PN_PREFIX? ':'
    ;

PNAME_LN
    : PNAME_NS PN_LOCAL
    ;

VAR1
    : '?' v=VARNAME {\$this->setText($v.text); }
    ;

VAR2
    : '$' v=VARNAME {\$this->setText($v.text); }
    ;

LANGTAG
    : '@' (('a'..'z')('A'..'Z'))+ (MINUS (('a'..'z')('A'..'Z')('0'..'9'))+)*
    ;

INTEGER
    : ('0'..'9')+
    ;

DECIMAL
    : ('0'..'9')+ DOT ('0'..'9')*
    | DOT ('0'..'9')+
    ;

DOUBLE
    : DIGIT+ DOT DIGIT* EXPONENT
    | DOT DIGIT+ EXPONENT
    | DIGIT+ EXPONENT
    ;

fragment
DIGIT
    : '0'..'9'
    ;

INTEGER_POSITIVE
    : PLUS INTEGER
    ;

DECIMAL_POSITIVE
    : PLUS DECIMAL
    ;

DOUBLE_POSITIVE
    : PLUS DOUBLE
    ;

INTEGER_NEGATIVE
    : MINUS INTEGER
    ;

DECIMAL_NEGATIVE
    : MINUS DECIMAL
    ;

DOUBLE_NEGATIVE
    : MINUS DOUBLE
    ;

fragment
EXPONENT : ('e'|'E') (PLUS|MINUS)? ('0'..'9')+ ;

STRING_LITERAL1
    : '\'' ( options {greedy=false;} : ~('\u0027' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '\''
    ;

STRING_LITERAL2
    : '"'  ( options {greedy=false;} : ~('\u0022' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '"'
    ;

STRING_LITERAL_LONG1
    :   '\'\'\'' ( options {greedy=false;} : ( '\'' | '\'\'' )? ( ~( '\'' | '\\' ) | ECHAR ) )* '\'\'\''
    ;

STRING_LITERAL_LONG2
    : '"""' ( options {greedy=false;} : ( '"' | '""' )? ( ~( '"' | '\\' ) | ECHAR ) )* '"""'
    ;

fragment
ECHAR
    : '\\' ('t' | 'b' | 'n' | 'r' | 'f' | '\\' | '"' | '\'')
    ;

NIL
    : WS+ { $channel=HIDDEN; }
    ;

fragment
WS
    : (' '| '\t'| EOL) { $channel=HIDDEN; }
    ;

ANON
    : OPEN_SQUARE_BRACE (WS)* CLOSE_SQUARE_BRACE
    ;

fragment
PN_CHARS_BASE
    : 'A'..'Z'
    | 'a'..'z'
    | '\u00C0'..'\u00D6'
    | '\u00D8'..'\u00F6'
    | '\u00F8'..'\u02FF'
    | '\u0370'..'\u037D'
    | '\u037F'..'\u1FFF'
    | '\u200C'..'\u200D'
    | '\u2070'..'\u218F'
    | '\u2C00'..'\u2FEF'
    | '\u3001'..'\uD7FF'
    | '\uF900'..'\uFDCF'
    | '\uFDF0'..'\uFFFD'
    ;

fragment
PN_CHARS_U
    : PN_CHARS_BASE | '_'
    ;

fragment
VARNAME
    : ( PN_CHARS_U | ('0'..'9') ) ( PN_CHARS_U | ('0'..'9') | '\u00B7' | '\u0300'..'\u036F' | '\u203F'..'\u2040' )*
    ;

fragment
PN_CHARS
    : PN_CHARS_U
    | MINUS
    | ('0'..'9')
    | '\u00B7' 
    | '\u0300'..'\u036F'
    | '\u203F'..'\u2040'
    ;

fragment
PN_PREFIX
    : PN_CHARS_BASE ((PN_CHARS|DOT)* PN_CHARS)?
    ;


fragment
PN_LOCAL
    : ( PN_CHARS_U | ('0'..'9') ) ((PN_CHARS|DOT)* PN_CHARS)?
    ;

BLANK_NODE_LABEL
    : '_:' t=PN_LOCAL {\$this->setText($t.text); }
    ;

REFERENCE
	: '^^'
	;


AND
    : '&&'
    ;

OR
    : '||'
    ;

COMMENT 
    : '#' .* EOL { $channel=HIDDEN; }
    ;

fragment
EOL
    : '\n' | '\r'
    ;

OPEN_CURLY_BRACE
	: '{'
	;

CLOSE_CURLY_BRACE
	: '}'
	;

SEMICOLON
    : ';'
    ;

DOT
    : '.'
    ;

PLUS
    : '+'
    ;

MINUS
    : '-'
    ;

ASTERISK
    : '*'
    ;

COMMA
    : ','
    ;

NOT_SIGN
    : '!'
    ;
DIVIDE
    : '/'
    ;

EQUAL
    : '='
    ;

LESS
	: '<'
	;

GREATER
	: '>'
	;

OPEN_BRACE
    : '('
    ;

CLOSE_BRACE
    : ')'
    ;

LESS_EQUAL
    : '<='
    ;

GREATER_EQUAL
    : '>='
    ;

NOT_EQUAL
    : '!='
    ;

OPEN_SQUARE_BRACE
    : '['
    ;

CLOSE_SQUARE_BRACE
    : ']'
    ;


// $>
