

/* Keywords */
%token ADD ALTERS ARRAY CALL CASE CHAR CONSTANTS CONSUMES COUNT DECLARATIONS DECREMENT DEFAULT DEFINE DEFINETYPE DESCRIPTION DISPLAY DISPLAYN DO DOUBLE DOWNTO ELSE ELSEIF ENDFOR ENDFUN ENDIF ENDREPEAT ENDWHILE ENUM FLOAT FOR FORWARD FROM FUNCTION GLOBAL IF IMPLEMENTATIONS IMPORT INCREMENT INPUT INTEGER INTERFACE IS LENGTH LONG MAIN MBREAK MCLOSE MENDCASE MEXIT MEXTERN MFALSE MFILE MOPEN MTRUE MVOID MWHEN OF OUTPUT PARAMETERS PBEGIN PERSISTENT POINTER POSTCONDITION PRECONDITION PRESERVES PRODUCES READ REAL REPEAT RETURN SET SHARED SHORT SPECIFICATIONS STATIC STRUCT STRUCTURES STRUCTYPE SUBTRACT SYMBOL TBOOL TBYTE THEN TO TSTRING TUNSIGNED TYPE UNTIL USE USING VALUE VARIABLES WHILE WRITE

%token-table

// Token value object
%union {
  int number;
  double real;
  char string[256];
}

/* Constants and identifiers */
%token <string> STRING_LITERAL
%token <number> UNSIGNED_INT_LITERAL SIGNED_INT_LITERAL HEX_INT_LITERAL
%token <real> FLOAT_LITERAL
%token <string> IDENTIFIER LETTER

%%

/* Operators */

%token <string> IDENTIFIER LETTER

%token-table

%start start

%%

start : imports symbols forward_refs specifications globals implement
      ;
imports :
        | imports import_file
        ;
import_file : IMPORT header_file_name
            | USE header_file_name
            ;
header_file_name : '<' fname '>'
                 | STRING
                 ;
fname : IDENTIFIER
      | fname shlash IDENTIFIER
      ;
shlash : '/'
       | '\\'
       ;
symbols :
        | symbols symbol_def
        ;
symbol_def : SYMBOL IDENTIFIER symbol_value
           ;

symbol_value : IDENTIFIER
             | STRING
             | UNSIGNICON
             | SIGNICON
             | HCON
             | FCON
             ;
forward_refs :
             | FORWARD forward_list
             ;
forward_list : forwards
             | forward_list forwards
             ;
forwards : INTERFACE IDENTIFIER
         | STRUCT IDENTIFIER
         | STRUCTYPE IDENTIFIER
         | check_ext func_main parameters
         | DEFINETYPE struct_enum IDENTIFIER IDENTIFIER
         ;
check_ext :
          | MEXTERN
          ;
func_main : FUNCTION IDENTIFIER oper_type
          | MAIN
          ;
oper_type : RETURN chk_ptr chk_array ret_type
          ;
chk_ptr :
        | POINTER OF
        ;
chk_array :
          | ARRAY array_dim_list
          ;
array_dim_list : '[' array_index ']'
               | array_dim_list '[' array_index ']'
               ;
array_index : IDENTIFIER
            | UNSIGNICON
            ;

ret_type  : TYPE type_name
          | STRUCT IDENTIFIER
          | STRUCTYPE IDENTIFIER
          ;
type_name : MVOID
          | COUNT
          | INTEGER
          | SHORT
          | REAL
          | FLOAT
          | DOUBLE
          | TBOOL
          | CHAR
          | TSTRING OF LENGTH SIGNICON
          | TBYTE
          ;
struct_enum : STRUCT
            | ENUM
            ;
specifications  :
                | SPECIFICATIONS spec_list
                ;
spec_list : spec_def
          | spec_list spec_def
          ;
spec_def : ENUM
         | STRUCT
         | DESCRIPTION
         ;
globals :
        | GLOBAL DECLARATIONS const_dec var_dec struct_dec
        ;
const_var_struct : const_dec var_dec struct_dec
                 ;
const_dec :
          | CONSTANTS data_declarations
          ;
var_dec : VARIABLES data_declarations
        ;
struct_dec :
           | STRUCTURES data_declarations
           ;
data_declarations : comp_declare
                  | data_declarations comp_declare
                  ;
comp_declare : DEFINE data_file
             ;
data_file : sel_file
          | sel_dmode data_declaration
          ;
sel_dmode :
          | PERSISTENT
          | SHARED
          | STATIC
          | MEXTERN
          ;
sel_file :
         | MFILE
         ;
data_declaration : IDENTIFIER opt_pointer parray_dec OF data_type
                 ;
opt_pointer :
            | POINTER
            ;
data_type : TUNSIGNED
          | CHAR
          | INTEGER
          | MVOID
          | DOUBLE
          | LONG
          | SHORT
          | FLOAT
          | REAL
          | TSTRING
          | TBOOL
          | TBYTE
          ;
