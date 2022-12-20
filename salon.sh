#!/bin/bash

#Global variable
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

#Services list
SERVICES() {
echo "1) cut"
echo "2) wash"
echo "3) styling"
}

  while [ true ]
  do
  SERVICES

  #Read user input
  echo "Input service id: "
  read SERVICE_ID_SELECTED

  #If user input is valid, display appropriate string, otherwise display list of services
  case $SERVICE_ID_SELECTED in
  1|2|3)    
    echo "Enter phone numer: "
    read CUSTOMER_PHONE
    CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")"
    
    #If customer doesn't exist
    if [ -z $CUSTOMER_ID ]
    then
      #Enter new customer name
      echo "Enter your name: "
      read CUSTOMER_NAME

      #Add new customer data into database
      INSERT_CUSTOMER_DATA=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME') ON CONFLICT DO NOTHING")
      
      #Assign customer id to variable after adding data
      CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")"
    fi
    
      echo "Enter time: "
      read SERVICE_TIME

      INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,  $SERVICE_ID_SELECTED,  '$SERVICE_TIME')")

      DATABASE_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      DATABASE_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      echo "I have put you down for a $DATABASE_SERVICE_NAME at $SERVICE_TIME, $DATABASE_CUSTOMER_NAME."
      break;;

  *) SERVICES;;
  esac
done



