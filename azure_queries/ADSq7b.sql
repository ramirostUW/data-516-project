SELECT MAX(PLAYER_NAME) AS PLAYER_NAME,
       ROUND(AVG(1.0*NUM_POINTS), 2) AS AVG_PTS_PER_ATT 
FROM
(SELECT PLAYER_ID, PLAYER_NAME,
        CASE WHEN SHOT_TYPE = '2PT Field Goal' AND SHOT_MADE_FLAG = 1
             THEN 2
             WHEN SHOT_TYPE = '3PT Field Goal' AND SHOT_MADE_FLAG = 1
             THEN 3
             ELSE 0
             END AS NUM_POINTS
FROM shotdata
WHERE PERIOD = 4 AND 60*MINUTES_REMAINING + SECONDS_REMAINING <= 300) AS PlayerPoints
GROUP BY PLAYER_ID
HAVING COUNT(*) >= 200
ORDER BY AVG_PTS_PER_ATT DESC

--Runtime: 00:00:21.338