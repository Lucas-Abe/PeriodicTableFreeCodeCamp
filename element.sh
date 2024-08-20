#! /bin/bash

PSQL=" psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c "

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi


if [[ $1 =~ ^[1-9]+$ ]]
then
  element=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties using(atomic_number) JOIN types using(type_id) WHERE atomic_number = '$1'")
else
  element=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties using(atomic_number) JOIN types using(type_id) WHERE name = '$1' or symbol = '$1'")
fi

if [[ -z $element ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

echo $element | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
do
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done