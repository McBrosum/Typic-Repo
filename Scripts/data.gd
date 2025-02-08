extends Node2D

## Constants
const _save_path: String = "res://saved_data.txt"
const CHAR_MAGNITUDE_CAP: float = 20.0

# Dictionaries with appropriate characters
const lowercase_letters: PackedStringArray = [
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
	"k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
	"u", "v", "w", "x", "y", "z"
]
const uppercase_letters: PackedStringArray = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
	"U", "V", "W", "X", "Y", "Z"
]
const numbers: PackedStringArray = [
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
]
const symbols: PackedStringArray = [
	"!", "@", "#", "$", "%", "^", "&", "*", "(", ")",
	"-", "_", "+", "=", "[", "]", "{", "}", ":", ";",
	"'", "\"", "<", ">", ",", ".", "?", "/", "`", "~"
]
# holds the dictionaries - enables picking them by index
const libraries: Array[Array] = [ lowercase_letters, uppercase_letters, numbers, symbols ]


### Variables --------------------------------------------------------------------------------------
## Score Data
var total_score: int = 0
var total_wrong: int = 0
var total_correct: int = 0
var average_accuracy: float = 100.0
var longest_streak: int = 0
var player_level: int = 1

var hard_lowercase: Dictionary = {}
var hard_uppercase: Dictionary = {}
var hard_number: Dictionary = {}
var hard_symbol: Dictionary = {}
var hard_library: Array[Dictionary] = [hard_lowercase, hard_uppercase, hard_number, hard_symbol]

## Settings Data
# Difficulty
enum Sensitivity { LOW = 0, MEDIUM = 1, HIGH = 2, DELICATE = 4 }
var sensitivity: Sensitivity = Sensitivity.LOW

# Allowed Characters
# 0 - lowercase_allowed
# 1 - uppercase_allowed
# 2 - numbers_allowed
# 3 - symbols_allowed
var text_modifiers: Array[bool] = [true, true, true, true]

# Sound
# 0 - music_on
# 1 - sound_effects_on
var sound_modifiers: Array[bool] = [true, true]

# Display
# 0 - total score
# 1 - correct score
# 2 - wrong score
# 3 - accuracy
# 4 - streak
# 5 - hard characters
var score_modifiers: Array[bool] = [true, true, true, true, true, true]

## Data handling structure
var all_data: Dictionary = {
	"total_score": total_score,
	"total_wrong": total_wrong,
	"total_correct": total_correct,
	"average_accuracy": average_accuracy,
	"player_level": player_level,
	"hard_lowercase": hard_lowercase,
	"hard_library": hard_library,
	"longest_streak": longest_streak,
	"sensitivity": sensitivity,
	"text_modifiers": text_modifiers,
	"sound_modifiers": sound_modifiers,
	"score_modifiers": score_modifiers
}

## Variable functions: hard_characters & hard_character_magnitude ----------------------------------
# returns the sum of the specified dictionary
func sum_magnitude(hard_chars: Dictionary) -> float:
	var magnitude: float = 0.0
	for key in hard_chars:
		magnitude += hard_chars[key]
	return magnitude

# updates player level
func update_level() -> void:
	# equation: sqrt(x)
	var level: int = all_data["player_level"]
	while (all_data["total_correct"] > log(float(level)) * 25):
		level += 1
	all_data["player_level"] = level - 1


### saving and loading -----------------------------------------------------------------------------
# saves data to save file
func save_data() -> void:
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	for key in all_data:
		file.store_var(all_data[key])
	print("Data saved!")

# loads data
func load_data() -> void:
	var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ)
	if (file == null):
		# if the file does not exist
		file = FileAccess.new.call()
		save_data()
		return
	
	for key in all_data:
		if (file != null):
			var value = file.get_var()
			if (typeof(value) == typeof(all_data[key])): all_data[key] = value
	
	file.close()
	print("Data loaded!")

# prints all data
func print_all_data() -> void:
	for key in all_data:
		print(str(key) + " : " + str(all_data[key]))


# resets all score data
func reset_score_data() -> void:
	# reset all variables
	all_data["total_score"] = 0
	all_data["total_wrong"] = 0
	all_data["total_correct"] = 0
	all_data["average_accuracy"] = 100.0
	all_data["player_level"] = 1
	all_data["longest_streak"] = 0
	all_data["hard_library"] = [hard_lowercase, hard_uppercase, hard_number, hard_symbol]
	save_data()
	print("Scores reset!")

# resets all settings
func reset_settings() -> void:
	all_data["sensitivity"] = Sensitivity.LOW
	all_data["text_modifiers"] = [true, true, true, true]
	all_data["sound_modifiers"] = [true, true]
	all_data["score_modifiers"] = [true, true, true, true, true, true]
	save_data()
	print("Settings reset!")
