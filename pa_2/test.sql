-- UNOPTIMIZED

explain analyze
(select * from
    (select tow.name as town_name, t.trail_id,
            
    ifnull((select count(w.animal)
             from wild_animals w
             where w.trail_id = t.trail_id
             group by w.trail_id), 'no information') as animal_events,
         
    ifnull((select avg(ts.score)
             from trails_scores ts
             use index()
             join users u on u.user_id = ts.user_id
             where u.level = 'intermediate' and ts.trail_id = t.trail_id and ts.score >3
             group by ts.trail_id), 0) as avg_score
    from trails t
    use index()
    left join towns tow on t.start_point = tow.town_id
    where tow.train_station = true
    ) as with_train_station
order by animal_events asc
limit 5)

union

(select * from
    (select tow.name as town_name, t.trail_id,
    ifnull((select count(w.animal)
             from wild_animals w
             where w.trail_id = t.trail_id
             group by w.trail_id), 'no information') as animal_events,
         
    ifnull((select avg(ts.score)
            from trails_scores ts
            use index()
            join users u on u.user_id = ts.user_id
            where u.level = 'intermediate' and ts.trail_id = t.trail_id and ts.score >3
            group by ts.trail_id), 0) as avg_score
    from trails t
    use index()
    left join towns tow on t.start_point = tow.town_id
     where tow.train_station = true
    ) as with_train_station

order by avg_score desc
limit 5);

-- optimized
explain analyze 
with avg_score as(
    select ts.trail_id, avg(ts.score) as score
    from trails_scores ts
          join users u on u.user_id = ts.user_id
    where u.level = 'intermediate' and ts.score > 3
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

create index level_index on users(level);
create index train_index on towns(train_station);
create index score_index on trails_scores(score);
create index start_point_index on trails(start_point);