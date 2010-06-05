parser grammar Sparql11;

options{
tokenVocab = Tokenizer;
}

/* sparql 1.1 r1 */
top
  :
  prologue
  (
    query
    | update
  )
  ;

/* sparql 1.1 r2 */
queryUnit
  :
  prologue query
  ;

/* sparql 1.1 r3 */
query
  :
  selectQuery
  | constructQuery
  | describeQuery
  | askQuery
  ;

/* sparql 1.1 r4 */

prologue
  :
  baseDecl? prefixDecl*
  ;

/* sparql 1.1 r5 */

baseDecl
  :
  BASE IRI_REF
  ;

/* sparql 1.1 r6 */

prefixDecl
  :
  PREFIX PNAME_NS IRI_REF
  ;

/* sparql 1.1 r7 */

selectQuery
  :
  selectClause datasetClause* whereClause solutionModifier bindingsClause
  ;

/* sparql 1.1 r8 */

subSelect
  :
  selectClause whereClause solutionModifier
  ;

/* sparql 1.1 r9 */

selectClause
  :
  SELECT
  (
    DISTINCT
    | REDUCED
  )?
  (
    variable
    | (OPEN_BRACE expression AS variable CLOSE_BRACE)+
    | ASTERISK
  )
  ;

/* sparql 1.1 r10 */

constructQuery
  :
  CONSTRUCT constructTemplate datasetClause* whereClause solutionModifier
  ;

/* sparql 1.1 r11 */

describeQuery
  :
  DESCRIBE
  (
    varOrIriRef+
    | ASTERISK
  )
  datasetClause* whereClause? solutionModifier
  ;

/* sparql 1.1 r12 */

askQuery
  :
  ASK datasetClause* whereClause
  ;

/* sparql 1.1 r13 */

datasetClause
  :
  FROM
  (
    defaultGraphClause
    | namedGraphClause
  )
  ;

/* sparql 1.1 r14 */

defaultGraphClause
  :
  sourceSelector
  ;

/* sparql 1.1 r15 */

namedGraphClause
  :
  NAMED sourceSelector
  ;

/* sparql 1.1 r16 */

sourceSelector
  :
  iriRef
  ;

/* sparql 1.1 r17 */

whereClause
  :
  WHERE? groupGraphPattern
  ;

/* sparql 1.1 r18 */

solutionModifier
  :
  groupClause? havingClause? orderClause? limitOffsetClauses?
  ;

/* sparql 1.1 r19 */

groupClause : GROUP BY groupCondition+ ;

/* sparql 1.1 r20 */
groupCondition 
	:	builtInCall | functionCall | (OPEN_BRACE expression (AS variable)? CLOSE_BRACE )| variable ;

/* sparql 1.1 r21 */

havingClause : HAVING havingCondition+ ;

/* sparql 1.1 r22 */
havingCondition : constraint;

/* sparql 1.1 r23 */

orderClause
  :
  ORDER BY orderCondition+
  ;

/* sparql 1.1 r24 */

orderCondition
  :
  (
    (
      ASC
      | DESC
    )
    brackettedExpression
  )
  |
  (
    constraint
    | variable
  )
  ;

/* sparql 1.1 r25 */
limitOffsetClauses
    : (limitClause offsetClause?) | (offsetClause limitClause?) ;

/* sparql 1.1 r26 */

limitClause
  :
  LIMIT INTEGER
  ;

/* sparql 1.1 r27 */

offsetClause
  :
  OFFSET INTEGER
  ;

/* sparql 1.1 r28 */
bindingsClause
    : ( BINDINGS variable+ OPEN_CURLY_BRACE ( OPEN_BRACE bindingValue+ CLOSE_BRACE )* CLOSE_CURLY_BRACE )? ;

/* sparql 1.1 r29 */
  
bindingValue
    : iriRef | rdfLiteral | numericLiteral | booleanLiteral | UNDEF ;

/* sparql 1.1 r30 */
  
updateUnit
    : prologue update ;

/* sparql 1.1 r31 */
update
    : update1+;

/* sparql 1.1 r32 */
update1 :   
(modify
  | load
  | clear
  | drop
  | create
  )
  SEMICOLON?
  ;

/* sparql 1.1 r33 */
modify
  :
  (WITH iriRef)? ( insert | delete)
  ;

/* sparql 1.1 r34 */
insert : INSERT ( DATA quadData | quadTemplate WHERE groupGraphPattern);

