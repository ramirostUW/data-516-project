With popularZones as (
  Select SHOT_ZONE_AREA, floor(GAME_DATE/10000) as gameYear, 
  count(*) as numShots
  FROM shotdata
  group BY SHOT_ZONE_AREA, floor(GAME_DATE/10000)
),
maxYearShots as (
  Select gameYear, max(numShots) as maxShots
  FROM popularZones 
  GROUP BY gameYear
)
SELECT popularZones.gameYear, popularZones.SHOT_ZONE_AREA, popularZones.numShots
FROM popularZones
INNER JOIN maxYearShots on maxYearShots.gameYear = popularZones.gameYear
Where popularZones.numShots = maxYearShots.maxShots
Order by popularZones.gameYear

--runtime: 00:00:42.961
