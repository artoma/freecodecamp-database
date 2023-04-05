#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


MAIN_MENU(){
  SERVICES_LIST=$($PSQL "select service_id, name from services")
  echo -e "\nSelect your service:"
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done
  read SELECTED_SERVICE_ID
}
MAIN_MENU
if [[ -z $SELECTED_SERVICE_ID ]]
then
  MAIN_MENU
fi
echo $SELECTED_SERVICE_ID