/* sparql 1.1 r35 */
delete
  :
  DELETE ( DATA quadData | WHERE quadTemplate  | quadTemplate (INSERT quadTemplate)? WHERE groupGraphPattern)
  ;
  
/* sparql 1.1 r36 */
clear
    : CLEAR graphRef ;

/* sparql 1.1 r37 */
load
    : LOAD iriRef+  (INTO graphRef)?;

/* sparql 1.1 r38 */
drop
    : DROP SILENT? iriRef;

/* sparql 1.1 r39 */
create
    : CREATE SILENT? iriRef;

/* sparql 1.1 r40 */
graphRef
    : DEFAULT | iriRef;

/* sparql 1.1 r41 */
quadTemplate 
    : OPEN_CURLY_BRACE quads CLOSE_CURLY_BRACE;

/* sparql 1.1 r42 */
quads: triplesTemplate? (quadsNotTriples DOT? triplesTemplate? )*;

/* sparql 1.1 r43 */
quadsNotTriples : GRAPH varOrIriRef OPEN_CURLY_BRACE triplesTemplate CLOSE_CURLY_BRACE ;

/* sparql 1.1 r44 */
triplesTemplate : triplesSameSubject  ( DOT triplesTemplate? )?;

/* sparql 1.1 r45 */
quadData : OPEN_CURLY_BRACE quads CLOSE_CURLY_BRACE;

/* sparql 1.1 r46 */
groupGraphPattern
  :
  OPEN_CURLY_BRACE
  (
    subSelect
    | groupGraphPatternSub
  )
  CLOSE_CURLY_BRACE
  ;

/* sparql 1.1 r47 */
groupGraphPatternSub
  :
  triplesBlock?
  (
      graphPatternNotTriples
    DOT? triplesBlock?
  )*
  ;

/* sparql 1.1 r48 */
triplesBlock
    : triplesSameSubjectPath ( DOT? triplesBlock? )?;

/* sparql 1.1 r49 */
graphPatternNotTriples
    : groupGraphPattern  | optionalGraphPattern  | unionGraphPattern  | minusGraphPattern  | graphGraphPattern  | serviceGraphPattern  | filter ;

/* sparql 1.1 r50 */
optionalGraphPattern 
    : OPTIONAL groupGraphPattern;

/* sparql 1.1 r51 */
graphGraphPattern
  :
  GRAPH varOrIriRef groupGraphPattern
  ;

/* sparql 1.1 r52 */
serviceGraphPattern
    : SERVICE varOrIriRef groupGraphPattern ;

/* sparql 1.1 r53 */
minusGraphPattern
    : MINUS_P groupGraphPattern;

/* sparql 1.1 r54 */
unionGraphPattern
    : UNION groupGraphPattern ;

/* sparql 1.1 r55 */
filter
    : FILTER constraint ;

/* sparql 1.1 r56 */
constraint
  :
  brackettedExpression
  | builtInCall
  | functionCall
  ;

/* sparql 1.1 r57 */
functionCall
  :
  iriRef argList
  ;

/* sparql 1.1 r58 */
argList
  :
  OPEN_BRACE WS* CLOSE_BRACE
  | OPEN_BRACE DISTINCT? expression (COMMA expression)* CLOSE_BRACE
  ;

/* sparql 1.1 r59 */
exprAggArg : OPEN_BRACE DISTINCT? expression CLOSE_BRACE;

/* sparql 1.1 r60 */
expressionList :   OPEN_BRACE WS* CLOSE_BRACE
  | OPEN_BRACE expression (COMMA expression)* CLOSE_BRACE
  ;

/* sparql 1.1 r61 */
constructTemplate
    : OPEN_CURLY_BRACE constructTriples? CLOSE_CURLY_BRACE;

/* sparql 1.1 r62 */
constructTriples
    : triplesSameSubject ( DOT constructTriples?)? ;
 
/* sparql 1.1 r63 */
triplesSameSubject
    : varOrTerm propertyListNotEmpty | triplesNode propertyList;

/* sparql 1.1 r64 */
propertyListNotEmpty
    : verb objectList (SEMICOLON (verb objectList)?)*;

/* sparql 1.1 r65 */
propertyList
    : propertyListNotEmpty?;

/* sparql 1.1 r66 */
objectList
    : object (COMMA object)*;

/* sparql 1.1 r67 */
object
    : graphNode;

/* sparql 1.1 r68 */
verb
    : varOrIriRef | A;

