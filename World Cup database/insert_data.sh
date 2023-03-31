#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#echo $($PSQL "TRUNCATE TABLE games, teams")

declare -A UNIQUE_TEAMS
while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    [[ -v UNIQUE_TEAMS["$WINNER"] ]] &&  echo -e "." || UNIQUE_TEAMS["$WINNER"]="$WINNER"
    [[ -v UNIQUE_TEAMS["$OPPONENT"] ]] &&  echo -e "." || UNIQUE_TEAMS["$OPPONENT"]="$OPPONENT"
  fi  
done < games.csv

# insert teams - create and execute query 
keys=( "${!UNIQUE_TEAMS[@]}" )
first_key="${keys[0]}"
query="insert into teams(name) values('${UNIQUE_TEAMS[$first_key]}')"

for i in "${!UNIQUE_TEAMS[@]}"
do
  if [[ $first_key != $i ]]
  then
  query+=", ('${UNIQUE_TEAMS[$i]}')"
  fi
done
#echo $($PSQL "$query")
# END insert items - create and execute query
echo $($PSQL "select * from teams")

mapfile result < <($PSQL "SELECT * from teams;")
for row in "${result[@]}";do
    echo team_id:  ${row%$'\t'*}  team_name: ${row#*$'\t'}
done
