#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
RANDOM_NUMBER=$(shuf -i 1-1000 -n 1)
number_of_guesses=0
GUESS_THE_SECRET(){
  echo $1
  read GUESS
  if [[ ! $1 =~ ^[0-9]+$  ]]
  then
    GUESS_THE_SECRET "That is not an integer, guess again:"
  fi
  number_of_guesses+=1
  if [[ $GUESS < $RANDOM_NUMBER ]]
  then
    GUESS_THE_SECRET "It's lower than that, guess again:"
  fi
  if [[ $GUESS >  $RANDOM_NUMBER ]]
  then
    GUEST_THE_SECRET "It's higher than that, guess again:"
  fi
  if [[ $GUESS == $RANDOM_NUMBER ]]
  then
    echo "You guessed it in $number_of_guesses tries. The secret number was $RANDOM_NUMBER. Nice job!"
  fi
}




echo "Enter your username:"
echo $RANDOM_NUMBER
read USERNAME

USER_RESULT=$($PSQL "select * from users")
if [[ -z USER_RESULT ]]
then
  echo "Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses."
  GUESS_THE_SECRET "Guess the secret number between 1 and 1000:"
else
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

