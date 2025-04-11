extends Node2D

@onready var sprite_display := $SpriteDisplay
@onready var seed_label := $SeedLabel
@onready var generate_button := $GenerateButton

const Archetypes = preload("res://scripts/mob-sprite-generator/old_code/archetypes.gd")
var seed := 1
var scaler := 8
var sprite_texture : ImageTexture


func _ready():
	seed = 1 #randi()  # initial seed
	update_seed_label()
	generate_sprite()
	sprite_display.scale = Vector2(scaler ,scaler)
	sprite_display.centered = true # For initial testing

func _on_GenerateButton_pressed():
	seed += 1
	update_seed_label()
	generate_sprite()

func update_seed_label():
	if seed_label:
		seed_label.text = "Seed: %d" % seed
	
func generate_sprite():
	var archetype_id = Archetypes.get_archetype_for_seed(seed)
	print("Archetype: ", Archetypes.get_archetype_name(archetype_id))
	var generator = preload("res://scripts/mob-sprite-generator/old_code/sprite_generator.gd").new()
	generator.set_seed(seed)
	
	var grid = generator.generate_raw_grid()
	
	# === CLASSIFY PARTS ===
	var analyzer = preload("res://scripts/mob-sprite-generator/old_code/analyzer.gd").new()
	var parts = analyzer.classify_parts(grid)
	

	var colorizer = preload("res://scripts/mob-sprite-generator/old_code/colorizer.gd").new()
	colorizer.set_seed(seed)
	var palette = colorizer.get_palette()
	var image = colorizer.apply_palette(grid, palette)
	image = colorizer.add_outline(image)
	
	# DEBUG COLORS
	#var debug_image = colorizer.debug_render_parts(parts, grid.size())
	#var sprite_texture = ImageTexture.create_from_image(debug_image)
	#sprite_display.texture = sprite_texture
#
#
	## === DEBUG PARTS ===
	#for role in parts.keys():
		#print("%s: %d pixels" % [role, parts[role].size()])
	
	var sprite_texture = ImageTexture.create_from_image(image)

	sprite_display.texture = sprite_texture
	sprite_display.scale = Vector2(scaler, scaler)

	# Center it visually
	sprite_display.position = get_viewport_rect().size / 2
	sprite_display.offset = Vector2(-sprite_texture.get_width() / 2, -sprite_texture.get_height() / 2)



func _on_generate_button_pressed():
	print("Next sprite")
	seed  += 1 # for incremental change
	update_seed_label()
	generate_sprite()
