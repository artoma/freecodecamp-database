#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
USERNAME=''
RANDOM_NUMBER=$(shuf -i 1-1000 -n 1)
number_of_guesses=0
GUESS_THE_SECRET(){
  echo $1
  read GUESS
  #echo "RANDOM_NUMBER: $RANDOM_NUMBER"
  re='^[0-9]+$'
  if [[ ! $GUESS =~ $re ]]
  then
    GUESS_THE_SECRET "That is not an integer, guess again:"
  fi
 ((number_of_guesses++))
  if [[ $GUESS -gt $RANDOM_NUMBER ]]
  then
    GUESS_THE_SECRET "It's lower than that, guess again:" 
  fi
  if [[ $GUESS -lt  $RANDOM_NUMBER ]]
  then
    GUESS_THE_SECRET "It's higher than that, guess again:"
  fi
  if [[ $GUESS -eq $RANDOM_NUMBER ]]
  then
   
    NEW_GAMES_PLAYED=$(echo $GAMES_PLAYED | sed -r 's/^ *| *$//g')
    ((NEW_GAMES_PLAYED++))
    
    INSERT_GAME_RESULT=$($PSQL "insert into games(user_id, result) values($USER_ID, $number_of_guesses)")
    THE_BEST_GAME=$($PSQL "select min(result) from games where user_id=$USER_ID")
    UPDATE_USER_RESULT=$($PSQL "update users set best_game=$(echo $THE_BEST_GAME | sed -r 's/^ *| *$//g'), games_played=$NEW_GAMES_PLAYED where user_id=$USER_ID")
    echo "You guessed it in $number_of_guesses tries. The secret number was $RANDOM_NUMBER. Nice job!"
    exit
  fi
}

PRE_GAME(){
  USER_RESULT=$($PSQL "select * from users where username='$USERNAME'")
  if [[ -z $USER_RESULT ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USERNAME_RESULT=$($PSQL "insert into users(username, games_played, best_game) values('$USERNAME', 0, 0)")
    USER_RESULT=$($PSQL "select * from users where username='$USERNAME'")
    IFS="|" read USER_ID USERNAME GAMES_PLAYED BEST_GAME <<< $USER_RESULT
    GUESS_THE_SECRET "Guess the secret number between 1 and 1000:" 
  else
    IFS="|" read USER_ID USERNAME BEST_GAME GAMES_PLAYED  <<< $USER_RESULT
    echo "Welcome back, $(echo $USERNAME | sed -r 's/^ *| *$//g')! You have played $(echo $GAMES_PLAYED | sed -r 's/^ *| *$//g') games, and your best game took $(echo $BEST_GAME | sed -r 's/^ *| *$//g') guesses."
    GUESS_THE_SECRET "Guess the secret number between 1 and 1000:" 
  fi
}

START_GAME(){
  echo "Enter your username:"
  read USERNAME
}

START_GAME
PRE_GAME