parray_dec :
          | ARRAY plist_const popt_array_val
          | '['
          | VALUE
          | '='
          ;
plist_const : '[' iconst_ident ']'
            | plist_const '[' iconst_ident ']'
            ;
iconst_ident : SIGNICON
             | UNSIGNICON
             | IDENTIFIER
             ;
popt_array_val :
               | value_eq array_val
               ;
value_eq : VALUE
         | '='
         ;

array_val : simp_arr_val
          ;
simp_arr_val : '[' arg_list ']'
             ;
arg_list : expr
         | arg_list ',' expr
         ;


implement : IMPLEMENTATIONS main_head funct_list
          ;
main_head :
          |  MAIN DESCRIPTION parameters
          ;
funct_list : funct_body
           | funct_list funct_body
           ;
funct_body: FUNCTION phead_fun pother_oper_def
          ;
phead_fun :
          | PERSISTENT
              | STATIC
              ;
pother_oper_def : pother_oper IS const_var_struct precond
                      PBEGIN pactions  ENDFUN  IDENTIFIER
                ;

pother_oper : IDENTIFIER DESCRIPTION oper_type parameters
            ;

precond :
        | PRECONDITION pcondition
        ;
pcondition : pcond1 '|' '|' pcond1
           | pcond1 '&' '&' pcond1
           | pcond1
           ;
pcond1 : '!' pcond2
       | pcond2
       ;
pcond2 : '(' pcondition ')'
       | expr '!' '=' expr
       | expr '=' '=' expr
       | expr '<' expr
       | expr '>' expr
       | expr '>' '=' expr
       | expr '<' '=' expr
       | element
       ;
true_false : MTRUE
           | MFALSE
           ;

parameters :
           | PARAMETERS  param_list
           ;

param_list : param_def
           | param_list ',' param_def
           ;
param_def : param_mode data_declaration
          ;
param_mode :
           | ALTERS
           | PRESERVES
           | PRODUCES
           | CONSUMES
           ;
expr : term '+' term
     | term '-' term
         | term '&' term
         | term '|' term
         | term '^' term
         ;
term : punary
     | punary '*' punary
     | punary '/' punary
     | punary '%' punary
         | punary '<' '<' punary
         | punary '>' '>' punary
         ;
punary : element
       | '&' element
       | '*' element
       | '-' element
       ;
element : IDENTIFIER popt_ref
            | STRING
            | LETTER
            | SIGNICON
            | UNSIGNICON
            | HCON
            | FCON
            | true_false
            | '(' expr ')'
            ;
pactions : action_def
         | pactions action_def
         ;
action_def : ADD name_ref TO name_ref
           | SUBTRACT name_ref FROM name_ref
           | SET name_ref '=' expr
           | READ pvar_value_list
           | INPUT name_ref
           | DISPLAY pvar_value_list
           | DISPLAYN pvar_value_list
           | MCLOSE IDENTIFIER
           | MOPEN in_out
           | MFILE read_write
                   | INCREMENT name_ref
                   | DECREMENT name_ref
                   | RETURN expr
                   | CALL name_ref pusing_ref
                   | IF pcondition THEN pactions ptest_elsif
                          opt_else ENDIF
                   | FOR name_ref '=' expr downto expr
                          DO pactions ENDFOR
                   | REPEAT pactions UNTIL pcondition ENDREPEAT
                   | WHILE pcondition DO pactions ENDWHILE
                   | CASE name_ref pcase_val pcase_def MENDCASE
                   | MBREAK
                   | MEXIT
                   | ENDFUN name_ref
                   | POSTCONDITION pcondition
                   ;

ptest_elsif :
            | proc_elseif
                        ;
proc_elseif : ELSEIF pcondition THEN pactions
            | proc_elseif ELSEIF pcondition THEN pactions
            ;
downto : TO
       | DOWNTO
       ;
pusing_ref :
           | USING arg_list
           | parguments
                   ;
parguments : '(' arg_list ')'
           ;

pcase_val : MWHEN expr ':' pactions
          | pcase_val MWHEN expr ':' pactions
          ;
pcase_def :
          | DEFAULT ':' pactions
          ;
pvar_value_list : expr
                | pvar_value_list ',' expr
                ;
opt_else :
         | ELSE pactions
         ;


in_out : INPUT MFILE IDENTIFIER
       | OUTPUT MFILE IDENTIFIER
           ;
read_write : READ pvar_value_list FROM IDENTIFIER
           | WRITE pvar_value_list TO IDENTIFIER
                   ;
name_ref : IDENTIFIER opt_ref pmember_opt  popt_dot
         ;
pmember_opt :
            | pmember_of
            ;
pmember_of : OF IDENTIFIER opt_ref
                   | pmember_of OF IDENTIFIER opt_ref
           ;

opt_ref : array_val
        ;
popt_ref :
         | array_val
         | parguments
         ;
popt_dot :
         | proc_dot
         ;
proc_dot : '.' IDENTIFIER opt_ref
         | proc_dot '.' IDENTIFIER opt_ref
         ;

%%

