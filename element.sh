#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]];
then
  # no search value entered
  echo -e "\nPlease provide an element as an argument."
  exit
fi


# input conditions: atomic number, symbol or name
# select from elements table
if [[ $1 =~ ^[0-9]+$   ]];
then
  SELECTED_ELEMENT=$($PSQL "SELECT (atomic_number, atomic_mass, symbol, name, type, melting_point_celsius, boiling_point_celsius) FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$1")
else
  SELECTED_ELEMENT=$($PSQL "SELECT (atomic_number, atomic_mass, symbol, name, type, melting_point_celsius, boiling_point_celsius) FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE symbol='$1' OR name='$1'")
fi

if [[ -z $SELECTED_ELEMENT ]];
then # if no matching element is found
  echo -e "\nI could not find that element in the database."
  exit
else # matching element was found
  echo Selected Element: $SELECTED_ELEMENT

  echo $SELECTED_ELEMENT | while IFS="," read ATOMIC_NUMBER ATOMIC_MASS SYMBOL NAME TYPE MELTINGPT BOILINGPT ;
  do
    echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MADD amu. $NAME has a melting point of $MELTINGPT celsius and a boiling point of $BOILINGPT celsius."
  done
fi
