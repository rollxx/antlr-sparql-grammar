/*
 * Sparql 1.0 grammar
 *
*/

parser grammar Sparql10 ;

options{
  tokenVocab = Tokenizer;
}

/* sparql 1.0 r1 */
start
    : prologue ( 
        selectQuery
        | constructQuery 
        | describeQuery 
        | askQuery 
        )
    ;

/* sparql 1.0 r2 */
prologue
    : baseDecl? prefixDecl*
    ;

/* sparql 1.0 r3 */
baseDecl
    : BASE iriRef 
    ;

/* sparql 1.0 r4 */
prefixDecl

    : PREFIX PNAME_NS iriRef
    ;

/* sparql 1.0 r5 */
selectQuery
    : SELECT ( DISTINCT 
        | REDUCED 
        )? ( variable+ | ASTERISK ) datasetClause* whereClause solutionModifier 
    ;

/* sparql 1.0 r6 */
constructQuery
    : CONSTRUCT constructTemplate datasetClause* whereClause solutionModifier
    ;

/* sparql 1.0 r7 */
describeQuery
    : DESCRIBE ( varOrIRIref+ | ASTERISK ) datasetClause* whereClause? solutionModifier
    ;

/* sparql 1.0 r8 */
askQuery
    : ASK datasetClause* whereClause 
    ;

/* sparql 1.0 r9 */
datasetClause
    : FROM ( defaultGraphClause 
        | namedGraphClause 
        )
    ;

/* sparql 1.0 r10 */
defaultGraphClause
    : sourceSelector 
    ;

/* sparql 1.0 r11 */
namedGraphClause
    : NAMED sourceSelector 
    ;

/* sparql 1.0 r12 */
sourceSelector
    : iriRef 
    ;

/* sparql 1.0 r13 */
whereClause
    : WHERE? groupGraphPattern 
    ;

/* sparql 1.0 r14 */
solutionModifier
    : orderClause? limitOffsetClauses?
    ;
/* sparql 1.0 r15 */
limitOffsetClauses
    : limitClause offsetClause? 
    | offsetClause limitClause?
    ;

/* sparql 1.0 r16 */
orderClause
    : ORDER BY orderCondition+
    ;

/* sparql 1.0 r17 */
orderCondition
    : ( ( o=ASC | o=DESC ) brackettedExpression ) 
    | ( v=constraint | v=variable) 
    ;

/* sparql 1.0 r18 */
limitClause
    : LIMIT INTEGER 
    ;

/* sparql 1.0 r19 */
offsetClause
    : OFFSET INTEGER 
    ;

/* sparql 1.0 r20 */
groupGraphPattern
	: OPEN_CURLY_BRACE (t1=triplesBlock )?
	( ( v=graphPatternNotTriples | v=filter ) 
            DOT? (t2=triplesBlock )? )* CLOSE_CURLY_BRACE
    ;

/* sparql 1.0 r21 */
triplesBlock
    : triplesSameSubject ( DOT (t=triplesBlock )? )? 
    ;

/* sparql 1.0 r22 */
graphPatternNotTriples
    : v=optionalGraphPattern 
    | v=groupOrUnionGraphPattern 
    | v=graphGraphPattern 
    ;

/* sparql 1.0 r23 */
optionalGraphPattern
    : OPTIONAL groupGraphPattern 
    ;

/* sparql 1.0 r24 */
graphGraphPattern
    : GRAPH varOrIRIref groupGraphPattern 
    ;

/* sparql 1.0 r25 */
groupOrUnionGraphPattern
    : v1=groupGraphPattern ( UNION v2=groupGraphPattern )*
    ;

/* sparql 1.0 r26 */
filter
    : FILTER constraint 
    ;

/* sparql 1.0  r27 */
constraint
    : v=brackettedExpression
    | v=builtInCall
    | v=functionCall
    ;
/* sparql 1.0 r28 */
functionCall
    : iriRef argList 
    ;

/* sparql 1.0 r29 */
argList
    : OPEN_BRACE WS* CLOSE_BRACE
    | OPEN_BRACE e1=expression 
        ( COMMA e2=expression )* CLOSE_BRACE
    ;

/* sparql 1.0 r30 */
constructTemplate
    : OPEN_CURLY_BRACE (constructTriples )? CLOSE_CURLY_BRACE
    ;

/* sparql 1.0 r31 */
constructTriples
	: OPEN_CURLY_BRACE (constructTriples )? CLOSE_CURLY_BRACE
    ;

/* sparql 1.0 r32 */
triplesSameSubject
    : varOrTerm propertyListNotEmpty 
    | triplesNode propertyList 
    ;

/* sparql 1.0 r33 */
propertyListNotEmpty
    : v1=verb ol1=objectList 
        ( SEMICOLON ( v2=verb ol2=objectList )? )*
    ;

/* sparql 1.0 r34 */
propertyList
    : (propertyListNotEmpty )?
    ;

/* sparql 1.0 r35 */
objectList
    : o1=object 
        ( COMMA o2=object  )*
    ;

/* sparql 1.0 r36 */
object
    : graphNode 
    ;

/* sparql 1.0  r37 */
verb
    : varOrIRIref 
    | A 
    ;

/* sparql 1.0 r38 */
triplesNode
    : collection 
    | blankNodePropertyList 
    ;

/* sparql 1.0 r39 */
blankNodePropertyList
    : OPEN_SQUARE_BRACE propertyListNotEmpty CLOSE_SQUARE_BRACE 
    ;

/* sparql 1.0 r40 */
collection
    : OPEN_BRACE (graphNode )+ CLOSE_BRACE
    ;

/* sparql 1.0 r41 */
graphNode
    : varOrTerm 
    | triplesNode 
    ;

