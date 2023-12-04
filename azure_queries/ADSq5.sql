Select avg(SHOT_DISTANCE) as avgShotDist, 
CASE 
  WHEN floor(GAME_DATE/10000) < 2000 THEN '1990s (late)' 
  WHEN floor(GAME_DATE/10000) < 2005 THEN '2000s (early)' 
  WHEN floor(GAME_DATE/10000) < 2010 THEN '2000s (late)' 
  WHEN floor(GAME_DATE/10000) < 2015 THEN '2010s (early)' 
  WHEN floor(GAME_DATE/10000) < 2020 THEN '2010s (late)' 
  ELSE '2020s' END
as era 
from shotdata 
group by 
CASE 
  WHEN floor(GAME_DATE/10000) < 2000 THEN '1990s (late)' 
  WHEN floor(GAME_DATE/10000) < 2005 THEN '2000s (early)' 
  WHEN floor(GAME_DATE/10000) < 2010 THEN '2000s (late)' 
  WHEN floor(GAME_DATE/10000) < 2015 THEN '2010s (early)' 
  WHEN floor(GAME_DATE/10000) < 2020 THEN '2010s (late)' 
  ELSE '2020s' END
order by era;

--runtime: 00:00:21.684