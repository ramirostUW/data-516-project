SELECT PlayerAttempts.PLAYER_NAME,
       PlayerAttempts.MOST_ATTEMPTED_REGION,
       PlayerFGPct.MOST_MADE_REGION
FROM (SELECT PlayerRegions2.PLAYER_NAME,
      CONCAT(PlayerRegions2.SHOT_ZONE_AREA, ', ', PlayerRegions2.SHOT_ZONE_BASIC) AS MOST_ATTEMPTED_REGION,
      PlayerRegions2.NUM_ATTEMPTS
      FROM (SELECT PlayerRegions.PLAYER_NAME,
            MAX(PlayerRegions.NUM_ATTEMPTS) AS MAX_ATTEMPTS
            FROM (SELECT PLAYER_NAME,
                         SHOT_ZONE_BASIC,
                         SHOT_ZONE_AREA,
                         COUNT(*) AS NUM_ATTEMPTS
                  FROM shotdata
                  GROUP BY PLAYER_NAME, SHOT_ZONE_BASIC, SHOT_ZONE_AREA
                  HAVING COUNT(*) > 30) AS PlayerRegions
            GROUP BY PlayerRegions.PLAYER_NAME) AS MaxAttempts INNER JOIN
           (SELECT PLAYER_NAME,
                   SHOT_ZONE_BASIC,
                   SHOT_ZONE_AREA,
                   COUNT(*) AS NUM_ATTEMPTS
            FROM shotdata
            GROUP BY PLAYER_NAME, SHOT_ZONE_BASIC, SHOT_ZONE_AREA
            HAVING COUNT(*) > 30) AS PlayerRegions2 ON
            MaxAttempts.PLAYER_NAME = PlayerRegions2.PLAYER_NAME AND MaxAttempts.MAX_ATTEMPTS = PlayerRegions2.NUM_ATTEMPTS) AS PlayerAttempts INNER JOIN
     (SELECT PlayerRegions2.PLAYER_NAME,
             CONCAT(PlayerRegions2.SHOT_ZONE_AREA, ', ', PlayerRegions2.SHOT_ZONE_BASIC) AS MOST_MADE_REGION,
             PlayerRegions2.FG_PCT
             FROM (SELECT PlayerRegions.PLAYER_NAME, MAX(PlayerRegions.FG_PCT) AS MAX_FG_PCT 
                   FROM (SELECT PLAYER_NAME,
                                SHOT_ZONE_BASIC,
                                SHOT_ZONE_AREA,
                                ROUND(SUM(SHOT_MADE_FLAG)*100/COUNT(*), 2) AS FG_PCT
                         FROM shotdata
                         GROUP BY PLAYER_NAME, SHOT_ZONE_BASIC, SHOT_ZONE_AREA
                         HAVING COUNT(*) > 30) AS PlayerRegions
                   GROUP BY PlayerRegions.PLAYER_NAME) AS MaxFGPct INNER JOIN
                  (SELECT PLAYER_NAME,
                          SHOT_ZONE_BASIC,
                          SHOT_ZONE_AREA,
                          ROUND(SUM(SHOT_MADE_FLAG)*100/COUNT(*), 2) AS FG_PCT
                   FROM shotdata
                   GROUP BY PLAYER_NAME, SHOT_ZONE_BASIC, SHOT_ZONE_AREA
                   HAVING COUNT(*) > 30) AS PlayerRegions2 ON
                   MaxFGPct.PLAYER_NAME = PlayerRegions2.PLAYER_NAME AND MaxFGPct.MAX_FG_PCT = PlayerRegions2.FG_PCT) AS PlayerFGPct ON
     PlayerAttempts.PLAYER_NAME = PlayerFGPct.PLAYER_NAME
order by PlayerAttempts.PLAYER_NAME