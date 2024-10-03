import csv
import random
from faker import Faker

# Initialize Faker instance
fake = Faker()
towns = 10000
# Random data generator functions
def generate_town_data(n=10000):
    towns = []
    for i in range(n):
        name = fake.unique.city()
        train_station = random.choice([0,1])
        towns.append((name, train_station))
    return towns

def generate_trail_data( n=10000):
    trails = []
    levels = ['easy', 'medium', 'hard']
    used_trail_names = set()  # Set to store unique trail names

    for i in range(n):
        # Ensure unique trail names by using a while loop
        name = "Trail" +f"{i}"
        used_trail_names.add(name)  # Add to the set to keep it unique
        level = random.choice(levels)
        start_point = random.randint(1, towns)  # Assuming town_id is sequential
        end_point = random.randint(1, towns)
        while end_point == start_point:
            end_point = random.randint(1, towns)
        duration_days = random.randint(1, 30)
        trails.append((name, level, start_point, end_point, duration_days))

    return trails

def generate_user_data(n=10000):
    users = []
    levels = ['beginner', 'intermediate', 'expert']
    for i in range(n):
        name = fake.first_name()
        surname = fake.last_name()
        level = random.choice(levels)
        users.append((name, surname, level))
    return users

def generate_trail_scores_data(n=10000):
    scores = []
    for _ in range(n):
        trail_id = random.randint(1, towns)  # Assuming trail_id is sequential
        user_id = random.randint(1, towns)    # Assuming user_id is sequential
        score = random.randint(1, 10)
        scores.append((trail_id, user_id, score))
    return scores

def generate_wild_animals_data(n=10000):
    animals = []
    animal_types = ['russian', 'fox', 'bear', 'wolf']
    for _ in range(n):
        trail_id = random.randint(1, towns)  # Assuming trail_id is sequential
        animal = random.choice(animal_types)
        animals.append((trail_id, animal))
    return animals

# CSV writing functions
def write_to_csv(filename, headers, data):
    with open(filename, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(headers)
        writer.writerows(data)

# Main script
if __name__ == "__main__":
    # Generate data
    towns_data = generate_town_data()
    #trails_data = generate_trail_data()
    #users_data = generate_user_data()
    # trail_scores_data = generate_trail_scores_data()
    # wild_animals_data = generate_wild_animals_data()

    # Write data to CSV files
    write_to_csv('towns.csv', ['name', 'train_station'], towns_data)
    #write_to_csv('trails.csv', ['name', 'level', 'start_point', 'end_point', 'duration_days'], trails_data)
    #write_to_csv('users.csv', ['name', 'surname', 'level'], users_data)
    # write_to_csv('trails_scores.csv', ['trail_id', 'user_id', 'score'], trail_scores_data)
    # write_to_csv('wild_animals.csv', ['trail_id', 'animal'], wild_animals_data)

    print("CSV files generated successfully!")