/* sparql 1.1 r69 */
triplesSameSubjectPath
    : varOrTerm propertyListNotEmptyPath | triplesNode propertyListPath ;

/* sparql 1.1 r70 */
propertyListNotEmptyPath
    : (verbPath | verbSimple) objectList  (SEMICOLON ((verbPath | verbSimple) objectList )?)*
    ;

/* sparql 1.1 r71 */
propertyListPath
    : propertyListNotEmpty?;

/* sparql 1.1 r72 */
verbPath
    : path;

/* sparql 1.1 r73 */
verbSimple 
    : variable;

/* sparql 1.1 r74 */
path 
    : pathAlternative;

/* sparql 1.1 r75 */
pathAlternative 
    : pathSequence ('|' pathSequence)*;

/* sparql 1.1 r76 */
pathSequence 
    : pathEltOrInverse ( DIVIDE pathEltOrInverse | HAT_LABEL pathElt)*;

/* sparql 1.1 r77 */
pathElt 
    : pathPrimary pathMod?;

/* sparql 1.1 r78 */
pathEltOrInverse
    : pathElt | HAT_LABEL pathElt;

/* sparql 1.1 r79 */
pathMod
    : ASTERISK | QUESTION_MARK_LABEL | PLUS | OPEN_CURLY_BRACE (integer (COMMA (CLOSE_CURLY_BRACE | integer CLOSE_CURLY_BRACE ) | CLOSE_CURLY_BRACE));

/* sparql 1.1 r80 */
pathPrimary
    : iriRef | A | NOT_SIGN pathNegatedPropertyClass | OPEN_BRACE path CLOSE_BRACE;

/* sparql 1.1 r81 */
pathNegatedPropertyClass 
    : pathOneInPropertyClass | OPEN_BRACE (pathOneInPropertyClass (  '|' pathOneInPropertyClass)*)? CLOSE_BRACE;

/* sparql 1.1 r82 */
pathOneInPropertyClass
    : iriRef | A;

/* sparql 1.1 r83 */
integer
    : INTEGER;

/* sparql 1.1 r84 */
triplesNode
    : collection | blankNodePropertyList ;

/* sparql 1.1 r85 */
blankNodePropertyList
    : OPEN_SQUARE_BRACE propertyListNotEmpty CLOSE_SQUARE_BRACE ;

/* sparql 1.1 r86 */
collection
    : OPEN_BRACE graphNode+ CLOSE_BRACE ;

/* sparql 1.1 r87 */
graphNode
    : varOrTerm | triplesNode;

/* sparql 1.1 r88 */
varOrTerm
    : variable | graphTerm;

/* sparql 1.1 r89 */
varOrIriRef
    : variable | iriRef ;

/* sparql 1.1 r90 */
variable
    : VAR1 | VAR2;

/* sparql 1.1 r91 */
graphTerm
    : iriRef | rdfLiteral | numericLiteral | booleanLiteral | blankNode | OPEN_BRACE WS* CLOSE_BRACE;

/* sparql 1.1 r92 */
expression
    : conditionalOrExpression
    ;

/* sparql 1.1 r93 */
conditionalOrExpression
    : conditionalAndExpression
    ( OR conditionalAndExpression)*
    ;

/* sparql 1.1 r94 */
conditionalAndExpression
    : valueLogical ( AND valueLogical )*
    ;

/* sparql 1.1 r95 */
valueLogical
    : relationalExpression
    ;

/* sparql 1.1 r96 */
relationalExpression
    : numericExpression
        ( EQUAL numericExpression
        | NOT_EQUAL numericExpression
        | LESS numericExpression
        | GREATER numericExpression
        | LESS_EQUAL numericExpression
        | GREATER_EQUAL numericExpression
        | IN expressionList
        | NOT IN expressionList
        )?
    ;

/* sparql 1.1 r97 */
numericExpression
    : additiveExpression
    ;

/* sparql 1.1 r98 */
additiveExpression
    : multiplicativeExpression
        ( PLUS multiplicativeExpression
        | MINUS multiplicativeExpression
        | ( numericLiteralPositive
                | numericLiteralNegative)
                ((ASTERISK unaryExpression) | (DIVIDE unaryExpression))?
            )*
    ;

/* sparql 1.1 r99 */
multiplicativeExpression
    : unaryExpression
        ( ASTERISK unaryExpression | DIVIDE unaryExpression )*
    ;

