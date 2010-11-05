lexer grammar Tokenizer;

DATA
  :
  'data'
  ;

MODIFY
  :
  'modify'
  ;

DELETE
  :
  'delete'
  ;

INSERT
  :
  'insert'
  ;

INTO
  :
  'into'
  ;

LOAD
  :
  'load'
  ;

CLEAR
  :
  'clear'
  ;

CREATE
  :
  'create'
  ;

SILENT
  :
  'silent'
  ;

DROP
  :
  'drop'
  ;

DEFAULT
  :
  'default'
  ;

SERVICE
  :
  'service'
  ;

MINUS_P
  :
  'minus'
  ;

EXISTS
  :
  'exists'
  ;

UNSAID
  :
  'unsaid'
  ;

HAVING
  :
  'having'
  ;

COUNT
  :
  'count'
  ;

SUM
  :
  'sum'
  ;

MIN
  :
  'min'
  ;

MAX
  :
  'max'
  ;

AVG
  :
  'avg'
  ;

SAMPLE
  :
  'sample'
  ;

GROUP_CONCAT
  :
  'group_concat'
  ;

SEPARATOR
  :
  'separator'
  ;

COALESCE
  :
  'coalesce'
  ;

DEFINE
  :
  'define'
  ;

IF
  :
  'if'
  ;

BASE
  :
  'base'
  ;

PREFIX
  :
  'prefix'
  ;

IN
  :
  'in'
  ;

NOT
  :
  'not'
  ;

SELECT
  :
  'select'
  ;

DISTINCT
  :
  'distinct'
  ;

REDUCED
  :
  'reduced'
  ;

CONSTRUCT
  :
  'construct'
  ;

DESCRIBE
  :
  'describe'
  ;

ASK
  :
  'ask'
  ;

FROM
  :
  'from'
  ;

NAMED
  :
  'named'
  ;

WHERE
  :
  'where'
  ;

ORDER
  :
  'order'
  ;

GROUP
  :
  'group'
  ;

BY
  :
  'by'
  ;

ASC
  :
  'asc'
  ;

DESC
  :
  'desc'
  ;

LIMIT
  :
  'limit'
  ;

OFFSET
  :
  'offset'
  ;

BINDINGS
  :
  'bindings'
  ;

WITH
  :
  'with'
  ;

OPTIONAL
  :
  'optional'
  ;

GRAPH
  :
  'graph'
  ;

UNION
  :
  'union'
  ;

FILTER
  :
  'filter'
  ;

A
  :
  ('a')
  ;

AS
  :
  'as'
  ;

STR
  :
  'str'
  ;

LANG
  :
  'lang'
  ;

LANGMATCHES
  :
  'langmatches'
  ;

DATATYPE
  :
  'datatype'
  ;

BOUND
  :
  'bound'
  ;

SAMETERM
  :
  'sameterm'
  ;

IRI
  :
  'iri'
  ;

URI
  :
  'uri'
  ;

BNODE
  :
  'bnode'
  ;

STRLANG
  :
  'strlang'
  ;

STRDT
  :
  'strdt'
  ;

ISIRI
  :
  'isiri'
  ;

ISURI
  :
  'isuri'
  ;

ISBLANK
  :
  'isblank'
  ;

ISLITERAL
  :
  'isliteral'
  ;

ISNUMERIC
  :
  'isnumeric'
  ;

REGEX
  :
  'regex'
  ;

TRUE
  :
  'true'
  ;

FALSE
  :
  'false'
  ;

IRI_REF
  :
  LESS
  ( options {greedy=false;}:
    ~(
      LESS
      | GREATER
      | '"'
      | OPEN_CURLY_BRACE
      | CLOSE_CURLY_BRACE
      | '|'
      | '^'
      | '\\'
      | '`'
      | ('\u0000'..'\u0020')
     )
  )*
  GREATER
  ;

PNAME_NS
  :
  p=PN_PREFIX? ':'
  ;

PNAME_LN
  :
  PNAME_NS PN_LOCAL
  ;

VAR1
  :
  '?' v=VARNAME
  ;

VAR2
  :
  '$' v=VARNAME
  ;

LANGTAG
  :
  '@' ( ('a'..'z'))+
  (
    MINUS
    (
      ('a'..'z') ('0'..'9')
    )+
  )*
  ;

INTEGER
  :
  ('0'..'9')+
  ;

DECIMAL
  :
  ('0'..'9')+ DOT ('0'..'9')*
  | DOT ('0'..'9')+
  ;

DOUBLE
  :
  DIGIT+ DOT DIGIT* EXPONENT
  | DOT DIGIT+ EXPONENT
  | DIGIT+ EXPONENT
  ;

fragment
DIGIT
  :
  '0'..'9'
  ;

INTEGER_POSITIVE
  :
  PLUS n=INTEGER
  ;

DECIMAL_POSITIVE
  :
  PLUS n=DECIMAL
  ;

DOUBLE_POSITIVE
  :
  PLUS n=DOUBLE
  ;

INTEGER_NEGATIVE
  :
  MINUS n=INTEGER
  ;

DECIMAL_NEGATIVE
  :
  MINUS n=DECIMAL
  ;

DOUBLE_NEGATIVE
  :
  MINUS n=DOUBLE
  ;

