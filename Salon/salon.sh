#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"

SELECT_SERVICE(){
  echo -e "\n$1"
  SERVICES_LIST=$($PSQL "select service_id, name from services")
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$  ]]
  then
    SELECT_SERVICE "I could not find that service. What would you like today?"
  else
    SERVICE=$($PSQL "select * from services where service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVICE ]]
    then
      SELECT_SERVICE "I could not find that service. What would you like today?"
    else
      ENTER_CUSTOMER_DATA
    fi
  fi
}
ENTER_CUSTOMER_DATA(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    insert_customer_result=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'");
  echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
  read SERVICE_TIME
  insert_appointment_result=$($PSQL "insert into appointments(customer_id, service_id, time) values('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  
  if [[ -z insert_appointment_result ]]
  then
    SELECT_SERVICE
  else
    SERVICE_NAME=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  fi
  exit
}

SELECT_SERVICE
