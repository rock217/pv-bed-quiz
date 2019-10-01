-- 1. Write a query to return the full name, id, position, total goals, and signed date for all active
-- players on the team 'dallas penguins'.
select
    concat(p.first_name, ' ', p.last_name) as full_name,
    p.player_id as id,
    p.FK_position as `position`,
    coalesce(sum(g.goal_id), 0) as total_goals,
    p.signed_date
from
    player p
    join team t on t.team_id = p.FK_team_id
    left join goal g on p.player_id = g.FK_player_id
where
    coalesce(p.retired_date, CURRENT_DATE) >= CURRENT_DATE
    and t.name = 'dallas penguins'
group by p.player_id;

-- 2. Write a query to return the top 5 days in which the most goals were scored.


-- 3. Write a query to return the full name, id, career length, and team for all retired player. Ordered
-- the results by team name alphabetically from a-z and player name alphabetically from z-a.
-- 4. Write a query to return the full name, position, and total goals scored for all active players on all
-- teams. Order the results by team, position, and then descending by total goals scored.
-- 5. Write a query to determine which position has scored the most overall goals in the year 2015.
-- 6. Write a query to return the top 10 teams who have scored the most goals in the past 5 years.
-- 7. Write a query to return the total goals scored by each retired defensive player on team
-- 'michigan minutemen'.
-- 8. Write a query to return the team that has the most goalie goals overall.
-- 9. Build an index to efficiently return the full name and signed date for all players when searching
-- by players last name.
-- 10. Are there any suggestions you would make to make the schema more efficient?
-- 11. Given the following unique values for each column (you can assume the dates are relatively
-- uniform year-to-year):
-- first_name last_name FK_position signed_date total_rows
-- 92345 292343 5 39420 887374
-- a. Build an index to most efficiently return results when searching with the where clause:
-- b. 'WHERE first_name = 'kevin' AND last_name = 'smith' AND FK_position = 'defense' AND
-- signed_date BETWEEN ('2014-10-01') AND ('2016-12-14');'