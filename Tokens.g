/*
 * Sparql 1.0 lexer grammar
 *
*/

lexer grammar Tokens ;


options {
  language = Java;
//  k = 1;
//  memoize = true;
}


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

TRUE
    : ('T'|'t')('R'|'r')('U'|'u')('E'|'e')
    ;

FALSE
    : ('F'|'f')('A'|'a')('L'|'l')('S'|'s')('E'|'e')
    ;

IF
	: ('I'|'i')('F'|'f')
	;

COALESCE
	: ('C'|'c')('O'|'o')('A'|'a')('L'|'l')('E'|'e')('S'|'s')('C'|'c')('E'|'e')
	;

IRI_REF
    : LESS ( options {greedy=false;} : ~(LESS | GREATER | '"' | OPEN_CURLY_BRACE | CLOSE_CURLY_BRACE | '|' | '^' | '\\' | '`' | ('\u0000'..'\u0020')) )* GREATER
    
    ;

PNAME_NS
    : p=PN_PREFIX? ':'
    ;

PNAME_LN
    : PNAME_NS PN_LOCAL
    ;

VAR1
    : '?' v=VARNAME 
    ;

VAR2
    : '$' v=VARNAME 
    ;

LANGTAG
    : '@' (('a'..'z' | 'A'..'Z'))+ (MINUS (('a'..'z' | 'A'..'Z')('0'..'9'))+)*
    
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
    : PLUS n=INTEGER 
    ;

DECIMAL_POSITIVE
    : PLUS n=DECIMAL 
    ;

DOUBLE_POSITIVE
    : PLUS n=DOUBLE 
    ;

INTEGER_NEGATIVE
    : MINUS n=INTEGER 
    ;

DECIMAL_NEGATIVE
    : MINUS n=DECIMAL 
    ;

DOUBLE_NEGATIVE
    : MINUS n=DOUBLE 
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

//NIL
//    : OPEN_BRACE WS* CLOSE_BRACE
//    ;

//fragment
WS
    : (' '| '\t'| EOL) { skip(); }
    ;

//ANON
//    : OPEN_SQUARE_BRACE (WS)* CLOSE_SQUARE_BRACE 
//    ;

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
    : '_:' t=PN_LOCAL 
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
    : '#' .* EOL { skip(); }
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
