#ifndef ATTRIBUTE_H
#define ATTRIBUTE_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
typedef enum
{
  INT,   // pour les entiers
  FLOAT, // pour les flottants
  VD,    // pour le type void
  FUNC   // pour les fonctions

} type;

struct ATTRIBUTE
{
  char *name;      //la valeur lexicale d'un terminal dans l'attribut.
  int int_val;     //la valeur entière d'une constante
  float float_val; //la valeur flottante d'une constante
  type type_val;   // le type de la variable de l'attribut
  int reg_number;  // numéro de registre

  /* other attribute's fields can goes here */
  int num_block;    // numéro de block
  int num_ref;      // nombre de "*"
  int num_label;    // numéro de l'étiquette
  type type_return; // type de retour d'une fonction
};

typedef struct ATTRIBUTE *attribute;

attribute new_attribute();

int new_label();

void new_block();

void end_block();

int curr_block();

void test_type(attribute x, attribute y);

int newReg();

#endif
