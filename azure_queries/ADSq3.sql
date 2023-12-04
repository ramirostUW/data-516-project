SELECT *
FROM (SELECT ShotDist.PLAYER_NAME,
			 ShotDist.ACTION_TYPE,
			 ROUND(CAST(ShotDist.NUM_SHOTS AS FLOAT)*100/TotalShots.TOTAL_SHOTS, 4) AS PERCENT_OF_SHOTS
	  FROM (SELECT PLAYER_NAME,
				   COUNT(*) AS TOTAL_SHOTS
			FROM shotdata
			GROUP BY PLAYER_NAME) AS TotalShots INNER JOIN
		   (SELECT shotdata1.PLAYER_NAME,
                       shotdata1.ACTION_TYPE,
			     COUNT(*) AS NUM_SHOTS
			FROM (SELECT PLAYER_NAME
				  FROM shotdata
				  WHERE SHOT_TYPE = '3PT Field Goal'
				  GROUP BY PLAYER_NAME
                          HAVING COUNT(*) >= 5544) AS threeptPlayers INNER JOIN
			     (SELECT shotData.PLAYER_NAME, CASE WHEN shotData.ACTION_TYPE LIKE '%BANK Shot%'
                                                          THEN 'BANK SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%DUNK SHOT%'
                                                          THEN 'DUNK SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%FADEAWAY SHOT%'
                                                          THEN 'FADEAWAY SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%HOOK SHOT%'
                                                          THEN 'HOOK SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%JUMP SHOT%'
                                                          THEN 'JUMP SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%LAYUP SHOT%'
                                                          THEN 'LAYUP SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%NO SHOT%'
                                                          THEN 'NO SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%TIP SHOT%'
                                                          THEN 'TIP SHOT'
                                                          WHEN shotData.ACTION_TYPE LIKE '%ROLL SHOT%'
                                                          THEN 'ROLL SHOT'
                                                          ELSE shotData.ACTION_TYPE
                                                      END AS ACTION_TYPE
                        FROM shotData) AS shotData1 ON threeptPlayers.PLAYER_NAME = shotdata1.PLAYER_NAME
			GROUP BY shotdata1.PLAYER_NAME, shotData1.ACTION_TYPE) AS ShotDist ON TotalShots.PLAYER_NAME = ShotDist.PLAYER_NAME) p

PIVOT (MAX(PERCENT_OF_SHOTS)
	   FOR ACTION_TYPE IN ([BANK SHOT], [DUNK SHOT], [FADEAWAY SHOT], [HOOK SHOT], [JUMP SHOT], [LAYUP SHOT], [NO SHOT], [TIP SHOT], [ROLL SHOT])) AS PivotTable;