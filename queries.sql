with avg_score as
         (SELECT ts.trail_id, AVG(ts.score) as score
          FROM trails_scores ts
                   JOIN users u ON u.user_id = ts.user_id
          WHERE u.level = 'intermediate'
          GROUP BY ts.trail_id),
wild_animals_amount AS
 (SELECT w.trail_id, COUNT(w.animal) AS animal_events
  FROM  wild_animals w
  GROUP BY w.trail_id
 ),
with_train_station as(
    SELECT tow.name AS town_name, t.trail_id, IFNULL(wa.animal_events, 'NO INFORMATION') as animal_events, IFNULL(a.score, 0)as avg_score
    FROM trails t
          LEFT JOIN towns tow ON t.start_point = tow.town_id
          LEFT JOIN avg_score a ON a.trail_id = t.trail_id
          LEFT JOIN wild_animals_amount wa ON wa.trail_id = t.trail_id
    WHERE tow.train_station = True)

(SELECT * FROM  with_train_station
ORDER BY animal_events ASC
LIMIT 5)
    UNION
(SELECT * FROM with_train_station
ORDER BY avg_score DESC
LIMIT 5);


# with normalization
with avg_score as
      (SELECT ts.trail_id, AVG(ts.score)/10 as score
       FROM trails_scores ts
                JOIN users u ON u.user_id = ts.user_id
       WHERE u.level = 'intermediate'
       GROUP BY ts.trail_id),
wild_animals_amount AS
  (SELECT w.trail_id, COUNT(w.animal) AS animal_events
   FROM  wild_animals w
   GROUP BY w.trail_id
  ),
normalized_animal_events AS (
  SELECT
      trail_id,
      wa.animal_events,
      MIN(wa.animal_events) OVER () AS min_animal_events,
          MAX(wa.animal_events) OVER () AS max_animal_events
  FROM wild_animals_amount wa
),
normalized_score_animal AS (
  SELECT
      trail_id,
      (animal_events - min_animal_events) / NULLIF((max_animal_events - min_animal_events), 0) AS normalized_animal_events
  FROM normalized_animal_events
),
with_train_station AS (
  SELECT
      tow.name AS town_name,
      t.trail_id,
      (a.score - n.normalized_animal_events) as score
  FROM trails t
           JOIN towns tow ON t.start_point = tow.town_id
           JOIN avg_score a ON a.trail_id = t.trail_id
           JOIN normalized_score_animal n ON n.trail_id = t.trail_id
  WHERE tow.train_station = True)

SELECT * FROM with_train_station
ORDER BY score DESC;