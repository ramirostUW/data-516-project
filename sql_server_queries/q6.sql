Select Team_Name, floor(GAME_DATE/10000) as gameYear, 
(100.0 * sum(SHOT_MADE_FLAG))/sum(SHOT_ATTEMPTED_FLAG) as goal_percent
FROM shotdata
where SHOT_TYPE = '2PT Field Goal' OR SHOT_TYPE = '3PT Field Goal'
group BY TEAM_NAME, floor(GAME_DATE/10000)
ORDER BY goal_percent DESC

--runtime: 00:00:23.522