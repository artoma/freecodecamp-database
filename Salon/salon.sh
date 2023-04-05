#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SELECT_SERVICE(){
  echo -e "\n$1"
  SERVICES_LIST=$($PSQL "select service_id, name from services")
  echo -e "\nSelect your service:"
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done
  read SELECTED_SERVICE_ID

  if [[ ! $SELECTED_SERVICE_ID =~ ^[0-9]+$  ]]
  then
    SELECT_SERVICE "erro1"
  else
    SERVICE=$($PSQL "select * from services where service_id=$SELECTED_SERVICE_ID")
    if [[ -z $SERVICE ]]
    then
      SELECT_SERVICE "error 2"
    fi
  fi
  echo $SELECTED_SERVICE_ID
}
SELECT_SERVICE
