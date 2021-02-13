

#include "Attribute.h"
#include <stdio.h>
#include <stdlib.h>

extern FILE *testc, *testh;

char *types[6] = {"INT", "FLOAT", "BOOL", "VOID", "If", "LOOP"};

attribute new_attribute()
{
  attribute r;
  r = malloc(sizeof(struct ATTRIBUTE));
  return r;
};

//Reg

int inc_reg = 0;

int newReg()
{
  return ++inc_reg;
}

//label

int inc_label = 1;
int new_label()
{
  return inc_label++;
}

//block

int current_block = 0;

void new_block()
{
  current_block++;
}

void end_block()
{
  current_block--;
}

int curr_block()
{
  return current_block;
}
//type

void test_type(attribute x, attribute y)
{
  if (x->type_val != y->type_val)
  {
    fprintf(stderr, "Error : assigment impossible '%s' value to a '%s'\n",
            types[y->type_val], types[x->type_val]);
    exit(-1);
  }
}