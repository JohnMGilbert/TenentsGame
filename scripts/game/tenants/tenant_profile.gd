extends RefCounted
class_name TenantProfile

const POSITIVE_TRAITS: Array[String] = [
	"Generous",
	"Optimistic",
	"Empathetic",
	"Creative",
	"Loyal",
	"Ambitious",
	"Charming",
	"Hardworking",
	"Curious",
	"Honest",
]

const NEUTRAL_TRAITS: Array[String] = [
	"Reserved",
	"Methodical",
	"Stubborn",
	"Playful",
	"Sarcastic",
	"Dramatic",
	"Punctual",
	"Introverted",
	"Blunt",
	"Mysterious",
]

const NEGATIVE_TRAITS: Array[String] = [
	"Cynical",
	"Selfish",
	"Gloomy",
	"Arrogant",
	"Lazy",
	"Judgmental",
	"Impatient",
	"Greedy",
	"Jealous",
	"Petty",
]

var display_name: String = ""
var positive_trait: String = ""
var neutral_trait: String = ""
var negative_trait: String = ""


static func generate(rng: RandomNumberGenerator, tenant_name: String) -> TenantProfile:
	var profile := TenantProfile.new()
	profile.display_name = tenant_name
	profile.positive_trait = _pick_trait(rng, POSITIVE_TRAITS)
	profile.neutral_trait = _pick_trait(rng, NEUTRAL_TRAITS)
	profile.negative_trait = _pick_trait(rng, NEGATIVE_TRAITS)
	return profile


static func _pick_trait(rng: RandomNumberGenerator, trait_pool: Array[String]) -> String:
	return trait_pool[rng.randi_range(0, trait_pool.size() - 1)]


func get_personality_summary() -> String:
	return "I'm a %s, %s, little %s." % [
		positive_trait.to_lower(),
		negative_trait.to_lower(),
		neutral_trait.to_lower(),
	]
