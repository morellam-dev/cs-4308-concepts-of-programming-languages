/* FILE: scan.l
 * AUTHOR: Mae Morella
 * ===================

 * This file is input for Lex/Flex, to generate a scanner program.
 * The set of matching rules is defined below, in no particular order.

 * TODO: Implement input switching, more robust string matcher.
 */
%option noyywrap
%option yylineno
%option caseless

%{
#include "stdio.h"
#include "y.tab.h"
#include "stdlib.h"
%}


/* DECLARATIONS */

DIGIT [0-9]
ALPHA [a-zA-Z]
IDENT [0-9a-zA-Z_]

%x BLOCK_COMMENT
%%

"//".*$                 { /* line comment. ignore. */ }
"/*"                    { BEGIN(BLOCK_COMMENT); }
"description"           { BEGIN (BLOCK_COMMENT); return DESCRIPTION; }
<BLOCK_COMMENT>"*/"     { BEGIN(INITIAL); }
<BLOCK_COMMENT>\n       { /* block comment. ignore. */ }
<BLOCK_COMMENT>.        { /* block comment. ignore. */ }


["<>\[\]\\/\(\)+\-=\.,] return (int)yytext[0];

add             return ADD;
address         return ADDRESS;
and             return AND;
alters          return ALTERS;
array           return ARRAY;
call            return CALL;
case            return CASE;
char            return CHAR;
constants       return CONSTANTS;
consumes        return CONSUMES;
count           return COUNT;
declarations    return DECLARATIONS;
decrement       return DECREMENT;
default         return DEFAULT;
define          return DEFINE;
definetype      return DEFINETYPE;
deref           return DEREF;
display         return DISPLAY;
displayn        return DISPLAYN;
do              return DO;
double          return DOUBLE;
downto          return DOWNTO;
else            return ELSE;
elseif          return ELSEIF;
endfor          return ENDFOR;
endfun          return ENDFUN;
endif           return ENDIF;
endrepeat       return ENDREPEAT;
endwhile        return ENDWHILE;
enum            return ENUM;
equal           return EQUAL;
float           return FLOAT;
for             return FOR;
forward         return FORWARD;
from            return FROM;
function        return FUNCTION;
global          return GLOBAL;
"greater than"  return GREATERT;
if              return IF;
implementations return IMPLEMENTATIONS;
import          return IMPORT;
incremenet      return INCREMENT;
input           return INPUT;
integer         return INTEGER;
interface       return INTERFACE;
is              return IS;
length          return LENGTH;
"less than"     return LESST;
long            return LONG;
break           return MBREAK;
close           return MCLOSE;
endcase         return MENDCASE;
exit            return MEXIT;
extern          return MEXTERN;
false           return MFALSE;
file            return MFILE;
open            return MOPEN;
true            return MTRUE;
void            return MVOID;
when            return MWHEN;
main            return MAIN;
negate          return NEGATE;
not             return NOT;
or              return OR;
of              return OF;
output          return OUTPUT;
parameters      return PARAMETERS;
begin           return PBEGIN;
persistent      return PERSISTENT;
pointer         return POINTER;
postcondition   return POSTCONDITION;
precondition    return PRECONDITION;
preserves       return PRESERVES;
produces        return PRODUCES;
read            return READ;
real            return REAL;
repeat          return REPEAT;
return          return RETURN;
set             return SET;
shared          return SHARED;
short           return SHORT;
specifications  return SPECIFICATIONS;
static          return STATIC;
struct          return STRUCT;
structures      return STRUCTURES;
structype       return STRUCTYPE;
subtract        return SUBTRACT;
symbol          return SYMBOL;
bool            return TBOOL;
byte            return TBYTE;
then            return THEN;
to              return TO;
string          return TSTRING;
unsigned        return TUNSIGNED;
type            return TYPE;
until           return UNTIL;
use             return USE;
using           return USING;
value           return VALUE;
variables       return VARIABLES;
while           return WHILE;
write           return WRITE;

({ALPHA}|_){IDENT}* {
        strcpy(yylval.string, yytext);
        return IDENTIFIER;
}

\"(\\.|[^"])*\" {
        strcpy(yylval.string, yytext);
        return STRING_LITERAL;
}

\'(\\.|[^'])\' {
        if (yytext[1] != '\\') {
        yylval.string[1] = 0;
                yylval.string[0] = yytext[1];
        } else {
                yylval.string[0] = yytext[2];
        }
        return LETTER_LITERAL;
}

{DIGIT}+ {
        yylval.number = (int)atoi(yytext);
        return UNSIGNED_INT_LITERAL;
}
[+-]{DIGIT}+ {
       yylval.number = (int)atoi(yytext);
       return SIGNED_INT_LITERAL;
}
[0-9A-F]+h {
        yylval.number = strtol(yytext, 0, 16);
       return HEX_INT_LITERAL;
}
[+-]?{DIGIT}+\.{DIGIT}+ {
        yylval.real = strtod(yytext, 0);
        return FLOAT_LITERAL;
}

(" "|\n|.) {}

%%

void yyerror(const char *msg) {
        fprintf(stderr, "line %d `%s`: %s\n", yylineno, yytext,  msg);
}