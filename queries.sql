with avg_score as
(
    select ts.trail_id, avg(ts.score) as score
    from trails_scores ts
    join users u on u.user_id = ts.user_id
    where u.level = 'intermediate'
    group by ts.trail_id),
    
wild_animals_amount as(
    select w.trail_id, count(w.animal) as animal_events
    from  wild_animals w
    group by w.trail_id
),
with_train_station as(
    select tow.name as town_name, t.trail_id, ifnull(wa.animal_events, 'no information') as animal_events, ifnull(a.score, 0) as avg_score
    from trails t
    left join towns tow on t.start_point = tow.town_id
    left join avg_score a on a.trail_id = t.trail_id
    left join wild_animals_amount wa on wa.trail_id = t.trail_id
    where tow.train_station = true)

(select * from  with_train_station
order by animal_events asc
limit 5)

union

(select * from with_train_station
order by avg_score desc
limit 5);

-- with normalization
with avg_score as
(select ts.trail_id, avg(ts.score)/10 as score
from trails_scores ts
join users u on u.user_id = ts.user_id
where u.level = 'intermediate'
group by ts.trail_id),

wild_animals_amount as(
    select w.trail_id, count(w.animal) as animal_events
    from  wild_animals w
    group by w.trail_id
),
    
normalized_animal_events as (
    select trail_id,
    wa.animal_events,
    min(wa.animal_events) over () as min_animal_events,
    max(wa.animal_events) over () as max_animal_events
    from wild_animals_amount wa
     ),
    
normalized_score_animal as (
    select trail_id,
    (animal_events - min_animal_events) / nullif((max_animal_events - min_animal_events), 0) as normalized_animal_events
    from normalized_animal_events
),
    
with_train_station as (
    select tow.name as town_name,
    t.trail_id,
    (a.score - n.normalized_animal_events) as score
    from trails t
    join towns tow on t.start_point = tow.town_id
    join avg_score a on a.trail_id = t.trail_id
    join normalized_score_animal n on n.trail_id = t.trail_id
     where tow.train_station = true
 )

select * from with_train_station
order by score desc;
