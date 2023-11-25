With checkedIfHome as (
Select shotdata.SHOT_ATTEMPTED_FLAG, 
shotdata.SHOT_MADE_FLAG,
  IIF(nbateams.ABBREVIATION = shotdata.HTM, 1, 0) as wasHomeTeam,
  SHOT_ZONE_AREA, floor(GAME_DATE/10000) as gameYear from
  shotdata
  inner join nbateams on nbateams.TEAM_ID = shotdata.TEAM_ID
  where (shotdata.SHOT_TYPE = '2PT Field Goal') OR (shotdata.SHOT_TYPE = '3PT Field Goal')
)
Select Distinct wasHomeTeam, gameYear,
(100.0 * (sum(SHOT_MADE_FLAG)))/sum(SHOT_ATTEMPTED_FLAG) as goal_percent
--sum(SHOT_MADE_FLAG) as goal_percent
from checkedIfHome
group by wasHomeTeam, gameYear
Order by gameYear, wasHomeTeam

--runtime: 00:00:21.897