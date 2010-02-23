grammar Sparql11query;


options {
  language = Java;
//  k = 1;
//  memoize = true;
}
// made according to this version
// http://www.w3.org/TR/2010/WD-sparql11-query-20100126/
import Tokens ;

fakestart :  start EOF;

/* sparql 1.1 r1 */
start
    : prologue (
    	selectQuery 
    	| constructQuery 
    	| describeQuery 
    	| askQuery
    	)
    ;

/* sparql 1.1 r2 */
prologue
    : baseDecl? prefixDecl*
    ;

/* sparql 1.1 r3 */
baseDecl
    : BASE iriRef
    ;

/* sparql 1.1 r4 */
prefixDecl
    : PREFIX PNAME_NS iriRef
    ;

/* sparql 1.1 r5 */
selectQuery
    : SELECT ( DISTINCT | REDUCED )? ( variable+ | ASTERISK ) datasetClause* whereClause solutionModifier 
    ;

/* sparql 1.1 r6 */
constructQuery
    : CONSTRUCT constructTemplate datasetClause* whereClause solutionModifier
    ;

/* sparql 1.1 r7 */
describeQuery
    : DESCRIBE ( varOrIRIref+ | ASTERISK ) datasetClause* whereClause? solutionModifier
    ;

/* sparql 1.1 r8 */
askQuery
    : ASK datasetClause* whereClause
    ;

/* sparql 1.1 r9 */
datasetClause
    : FROM ( defaultGraphClause | namedGraphClause )
    ;

/* sparql 1.1 r10 */
defaultGraphClause
    : sourceSelector
    ;

/* sparql 1.1 r11 */
namedGraphClause
    : NAMED sourceSelector
    ;

/* sparql 1.1 r12 */
sourceSelector
    : iriRef
    ;

/* sparql 1.1 r13 */
whereClause
    : WHERE? groupGraphPattern
    ;

/* sparql 1.1 r14 */
solutionModifier
    : orderClause? limitOffsetClauses?
    ;

/* sparql 1.1 r15 */
limitOffsetClauses
    : limitClause offsetClause? 
    | offsetClause limitClause?
    ;

/* sparql 1.1 r16 */
orderClause
    : ORDER BY orderCondition+
    ;

/* sparql 1.1 r17 */
orderCondition
    : ( ( ASC | DESC ) brackettedExpression )
    | ( constraint | variable)
    ;

/* sparql 1.1 r18 */
limitClause
    : LIMIT INTEGER
    ;

/* sparql 1.1 r19 */
offsetClause
    : OFFSET INTEGER
    ;

/* sparql 1.1 update r20 */
groupGraphPattern
	: OPEN_CURLY_BRACE  triplesBlock? ((graphPatternNotTriples | filter) DOT? triplesBlock? )* CLOSE_CURLY_BRACE	
	;

/* sparql 1.1 update r21 */
triplesBlock
    : triplesSameSubject ( DOT triplesBlock? )?
    ;

/* sparql 1.1 update r22*/
graphPatternNotTriples
    : optionalGraphPattern 
    | groupOrUnionGraphPattern 
    | graphGraphPattern
    ;

/* sparql 1.1 update r23 */
optionalGraphPattern
    : OPTIONAL groupGraphPattern
    ;

/* sparql 1.1 update r24 */
graphGraphPattern
    : GRAPH varOrIRIref groupGraphPattern
    ;

/* sparql 1.1 update r25 */
groupOrUnionGraphPattern
    : groupGraphPattern ( UNION groupGraphPattern )*
    ;

/* sparql 1.1 update r26 */
filter
    : FILTER constraint
    ;

/* sparql 1.1 update r27 */
constraint
    : brackettedExpression
    | builtInCall
    | functionCall
    ;

/* sparql 1.1 update r28 */
functionCall
    : iriRef argList
    ;

/* sparql 1.1 update r29 */
argList
    : OPEN_BRACE WS* CLOSE_BRACE | OPEN_BRACE expression ( COMMA expression )* CLOSE_BRACE
    ;

/* sparql 1.1 r30 */
constructTemplate
    : OPEN_CURLY_BRACE constructTriples? CLOSE_CURLY_BRACE
    ;

/* sparql 1.1 r31 */
constructTriples
    : triplesSameSubject ( DOT constructTriples? )?
    ;

/* sparql 1.1 r32 */
triplesSameSubject
    : varOrTerm propertyListNotEmpty
    | triplesNode propertyList
    ;

/* sparql 1.1 update r33 */
propertyListNotEmpty
    : verb objectList ( SEMICOLON ( verb objectList )? )*
    ;

/* sparql 1.1 update r34 */
propertyList
    : propertyListNotEmpty?
    ;

/* sparql 1.1 update r35 */
objectList
    : object ( COMMA object )*
    ;

/* sparql 1.1 update r36 */
object
    : graphNode
    ;

