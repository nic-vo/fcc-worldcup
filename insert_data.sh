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
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  # if no winner_id
  if [[ -z $WINNER_ID ]]
  then
    # insert winner into teams 
    echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');"): $WINNER"
  fi
  # query winner_id
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  
  # query if winner_id in teams
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  # if no OPPONENT_id
  if [[ -z $OPPONENT_ID ]]
  then
    # insert OPPONENT into teams 
    echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');"): $OPPONENT"
  fi
  # query OPPONENT_id
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WIN_GOALS, $OP_GOALS)"): $YEAR, $ROUND, $WINNER_ID vs $OPPONENT_ID -- $WIN_GOALS : $OP_GOALS"
  
done

echo "$($PSQL "SELECT COUNT(*) FROM teams;")"