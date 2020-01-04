/** Taken from "The Definitive ANTLR 4 Reference" by Terence Parr */

// Derived from http://json.org
grammar JSON;

json
   : value
   ;

obj
   : '{' pair (',' pair)* '}'
   | '{' '}'
   ;

pair
   : STRING ':' value    # jsonPair
   | TEMPLKEYWRD ':' obj # templateData
   ;

array
   : '[' value (',' value)* ']'
   | '[' ']'
   ;

value
   : STRING # valueString
   | NUMBER # valueNumber
   | obj    # valueObject
   | array  # valueArray
   | 'true' # valueTrue
   | 'false' # valueFalse
   | 'null'  # valueNull
   ;

TEMPLKEYWRD
   : '"' '$data' '"'
   ;

STRING
   : '"' (ESC | SAFECODEPOINT)* '"'
   ;


fragment ESC
   : '\\' (["\\/bfnrt] | UNICODE)
   ;
fragment UNICODE
   : 'u' HEX HEX HEX HEX
   ;
fragment HEX
   : [0-9a-fA-F]
   ;
fragment SAFECODEPOINT
   : ~ ["\\\u0000-\u001F]
   ;


NUMBER
   : '-'? INT ('.' [0-9] +)? EXP?
   ;


fragment INT
   : '0' | [1-9] [0-9]*
   ;

// no leading zeros

fragment EXP
   : [Ee] [+\-]? INT
   ;

// \- since - means "range" inside [...]

WS
   : [ \t\n\r] + -> skip
   ;