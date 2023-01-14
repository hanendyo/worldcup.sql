#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

#TEAMS QUERY
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 if [[ $YEAR != "year" ]]
 then 
  #get teams_id
  GAME_ID=$($PSQL "SELECT teams.teams_id FROM teams WHERE year='$YEAR'")

    # in teams_id not found
    if [[ -z $GAME_ID ]]
    then
     #set team_id to NULL
     GAME_ID=null
    fi

    # insert team
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi
done

#GAME QUERY
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR")
  
    # if game_id not found
    if [[ -z $GAME_ID ]]
    then
      # set game_id to null
      GAME_ID=null
    fi

    # insert game detail
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "Game detail inserted"
    fi
  fi
done
