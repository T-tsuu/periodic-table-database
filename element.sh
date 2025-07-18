#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT=0
  
  while IFS='|' read ANUM SMBL NAME
  do
    if [[ $1 == $ANUM || $1 == $SMBL || $1 == $NAME ]]
    then
      ELEMENT=$ANUM
    fi
  done < <($PSQL "SELECT * FROM elements;")

  if [[ $ELEMENT != 0 ]]
  then
    $PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$ELEMENT;" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL ELEMENT_NAME ATOMIC_MASS MPC BPC TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi