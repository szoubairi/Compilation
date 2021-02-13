Spécification des types d'attributs et description des champs d'attributs utilisés:
  Spécification enum type:

  INT   définit les entiers
  FLOAT définit les flottants
  VD    définit le type void
  FUNC  définit le type fonction


  Spécification struct ATTRIBUTE:

  1- char *name; 
  -> Permet de stocker la valeur lexicale d'un terminal dans l'attribut.

  2- int int_val;
  -> Permet de stocker la valeur entière (après conversion de la valeur lexicale en un attribut entier)

  3- float float_val;
  -> Permet de stocker la valeur flottante (après conversion de la valeur lexicale en un attribut de type float)

  4- type type_val;
  -> Permet de stocker le type de la variabe de l'attribut:
            - FONC: pour le type associé aux fonctions.
            - INT : pour le type associé aux entiers.
            - FLOAT : pour le type associé aux entiers.      
            
  5- int reg_number;
  -> Permet de stocker le numéro de registre associé à un attribut.

  6- int num_block;
  -> Permet d'identifier le numéro de block auquel appartient l'attribut.

  7- int num_ref;
  -> Décompte le nombre de pointeurs vers le type. 
         Par exemple:
         - pour "int p"   num_ref=0
         - pour "int *p"  num_ref=1
         - pour "int **p" num_ref=2

  8- int num_label;
  -> Permet d'étiqueter le code afin d'effectuer des branchements.

  9- type type_return;
  -> Permet d'identifier le type de retour d'une fonction.
          Par exemple:
          - VD pour les fonctions de type de retour VOID.
          