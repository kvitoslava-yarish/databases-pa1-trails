CREATE DATABASE trails;
CREATE TABLE towns
(
    town_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE,
    train_station BOOLEAN
);
CREATE TABLE trails
(
    trail_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE,
    level ENUM('easy', 'medium', 'hard'),
    start_point INT,
    end_point INT,
    duration_days INT,
    FOREIGN KEY (start_point) REFERENCES towns(town_id),
    FOREIGN KEY (end_point) REFERENCES towns(town_id)
);

CREATE TABLE users
(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    surname VARCHAR(255),
    level ENUM('beginner', 'intermediate', 'expert')

);

CREATE TABLE trails_scores
(
    trail_id INT,
    user_id INT,
    score INT,
    FOREIGN KEY (trail_id) REFERENCES trails(trail_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)

);

CREATE TABLE wild_animals
(
    trail_id INT,
    animal ENUM('russian', 'fox', 'bear', 'wolf'),
    FOREIGN KEY (trail_id) REFERENCES trails(trail_id)
);