/* sparql 1.1 r100 */
unaryExpression
    : NOT_SIGN primaryExpression
    | PLUS primaryExpression
    | MINUS primaryExpression
    | primaryExpression
    ;

/* sparql 1.1 r101 */
primaryExpression
    : brackettedExpression
    | builtInCall
    | iriRefOrFunction
    | rdfLiteral
    | numericLiteral
    | booleanLiteral
    | variable
    | aggregate
    ;

/* sparql 1.1 r102 */
brackettedExpression
    : OPEN_BRACE expression CLOSE_BRACE
    ;

/* sparql 1.1 r103 */
builtInCall
    : STR OPEN_BRACE expression CLOSE_BRACE
    | LANG OPEN_BRACE expression CLOSE_BRACE
    | LANGMATCHES OPEN_BRACE expression COMMA expression CLOSE_BRACE
    | DATATYPE OPEN_BRACE expression CLOSE_BRACE
    | BOUND OPEN_BRACE variable CLOSE_BRACE
    | IRI OPEN_BRACE variable CLOSE_BRACE
    | URI OPEN_BRACE variable CLOSE_BRACE
    | BNODE ((OPEN_BRACE variable CLOSE_BRACE) | OPEN_BRACE WS* CLOSE_BRACE)
    | COALESCE expressionList
    | IF OPEN_BRACE expression COMMA expression COMMA expression CLOSE_BRACE
    | STRLANG OPEN_BRACE expression COMMA expression CLOSE_BRACE
    | STRDT OPEN_BRACE expression COMMA expression CLOSE_BRACE
    | SAMETERM OPEN_BRACE expression COMMA expression CLOSE_BRACE
    | ISIRI OPEN_BRACE expression CLOSE_BRACE
    | ISURI OPEN_BRACE expression CLOSE_BRACE
    | ISBLANK OPEN_BRACE expression CLOSE_BRACE
    | ISLITERAL OPEN_BRACE expression CLOSE_BRACE
    | regexExpression
    | existsFunc
    | notExistsFunc
    ;

/* sparql 1.1 r104 */
regexExpression
    : REGEX OPEN_BRACE expression COMMA expression (COMMA expression)? CLOSE_BRACE
    ;

/* sparql 1.1 r105 */
existsFunc
    : EXISTS groupGraphPattern
    ;

/* sparql 1.1 r106 */
notExistsFunc
    : NOT EXISTS groupGraphPattern
    ;

/* sparql 1.1 r107 */
aggregate
    : ( COUNT OPEN_BRACE DISTINCT? (ASTERISK | expression) CLOSE_BRACE 
    | SUM exprAggArg 
    | MIN exprAggArg 
    | MAX exprAggArg 
    | AVG exprAggArg 
    | SAMPLE exprAggArg 
    | GROUP_CONCAT OPEN_BRACE DISTINCT? expression (COMMA expression)* ( SEMICOLON SEPARATOR EQUAL string)? CLOSE_BRACE)
    ;


/* sparql 1.1 r108 */
iriRefOrFunction
    : iriRef argList?
;

/* sparql 1.1 r109 */
rdfLiteral
    :   string ( LANGTAG | (REFERENCE iriRef))?
    ;

/* sparql 1.1 r110 */
numericLiteral
    : numericLiteralUnsigned
    | numericLiteralPositive
    | numericLiteralNegative
    ;

/* sparql 1.1 r111 */
numericLiteralUnsigned
    : INTEGER
    | DECIMAL
    | DOUBLE
    ;

/* sparql 1.1 r112 */
numericLiteralPositive
    : INTEGER_POSITIVE
    | DECIMAL_POSITIVE
    | DOUBLE_POSITIVE
    ;

/* sparql 1.1 r113 */
numericLiteralNegative
    : INTEGER_NEGATIVE
    | DECIMAL_NEGATIVE
    | DOUBLE_NEGATIVE
    ;

/* sparql 1.1 r114 */
booleanLiteral
    : TRUE | FALSE;

/* sparql 1.1 r115 */
string
    : STRING_LITERAL1 | STRING_LITERAL2 | STRING_LITERAL_LONG1 | STRING_LITERAL_LONG2
    ;

/* sparql 1.1 r116 */
iriRef
    : IRI_REF | prefixedName
    ;

/* sparql 1.1 r117 */
prefixedName
    : PNAME_LN | PNAME_NS
    ;

/* sparql 1.1 r118 */
blankNode
    : BLANK_NODE_LABEL | OPEN_BRACE WS* CLOSE_BRACE
    ;
