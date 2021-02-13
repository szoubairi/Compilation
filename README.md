# Compilation project : Myc

# Equipe : Saad Zoubairi , Imad Boudroua

## Table of Contents
1. [Présentation du projet](#Description)
3. [Structure du dépot](#Structure)
4. [Compilation et execution](#Compilation-execution)
5. [Travail demandé](#Travail-demandé)
6. [Avancement final](#Avancement-final)

## Desciption:
***
      Le projet de compilation a pour objet la réalisation d'un compilateur d'un mini langage appelé pour l'occasion myC vers du code C à 3 adresses.

## #Structure:
***    
    * src/ : Lcontient les sources du projet.
        ** lang.l
        ** lang.y 
        ** Attribute.c 
        ** Attribute.h
        ** Table_des_symboles.c, Table_des_symboles.h, Table_des_chaines.c et Table_des_chaines.h
    * tst/ : contient les tests
    * Makefile : génération du compilateur
    * README.md : Description du projet

## Compilation-execution:
***
    * make : compile lang
    * make clean : nettoyage du dépot
    * Pour compiler le fichier myc et executer le fichier .c résultant choisir entre:
        * la commande TST="NOM_DU_FICHIER_TEST.myc" make compile à executer dans la racine du projet.
        * cd src && make && ./lang test.h test.c < ..tst/FICHIER_TEST.c && gcc test.c && ./a.out

## Travail-demandé:
***
    1. un mécanisme de déclarations explicite de variables,
    2. des expresssion arithmétiques arbitraire de type calculatrice,
    3. des lectures ou écritures mémoires via des affectations avec variables utilisateurs ou pointeurs,
    4. des structures de contrôles classiques (conditionelles et boucles),
    5. un mécanisme de typage simple comprenant notamment des entiers int et des pointeurs int *,
    6. définitions et appels de fonctions récursives,

## Avancement-final:
***
    1. un mécanisme de déclarations explicite de variables,
    2. des expresssion arithmétiques arbitraire de type calculatrice,
    3. des lectures ou écritures mémoires via des affectations avec variables utilisateurs ou pointeurs,
    4. des structures de contrôles classiques (conditionelles et boucles),
    5. un mécanisme de typage simple comprenant notamment des entiers int et des pointeurs int *,
    6. définitions et appels de fonctions.


