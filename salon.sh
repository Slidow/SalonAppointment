#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "1) Cut\n2) Color\n3) Perm"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT 1 ;;
    2) APPOINTMENT 2 ;;
    3) APPOINTMENT 3 ;;
    *) MAIN_MENU 'I could not find that service. What would you like today?' ;;
  esac
}

APPOINTMENT() {
  # get customer phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # check if phone number exist
  PHONE_EXIST_RESULT=$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if number don't exist
  if [[ -z $PHONE_EXIST_RESULT ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # enter the customer
    ENTER_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi
  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # ask for time
  echo -e "\nWhat time would you like your cut, Fabio?"
  read SERVICE_TIME

  # enter the appointment
  ENTER_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', $1, '$SERVICE_TIME')")

  # find services
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $1")

  # final message
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
