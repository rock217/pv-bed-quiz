-- 1. Write a query to return the full name, id, position, total goals, and signed date for all active
-- players on the team 'dallas penguins'.

select
    concat(p.first_name, ' ', p.last_name) as full_name,
    p.player_id,
    p.FK_position,
    coalesce(count(g.goal_id), 0) as total_goals,
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
-- The author notes the goal quantity was not specified as part of the returned query.

-- The author assumes this query is looking for the most recent 5 days on which
-- only the exact maximum goals per day occurred.

select g.date
from
(
    select from_unixtime(g.timestamp, '%Y-%m-%d') `date`, count(g.goal_id) goals
    from goal g
    group by `date`
) g
join(
    select
           coalesce(count(g.goal_id), 0) max_goals
    from goal g
    group by from_unixtime(g.timestamp, '%Y-%m-%d')
    order by max_goals desc
    limit 1
) mg on mg.max_goals = g.goals
order by g.date desc
limit 5;

-- If the author assumed incorrectly, here is a query returning
-- quantity of goals sorted desc with the date sorted desc.

select from_unixtime(g.timestamp, '%Y-%m-%d') `date`,
    coalesce(count(g.goal_id), 0) total_goals
from goal g
group by `date`
order by total_goals desc, `date` desc
limit 5;

-- 3. Write a query to return the full name, id, career length, and team for all retired player. Ordered
-- the results by team name alphabetically from a-z and player name alphabetically from z-a.

select
    concat(p.first_name, ' ', p.last_name) as full_name,
    p.player_id,
    datediff(p.retired_date, p.signed_date) career_length,
    t.name
from
    player p
    join team t on t.team_id = p.FK_team_id
where p.retired_date < CURRENT_DATE
order by t.name, full_name desc;

-- 4. Write a query to return the full name, position, and total goals scored for all active players on all
-- teams. Order the results by team, position, and then descending by total goals scored.

select
    concat(p.first_name, ' ', p.last_name) as full_name,
    p.FK_position,
    coalesce(count(g.goal_id), 0) as total_goals
from
    player p
    left join goal g on p.player_id = g.FK_player_id
    join team t on t.team_id = p.FK_team_id
group by p.player_id
order by t.name, p.FK_position, total_goals desc;

-- 5. Write a query to determine which position has scored the most overall goals in the year 2015.

select
    p.FK_position
from player p
    left join goal g on p.player_id = g.FK_player_id
where timestamp between UNIX_TIMESTAMP('2015-01-01') and UNIX_TIMESTAMP('2015-12-31')
group by FK_position
order by coalesce(count(g.goal_id), 0)
limit 1;

-- 6. Write a query to return the top 10 teams who have scored the most goals in the past 5 years.

-- The author now assumes these requirements do not mean "exactly the highest goal quantity"
-- but rather sorting by goal quantity desc, because he grows weary of sub selects.
-- The author also playfully suggests a kaizen to improve the wording of these requirements.

select t.name, coalesce(count(g.goal_id), 0) as total_goals
from team t
    join player p on p.FK_team_id = t.team_id
    left join goal g on g.FK_player_id = p.player_id
group by p.FK_team_id
order by total_goals desc
limit 10;


-- 7. Write a query to return the total goals scored by each retired defensive player on team
-- 'michigan minutemen'.
-- The author notes that views would have probably been the way to go for some of these items that are reused.
-- But it seems outside the spirit of "a query."

select
    concat(p.first_name, ' ', p.last_name) as full_name,
    coalesce(count(g.goal_id), 0) as total_goals
from
    player p
    join team t on t.team_id = p.FK_team_id
    left join goal g on g.FK_player_id = p.player_id
where p.retired_date < CURRENT_DATE
    and t.name = 'michigan minutemen'
    and p.FK_position='defense'
group by p.player_id
order by total_goals desc, full_name;

-- 8. Write a query to return the team that has the most goalie goals overall.

select t.name
from team t
    join player p on p.FK_team_id = t.team_id
    left goal g on g.FK_player_id = p.player_id
where p.FK_position='goalie'
group by p.FK_team_id
order by count(g.goal_id) desc
limit 1;

-- 9. Build an index to efficiently return the full name and signed date for all players when searching
-- by players last name.

create index ln_fn_sd on player(last_name, first_name, signed_date);

-- 10. Are there any suggestions you would make to make the schema more efficient?

-- Really depends on the usage in question, doesnt it?
-- Are we talking about index efficiency, or efficiency of disk storage?
-- That said, I'll offer an example:
-- FK_position being a varchar isn't great.  I'd create position.position_id as a tinyint
-- and shift FK_position to FK_position_id of the same.
-- Also how many teams are there? I would guess we could get away with an unsigned tinyint or a smallint
-- for those columns as well.  There is probably more, but these seem like reasonable examples.

-- 11. Given the following unique values for each column (you can assume the dates are relatively
-- uniform year-to-year):
-- first_name last_name FK_position signed_date total_rows
-- 92345 292343 5 39420 887374
-- a. Build an index to most efficiently return results when searching with the where clause:
-- b. 'WHERE first_name = 'kevin' AND last_name = 'smith' AND FK_position = 'defense' AND
-- signed_date BETWEEN ('2014-10-01') AND ('2016-12-14');'

-- The author cannot tell the difference between a/b in this context, and assumes this is only one question.
-- The author also seems to recall that index strategy prefers "highest entropy first" on compound indexes.
-- Finally, the author does not believe this Mallrat has ever actually played hockey, but he could be wrong :)

create index ln_fn_sd_pos on player(last_name, first_name, signed_date, FK_position);
