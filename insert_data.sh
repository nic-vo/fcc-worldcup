#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE teams,games")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OP_GOALS
do
  # guard clause to skip first line
  if [[ $YEAR == 'year' ]]
  then
    continue
  fi
  # query if winner_id in teams
  WINNER_ID="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
  # if no winner_id
  if [[ -z $WINNER_ID ]]
  then
    echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');"): $WINNER"
  fi
  # insert winner into teams 

  # query winner_id
  
done