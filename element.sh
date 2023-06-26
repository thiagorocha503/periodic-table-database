#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi
# if symbol or name
if [[  $1 =~ [a-zA-Z]+ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, type, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1' OR symbol='$1' ")
fi
# if atomic number
if [[ $1 =~ [0-9]+ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, type, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$1' ")
fi
# if not found
if [[  -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

echo $ELEMENT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR TYPE BAR MELTING_POINT BAR BOILING_POINT BAR
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done