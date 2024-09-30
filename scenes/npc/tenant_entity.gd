extends Node
# DEBUG


var content_level
var relationship_power
var chance_to_leave = 0
var possible_actions = []

enum interactions {
	talk
}

var current_interaction

# Enum for Positive Traits
enum PositiveTraits {
	GENEROUS,
	OPTIMISTIC,
	EMPATHETIC,
	CREATIVE,
	LOYAL,
	AMBITIOUS,
	CHARMING,
	HARDWORKING,
	CURIOUS,
	HONEST
}

# Enum for Neutral Traits
enum NeutralTraits {
	RESERVED,
	METHODICAL,
	STUBBORN,
	PLAYFUL,
	SARCASTIC,
	DRAMATIC,
	PUNCTUAL,
	INTROVERTED,
	BLUNT,
	MYSTERIOUS
}

# Enum for Negative Traits
enum NegativeTraits {
	CYNICAL,
	SELFISH,
	GLOOMY,
	ARROGANT,
	LAZY,
	JUDGMENTAL,
	IMPATIENT,
	GREEDY,
	JEALOUS,
	PETTY
}

var positive_trait
var neutral_trait
var negative_trait

# Called when the node enters the scene tree for the first time.
func _ready():
	# If npc does not exist.
	_randomizeTraits()
	_setName()
	current_interaction = interactions.talk # set default interaction
	possible_actions.append(Callable(self, "talk_to"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _randomizeTraits():
	# TODO: First, check what npc types exist and nudge towards uniqueness.
	
	positive_trait = randi() % len(PositiveTraits)
	neutral_trait = randi() % len(NeutralTraits)
	negative_trait = randi() % len(NegativeTraits)

func _setName():
	$Label.text = "Mark Marks"

# add all functions in the region to possible actions where necessary
#region New Code Region

# Function to initialize dialogue options
func talk_to():
	print("Hey man, you're talking to ", self.name)
	print("I'm a ", PositiveTraits.keys()[positive_trait], " ", NegativeTraits.keys()[negative_trait], " little ", NeutralTraits.keys()[neutral_trait])

#endregion


func get_possible_actions():
	return possible_actions
