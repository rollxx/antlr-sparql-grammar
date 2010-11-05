parser grammar Virtuoso;

options{
tokenVocab = Tokenizer;
}
import Sparql11Virtuoso;

queryV
  :
  prologueV
  (
    queryBody
    | sparulAction*
    | qmStmt (DOT qmStmt)* DOT?
  )
  ;

prologueV
  :
  define* baseDecl? prefixDecl*
  ;

/* virtuoso 6.0 sparql grammar */

define
  :
  DEFINE prefixedName
  (
    prefixedName
    | string
  )
  ;

queryBody
  :
  selectQuery
  | constructQuery
  | describeQuery
  | askQuery
  ;

selectQuery
  :
  SELECT DISTINCT?
  (
    (retCol (COMMA? retCol)*)
    | ASTERISK
  )
  datasetClause* whereClause solutionModifier
  ;

/* virtuoso 6.0 sparql grammar */

retCol
  :
  (
    variable
    | (OPEN_BRACE expression CLOSE_BRACE)
    | retAggCall
  )
  (AS variable)?
  ;

retAggCall
  :
  agName OPEN_BRACE
  (
    ASTERISK
    | (DISTINCT? variableV)
  )
  CLOSE_BRACE
  ;

agName
  :
  COUNT
  | AVG
  | MIN
  | MAX
  | SUM
  ;

precodeExpn
  :
  expression
  ;

variableV
  :
  (
    variable
    | globalVar
  )
  (
    (
      PLUS
      | ASTERISK
    )
    GREATER iriRef
  )?
  ;

globalVar
  :
  MNAME
  | DOLLAR_COLON_PARAMNAME
  | QUEST_COLON_PARAMNUM
  | DOLLAR_COLON_PARAMNUM
  ;

// sparul

sparulAction
  :
  createAction
  | dropAction
  | loadAction
  | insertAction
  | insertDataAction
  | deleteDataAction
  | modifyAction
  | clearAction
  ;

insertAction
  :
  INSERT
  (
    (
      IN
      | INTO
    )
    GRAPH (IDENTIFIED BY)?
  )?
  precodeExpn constructTemplate (datasetClause whereClause solutionModifier)?
  ;

insertDataAction
  :
  INSERT DATA
  (
    (
      IN
      | INTO
    )
    GRAPH (IDENTIFIED BY)?
  )?
  precodeExpn constructTemplate
  ;

deleteAction
  :
  DELETE (FROM GRAPH (IDENTIFIED BY)?)? precodeExpn constructTemplate (datasetClause* whereClause solutionModifier)?
  ;

deleteDataAction
  :
  DELETE DATA (FROM GRAPH (IDENTIFIED BY)?)? precodeExpn constructTemplate
  ;

modifyAction
  :
  MODIFY (GRAPH (IDENTIFIED BY)?)? precodeExpn? DELETE constructTemplate INSERT constructTemplate (datasetClause* whereClause solutionModifier)?
  ;

clearAction
  :
  CLEAR (GRAPH IDENTIFIED BY)? precodeExpn
  ;

loadAction
  :
  LOAD precodeExpn
  ;

createAction
  :
  CREATE SILENT? GRAPH (IDENTIFIED BY)? precodeExpn
  ;

dropAction
  :
  DROP SILENT? GRAPH (IDENTIFIED BY)? precodeExpn
  ;

qmStmt
  :
  qmSimpleStmt
  | qmCreateStorage
  | qmAlterStorage
  ;

qmSimpleStmt
  :
  qmCreateIriClass
  | qmCreateLiteralClass
  //  | qmDropIriClass
  | qmDropLiteralClass
  //  | qmCreateIriSubclass
  //  | qmDropQuadStorage
  | qmDropQuadMap
  ;

qmCreateIriClass
  :
  CREATE IRI CLASS iriRef //qmIriRefConst
  (
    (string /*qmSqlfuncArgList*/
           )
    | (USING qmSqlfuncHeader COMMA qmSqlfuncHeader)
  )
  ;

qmCreateLiteralClass
  :
  CREATE LITERAL CLASS qmIRIrefConst USING qmSqlfuncHeader COMMA qmSqlfuncHeader qmLiteralClassOptions?
  ;

qmDropIRIClass
  :
  DROP IRI CLASS qmIRIrefConst
  ;

qmDropLiteralClass
  :
  DROP LITERAL CLASS qmIRIrefConst
  ;

qmCreateIRISubclass
  :
  IRI CLASS qmIRIrefConst SUBCLASS OF qmIRIrefConst
  ;

qmIRIClassOptions
  :
  OPTION OPEN_BRACE qmIRIClassOption (COMMA qmIRIClassOption)* CLOSE_BRACE
  ;

qmIRIClassOption
  :
  BIJECTION
  | DEREF
  | RETURNS string (UNION string)*
  ;