/* sparql 1.1 update r37 */
verb
    : varOrIRIref
    | A
    ;

/* sparql 1.1 update r38 */
triplesNode
    : collection
    | blankNodePropertyList
    ;

/* sparql 1.1 update r39 */
blankNodePropertyList
    : OPEN_SQUARE_BRACE propertyListNotEmpty CLOSE_SQUARE_BRACE
    ;

/* sparql 1.1 update r40 */
collection
    : OPEN_BRACE graphNode+ CLOSE_BRACE
    ;

/* sparql 1.1 update r41 */
graphNode
    : varOrTerm 
    | triplesNode
    ;

/* sparql 1.1 update r42 */
varOrTerm
    : variable
    | graphTerm
    ;

/* sparql 1.1 update r43 */
varOrIRIref
    : variable 
    | iriRef
    ;

/* sparql 1.1 update r44 */
variable
    : VAR1
    | VAR2
    ;

/* sparql 1.1 update r45 */
graphTerm
    : iriRef
    | rdfLiteral
    | numericLiteral
    | booleanLiteral
    | blankNode
    | OPEN_BRACE WS* CLOSE_BRACE
    ;

/* sparql 1.1 update r46 */
expression
    : conditionalOrExpression
    ;

/* sparql 1.1 update r47 */
conditionalOrExpression
    : conditionalAndExpression ( OR conditionalAndExpression )*
    ;

/* sparql 1.1 update r48 */
conditionalAndExpression
    : valueLogical ( AND valueLogical )*
    ;

/* sparql 1.1 update r49 */
valueLogical
    : relationalExpression
    ;

/* sparql 1.1 update r50 */
relationalExpression
    : numericExpression 
        ( EQUAL numericExpression 
        | NOT_EQUAL numericExpression 
        | LESS numericExpression 
        | GREATER numericExpression 
        | LESS_EQUAL numericExpression 
        | GREATER_EQUAL numericExpression
        )?
    ;

/* sparql 1.1 update r51 */
numericExpression
    : additiveExpression
    ;

/* sparql 1.1 update r52 */
additiveExpression
    : multiplicativeExpression 
        ( PLUS multiplicativeExpression 
        | MINUS multiplicativeExpression 
        | numericLiteralPositive
        | numericLiteralNegative
        )*
    ;

/* sparql 1.1 update r53 */
multiplicativeExpression
    : unaryExpression ( ASTERISK unaryExpression | DIVIDE unaryExpression )*
    ;

/* sparql 1.1 update r54 */
unaryExpression
    : NOT_SIGN primaryExpression
    | PLUS primaryExpression
    | MINUS primaryExpression
    | primaryExpression
    ;

/* sparql 1.1 update r55 */
primaryExpression
    : brackettedExpression 
    | builtInCall 
    | iriRefOrFunction 
    | rdfLiteral 
    | numericLiteral 
    | booleanLiteral 
    | variable
    ;

/* sparql 1.1 update r56 */
brackettedExpression
    : OPEN_BRACE expression CLOSE_BRACE
    ;

/* sparql 1.1 update r57 */
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
    ;

/* sparql 1.1 update r58 */
regexExpression
    : REGEX OPEN_BRACE expression COMMA expression ( COMMA expression )? CLOSE_BRACE
    ;

/* sparql 1.1 update r59 */
iriRefOrFunction
    : iriRef argList?
    ;

/* sparql 1.1 update r60 */
rdfLiteral
    : string ( LANGTAG | ( REFERENCE iriRef ) )?
    ;

/* sparql 1.1 update r61 */
numericLiteral
    : numericLiteralUnsigned 
	| numericLiteralPositive 
	| numericLiteralNegative
    ;

/* sparql 1.1 update r62 */
numericLiteralUnsigned
    : INTEGER
    | DECIMAL
    | DOUBLE
    ;

/* sparql 1.1 update r63 */
numericLiteralPositive
    : INTEGER_POSITIVE
    | DECIMAL_POSITIVE
    | DOUBLE_POSITIVE
    ;

/* sparql 1.1 update r64 */
numericLiteralNegative
    : INTEGER_NEGATIVE
    | DECIMAL_NEGATIVE
    | DOUBLE_NEGATIVE
    ;

/* sparql 1.1 update r65 */
booleanLiteral
    : TRUE
    | FALSE
    ;

/* sparql 1.1 update r66 */
string
    : STRING_LITERAL1
    | STRING_LITERAL2
    | STRING_LITERAL_LONG1
    | STRING_LITERAL_LONG2
    ;

/* sparql 1.1 update r67 */
iriRef
    : IRI_REF
    | prefixedName
    ;

/* sparql 1.1 update r68 */
prefixedName
    : PNAME_LN
    | PNAME_NS
    ;

/* sparql 1.1 update r69 */
blankNode
    : BLANK_NODE_LABEL
    | OPEN_SQUARE_BRACE (WS)* CLOSE_SQUARE_BRACE
    ;
