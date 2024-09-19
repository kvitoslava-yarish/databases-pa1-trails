import csv
import random

# Fun names for trails and towns
fun_trail_names = [
    "Misty Mountain", "Dragon's Tail", "Whispering Pines", "Eagle's Nest", "Thunder Road",
    "Sunset Ridge", "Crimson Peak", "Bear Claw Pass", "Winding River", "Shadow Valley",
    "Emerald Forest", "Coyote Canyon", "Starlit Path", "Windy Bluff", "Glacier Run",
    "Silver Falls", "Moonlit Meadow", "Raven's Roost", "Serpent's Spine", "Wildflower Way",
    "Frostbite Trail", "Golden Horizon", "Viper's Lair", "Red Rock Trail", "Highland Crest",
    "Blue Lagoon", "Wolf's Den", "Cedar Hollow", "Jagged Ridge", "Tumbleweed Trail",
    "Hidden Grotto", "Falcon's Flight", "Ivy Creek", "Twilight Peak", "Boulder Dash",
    "Lightning Path", "Aspen Grove", "Ironwood Trail", "Desert Mirage", "Echo Cave",
    "Bramble Hollow", "Cloverfield Path", "Maple Vale", "Glade Whisper", "Tundra's Edge",
    "Thunderclap Valley", "Crystal Brook", "Duskwind Trail", "Shimmering Bay"
]

fun_town_names = [
    "Pinehaven", "Dragon's Rest", "Wolf Hollow", "Starlight Springs", "Bear Creek",
    "Moonstone", "Thunderfoot", "Whisperwind", "Cragmoor", "Eaglespire",
    "Frostholm", "Willowbend", "Redwater", "Shadowfen", "Cinderfall",
    "Ashenvale", "Riverglen", "Bramblemoor", "Crystal Bay", "Silverkeep",
    "Foxridge", "Ironforge", "Goldenleaf", "Brightwood", "Mistwood",
    "Sunpeak", "Blackrock", "Shadewood", "Falconridge", "Blizzardvale",
    "Glimmerfield", "Wildgrove", "Winter's Hollow", "Maplehold", "Coppercliff",
    "Tumbleweed Flats", "Bluewater", "Dustwind", "Cloverreach", "Sunshadow",
    "Ravencliff", "Whistle Hollow", "Sagewood", "Lakeshire", "Sandstone Bay",
    "Marblebridge", "Oakhaven", "Everglade", "Blazebrook", "Dusktide"
]


# Generate 50 fun trails without trail_id (autoincrement handled separately)
def generate_trails(file_name="trails.csv"):
    with open(file_name, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["name", "level", "start_point", "end_point", "duration_days"])

        levels = ['easy', 'medium', 'hard']
        for i in fun_town_names:
            writer.writerow(
                [i, random.choice(levels), random.randint(0, 50), random.randint(0, 50),
                 random.randint(1, 5)])


# Generate users without user_id (autoincrement handled separately)
def generate_users(file_name="users.csv", num_users=50):
    with open(file_name, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["name", "surname", "level"])

        levels = ['beginner', 'intermediate', 'expert']
        for i in range(num_users):
            writer.writerow([f"Name{i + 1}", f"Surname{i + 1}", random.choice(levels)])


# Generate trail scores without trail_id and user_id (foreign keys will reference trails and users)
def generate_trail_scores(file_name="trails_scores.csv", num_trails=49, num_users=len(fun_town_names)):
    with open(file_name, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["trail_id", "user_id", "score"])

        for i in range(200):
            user_id = random.randint(1, num_users)  # assuming user_id and trail_id are auto-incremented
            score = random.randint(0, 10)
            writer.writerow([random.randint(2,50), user_id, score])


# Generate wild animals without trail_id (autoincrement handled separately)
def generate_wild_animals(file_name="wild_animals.csv", num_trails=49):
    with open(file_name, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["trail_id", "animal"])

        animals = ['russian', 'fox', 'bear', 'wolf']
        for i in range(200):
            writer.writerow([random.randint(2, 50), random.choice(animals)])


# Generate fun towns without town_id (autoincrement handled separately)
def generate_towns(file_name="towns.csv", num_towns=20):
    with open(file_name, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["name", "train_station"])

        for i in fun_town_names:
            train_station = random.choice([0,1])
            writer.writerow([i, train_station])

# generate_trails()
# generate_users()
generate_trail_scores()
generate_wild_animals()
# generate_towns()

print(len(fun_trail_names))

print("CSV files with fun names generated successfully without auto-incremented IDs!")