qmLiteralClassOptions
  :
  OPTION OPEN_BRACE qmLiteralClassOption (COMMA qmLiteralClassOption)* CLOSE_BRACE
  ;

qmLiteralClassOption
  :
  (DATATYPE qmIRIrefConst)
  | (LANG string)
  | BIJECTION
  | DEREF
  | RETURNS string (UNION string)*
  ;

qmCreateStorage
  :
  CREATE QUAD STORAGE qmIRIrefConst qmSourceDecl* qmMapTopGroup
  ;

qmAlterStorage
  :
  ALTER QUAD STORAGE qmIRIrefConst qmSourceDecl* qmMapTopGroup
  ;

qmDropStorage
  :
  DROP QUAD STORAGE qmIRIrefConst
  ;

qmDropQuadMap
  :
  DROP QUAD MAP GRAPH? qmIRIrefConst
  ;

qmDrop
  :
  DROP GRAPH? qmIRIrefConst
  ;

qmSourceDecl
  :
  (FROM QTABLE AS PLAIN_ID qmTextLiteral*)
  | (FROM PLAIN_ID AS PLAIN_ID qmTextLiteral*)
  | qmCondition
  ;

qmTextLiteral
  :
  TEXT XML? LITERAL qmSqlCol (OF qmSqlCol)? //qmTextLiteralOptions?
  ;

// qmTextLiteralOptions   : OPTION OPEN_BRACE qmTextLiteralOption ( COMMA qmTextLiteralOption )* CLOSE_BRACE;

qmMapTopGroup
  :
  OPEN_CURLY_BRACE qmMapTopOp (DOT qmMapTopOp)* DOT? CLOSE_CURLY_BRACE
  ;

qmMapTopOp
  :
  qmMapOp
  | qmDropQuadMap
  | qmDrop
  ;

qmMapGroup
  :
  OPEN_CURLY_BRACE qmMapOp (DOT qmMapOp)* DOT? CLOSE_CURKY_BRACE
  ;

qmMapOp
  :
  (CREATE qmIRIrefConst AS qmMapIdDef)
  | (CREATE GRAPH? qmIRIrefConst USING STORAGE qmIRIrefConst qmOptions?)
  | (qmNamedField+ qmOptions? qmMapGroup)
  | qmTriples1
  ;

qmMapIdDef
  :
  qmMapTriple
  | (qmNamedField+ qmOptions? qmMapGroup)
  ;

qmMapTriple
  :
  qmFieldOrBlank qmVerb qmObjField
  ;

qmTriples1
  :
  qmFieldOrBlank qmProps
  ;

qmNamedField
  :
  (
    GRAPH
    | SUBJECT
    | PREDICATE
    | OBJECT
  )
  qmField
  ;

qmProps
  :
  qmProp (SEMICOLON qmProp)?
  ;

qmProp
  :
  qmVerb qmObjField (COMMA qmObjField)*
  ;

qmObjField
  :
  qmFieldOrBlank qmCondition* qmOptions?
  ;

qmIdSuffix
  :
  AS qmIRIrefConst
  ;

qmVerb
  :
  QmField
  | (OPEN_SQUARE_BRACE CLOSE_SQUARE_BRACE)
  | A
  ;

qmFieldOrBlank
  :
  qmField
  | (OPEN_SQUARE_BRACE CLOSE_SQUARE_BRACE)
  ;

qmField
  :
  numericLiteral
  | rdfLiteral
  | (qmIRIrefConst (OPEN_BRACE (qmSqlCol (COMMA qmSqlCol)*)? CLOSE_BRACE)?)
  | QmSqlCol
  ;

qmCondition
  :
  WHERE
  (
    (OPEN_BRACE SQLTEXT CLOSE_BRACE)
    | string
  )
  ;

qmOptions
  :
  OPTION OPEN_BRACE qmOption (COMMA qmOption)* CLOSE_BRACE
  ;

qmOption
  :
  (SOFT? EXCLUSIVE)
  | (ORDER INTEGER)
  | (USING PLAIN_ID)
  ;

qmSqlfuncHeader
  :
  FUNCTION SQL_QTABLECOLNAME qmSqlfuncArglist RETURNS qmSqltype
  ;

qmSqlfuncArglist
  :
  OPEN_BRACE (qmSqlfuncArg (COMMA qmSqlfuncArg)*)? CLOSE_BRACE
  ;

qmSqlfuncArg
  :
  (
    IN
    | qmSqlId
  )
  qmSqlId qmSqltype
  ;

qmSqltype
  :
  qmSqlId (NOT NULL)?
  ;

qmSqlCol
  :
  qmSqlId
  //| 'spar_qm_sql_id'
  ;

qmSqlId
  :
  PLAIN_ID
  | TEXT
  | XML
  ;

qmIRIrefConst
  :
  iriRef
  | (IRI OPEN_BRACE string CLOSE_BRACE)
  ;
