#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

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
echo $($PSQL "$query")
# END insert items - create and execute query

# Get all temas with ids
resultAllTeams=$($PSQL "SELECT * from teams")
declare -A TEAMS_ARRAY=()
while IFS='|' read -r column1 column2; do
  TEAMS_ARRAY["$column2"]="$column1"
done <<< "$resultAllTeams"
# END Get all temas with ids

# insert gameg
declare insertQuery="insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values"
j=0
while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    WINNER_ID=${TEAMS_ARRAY[$WINNER]}
    OPPONENT_ID=${TEAMS_ARRAY[$OPPONENT]}
    if [[ $j == 0 ]]
    then
     insertQuery+="($YEAR, '$ROUND',  $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
    else
      insertQuery+=", ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
    fi
    j=$((j+1))
  fi  
done < games.csv
echo $($PSQL "$insertQuery")
# END insert games
