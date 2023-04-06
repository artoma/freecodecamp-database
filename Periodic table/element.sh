#!/bin/bash
#PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
if [[ ! $1 =~ ^[0-9]+$  ]]
then
  atomic_number=null
else
  atomic_number=$1  
fi
RESULT=$($PSQL "select * from elements full join properties using(atomic_number) full join types using(type_id) where atomic_number = $atomic_number  or name = '$1' or symbol = '$1'")
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$RESULT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
fi
exit