fragment
EXPONENT
  :
  'e'
  (
    PLUS
    | MINUS
  )?
  ('0'..'9')+
  ;

STRING_LITERAL1
  :
  '\''
  ( options {greedy=false;}:
    ~(
      '\''
      | '\\'
      | '\n'
      | '\r'
     )
    | ECHAR
    | UNICODE_CHAR
  )*
  '\''
  ;

STRING_LITERAL2
  :
  '"'
  ( options {greedy=false;}:
    ~(
      '\"'
      | '\\'
      | '\n'
      | '\r'
     )
    | ECHAR
    | UNICODE_CHAR
  )*
  '"'
  ;

STRING_LITERAL_LONG1
  :
  '\'\'\''
  ( options {greedy=false;}:
    (
      '\''
      | '\'\''
    )?
    (
      ~(
        '\''
        | '\\'
       )
      | ECHAR
      | UNICODE_CHAR
    )
  )*
  '\'\'\''
  ;

STRING_LITERAL_LONG2
  :
  '"""'
  ( options {greedy=false;}:
    (
      '"'
      | '""'
    )?
    (
      ~(
        '"'
        | '\\'
       )
      | ECHAR
      | UNICODE_CHAR
    )
  )*
  '"""'
  ;

fragment
ECHAR
  :
  '\\'
  (
    't'
    | 'b'
    | 'n'
    | 'r'
    | 'f'
    | '\\'
    | '"'
    | '\''
  )
  ;

WS
  :
  (
    ' '
    | '\t'
    | EOL
  )+
  
  {
   $channel = HIDDEN;
  }
  ;

fragment
PN_CHARS_BASE
  :
  'a'..'z'
  //  | '\u00C0'..'\u00D6'
  //  | '\u00D8'..'\u00F6'
  //  | '\u00F8'..'\u02FF'
  //  | '\u0370'..'\u037D'
  //  | '\u037F'..'\u1FFF'
  //  | '\u200C'..'\u200D'
  //  | '\u2070'..'\u218F'
  //  | '\u2C00'..'\u2FEF'
  //  | '\u3001'..'\uD7FF'
  //  | '\uF900'..'\uFDCF'
  //  | '\uFDF0'..'\uFFFD'
  ;

fragment
PN_CHARS_U
  :
  PN_CHARS_BASE
  | '_'
  ;

fragment
VARNAME
  :
  (
    PN_CHARS_U
    | ('0'..'9')
  )
  (
    PN_CHARS_U
    | ('0'..'9')
  //    | '\u00B7'
  //    | '\u0300'..'\u036F'
  //    | '\u203F'..'\u2040'
  )*
  ;

fragment
PN_CHARS
  :
  PN_CHARS_U
  | MINUS
  | ('0'..'9')
  //  | '\u00B7'
  //  | '\u0300'..'\u036F'
  //  | '\u203F'..'\u2040'
  ;

fragment
PN_PREFIX
  :
  PN_CHARS_BASE
  (
    (
      PN_CHARS
      | DOT
    )*
    PN_CHARS
  )?
  ;

fragment
PN_LOCAL
  :
  (
    PN_CHARS_U
    | ('0'..'9')
  )
  (
    (
      PN_CHARS
      | DOT
    )*
    PN_CHARS
  )?
  ;

BLANK_NODE_LABEL
  :
  '_:' t=PN_LOCAL
  ;

REFERENCE
  :
  '^^'
  ;

AND
  :
  '&&'
  ;

PIPE
  :
  '|'
  ;

OR
  :
  '||'
  ;

COMMENT
  :
  '#' .* EOL 
            {
             $channel = HIDDEN;
            }
  ;

fragment
EOL
  :
  '\n'
  | '\r'
  ;

OPEN_CURLY_BRACE
  :
  '{'
  ;

CLOSE_CURLY_BRACE
  :
  '}'
  ;

SEMICOLON
  :
  ';'
  ;

DOT
  :
  '.'
  ;

PLUS
  :
  '+'
  ;

MINUS
  :
  '-'
  ;

ASTERISK
  :
  '*'
  ;

COMMA
  :
  ','
  ;

NOT_SIGN
  :
  '!'
  ;

DIVIDE
  :
  '/'
  ;

EQUAL
  :
  '='
  ;

LESS
  :
  '<'
  ;

GREATER
  :
  '>'
  ;

OPEN_BRACE
  :
  '('
  ;

CLOSE_BRACE
  :
  ')'
  ;

LESS_EQUAL
  :
  '<='
  ;

GREATER_EQUAL
  :
  '>='
  ;

NOT_EQUAL
  :
  '!='
  ;

OPEN_SQUARE_BRACE
  :
  '['
  ;

CLOSE_SQUARE_BRACE
  :
  ']'
  ;

HAT_LABEL
  :
  '^'
  ;

QUESTION_MARK_LABEL
  :
  '?'
  ;

fragment
UNICODE_CHAR
  :
  '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
  ;

fragment
HEX_DIGIT
  :
  '0'..'9'
  | 'a'..'f'
  | 'A'..'F'
  ;

UNDEF
  :
  'undef'
  ;

//BACKQUOTE
//  :
//  '`'
//  ;
//
//PLUSGREATER
//  :
//  '+>'
//  ;
//
//ASTERISKGREATER
//  :
//  '*>'
//  ;
