// FILE: main.c
// AUTHOR: Mae Morella
// ===================
//
// This file implements a simple program which takes an input file, and
// repeatedly calls the yylex function generated by scan.l, and prints the list
// of tokens it detects.

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "scan.yy.h"  // generated from scan.l by Lex/Flex
#include "y.tab.h"    // generated from parse.y by Yacc/Bison

FILE* OUTFILE;

int yyparse(void);

int sclarse_main() {
  yyparse();
  return EXIT_SUCCESS;
}

int main(int argc, char* argv[]) {
  // Check that the program has exactly one argument:
  if (argc != 2) {
    fprintf(stderr, "Usage: %s [file_name]\n", argv[0]);
    return EXIT_FAILURE;
  }
  OUTFILE = stdout;
  // Open input file from args
  if (strcmp(argv[1], "-") == 0) {
    yyin = stdin;
  } else {
    yyin = fopen(argv[1], "r");
  }
  if (!yyin) {
    fprintf(stderr, "Error: could not read from %s\n", argv[1]);
    exit(1);
  }
  //
  sclarse_main();
  fclose(yyin);
}