/* sparql 1.0 r42 */
varOrTerm
    : variable 
    | graphTerm 
    ;

/* sparql 1.0 r43 */
varOrIRIref
    : variable 
    | iriRef 
    ;

/* sparql 1.0 r44 */
variable
    : v=VAR1 
    | v=VAR2 
    ;

/* sparql 1.0 r45 */
graphTerm
    : v=iriRef 
    | v=rdfLiteral 
    | v=numericLiteral 
    | v=booleanLiteral 
    | v=blankNode 
    | OPEN_BRACE WS* CLOSE_BRACE 
    ;

/* sparql 1.0 r46 */
expression
    : conditionalOrExpression 
    ;

/* sparql 1.0 r47 */
conditionalOrExpression
    : c1=conditionalAndExpression 
    ( OR c2=conditionalAndExpression )*
    ;

/* sparql 1.0 r48*/
conditionalAndExpression
	: v1=valueLogical ( AND v2=valueLogical )*
    ;

/* sparql 1.0 r49 */
valueLogical
    : relationalExpression 
    ;

/* sparql 1.0 r50 */
relationalExpression
    : n1=numericExpression 
        ( EQUAL n2=numericExpression 
        | NOT_EQUAL n2=numericExpression 
        | LESS n2=numericExpression 
        | GREATER n2=numericExpression 
        | LESS_EQUAL n2=numericExpression 
        | GREATER_EQUAL n2=numericExpression
        )?
    ;

/* sparql 1.0 r51 */
numericExpression
    : additiveExpression 
    ;

/* sparql 1.0 r52 */
additiveExpression
    : m1=multiplicativeExpression 
        (( op=PLUS m2=multiplicativeExpression 
        | op=MINUS m2=multiplicativeExpression 
        | n=numericLiteralPositive 
        | n=numericLiteralNegative 
            ))*
    ;

/* sparql 1.0 r53 */
multiplicativeExpression
    : u1=unaryExpression 
        (( op=ASTERISK u2=unaryExpression | op=DIVIDE u2=unaryExpression ))*
    ;

/* sparql 1.0 r54 */
unaryExpression
    : NOT_SIGN e=primaryExpression 
    | PLUS e=primaryExpression 
    | MINUS e=primaryExpression 
    | e=primaryExpression 
    ;

/* sparql 1.0 r55 */
primaryExpression
    : v=brackettedExpression 
    | v=builtInCall 
    | v=iriRefOrFunction 
    | v=rdfLiteral 
    | v=numericLiteral 
    | v=booleanLiteral 
    | v=variable 
    ;

/* sparql 1.0 r56 */
brackettedExpression
    : OPEN_BRACE e=expression CLOSE_BRACE 
    ;

/* sparql 1.0 r57 */
builtInCall
    : STR OPEN_BRACE e=expression CLOSE_BRACE 
    | LANG OPEN_BRACE e=expression CLOSE_BRACE 
    | LANGMATCHES OPEN_BRACE e1=expression COMMA e2=expression CLOSE_BRACE 
    | DATATYPE OPEN_BRACE e=expression CLOSE_BRACE 
    | BOUND OPEN_BRACE variable CLOSE_BRACE 
    | SAMETERM OPEN_BRACE e1=expression COMMA e2=expression CLOSE_BRACE 
    | ISIRI OPEN_BRACE e=expression CLOSE_BRACE 
    | ISURI OPEN_BRACE e=expression CLOSE_BRACE 
    | ISBLANK OPEN_BRACE e=expression CLOSE_BRACE 
    | ISLITERAL OPEN_BRACE e=expression CLOSE_BRACE 
    | regexExpression 
    ;

/* sparql 1.0 r58 */
regexExpression
    : REGEX OPEN_BRACE e1=expression COMMA e2=expression ( COMMA e3=expression )? CLOSE_BRACE
    
    ;

/* sparql 1.0 r59 */
iriRefOrFunction
    : iriRef 
        (argList )?
    ;

/* sparql 1.0 r60 */
rdfLiteral
    : string 
        ( LANGTAG  
        | ( REFERENCE iriRef  ) )?
    ;

/* sparql 1.0 r61 */
numericLiteral
    : (n=numericLiteralUnsigned
	| n=numericLiteralPositive
	| n=numericLiteralNegative ) 
    ;

/* sparql 1.0 r62 */
numericLiteralUnsigned
    : v=INTEGER 
    | v=DECIMAL 
    | v=DOUBLE 
    ;

/* sparql 1.0 r63 */
numericLiteralPositive
    : v=INTEGER_POSITIVE 
    | v=DECIMAL_POSITIVE 
    | v=DOUBLE_POSITIVE 
    ;

/* sparql 1.0 r64 */
numericLiteralNegative
    : v=INTEGER_NEGATIVE 
    | v=DECIMAL_NEGATIVE 
    | v=DOUBLE_NEGATIVE 
    ;

/* sparql 1.0 r65 */
booleanLiteral
    : TRUE 
    | FALSE 
    ;

/* sparql 1.0 r66 */
string
    : STRING_LITERAL1
    | STRING_LITERAL2
    | STRING_LITERAL_LONG1
    | STRING_LITERAL_LONG2
    ;

/* sparql 1.0 r67 */
iriRef
    : IRI_REF 
    | prefixedName 
    ;

/* sparql 1.0 r68 */
prefixedName
    : PNAME_LN
    | PNAME_NS
    ;

/* sparql 1.0 r69 */
blankNode
    : v=BLANK_NODE_LABEL 
    | OPEN_SQUARE_BRACE (WS)* CLOSE_SQUARE_BRACE 
    ;
