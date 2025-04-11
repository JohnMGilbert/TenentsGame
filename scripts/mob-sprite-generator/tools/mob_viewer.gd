extends Node2D

@onready var mob_root := $MobRoot
@onready var seed_label := $UI/SeedLabel
@onready var generate_button := $UI/GenerateBtn
@onready var sprite_preview := $SpritePreview

var Archetype = preload("res://scripts/mob-sprite-generator/mob_archetypes/biped.gd").new()
var SpriteBuilder = preload("res://scripts/mob-sprite-generator/rendering/sprite_builder.gd").new()
var MobAssembler = preload("res://scripts/mob-sprite-generator/rendering/mob_assembler.gd")

var seed := 1

func _ready():
	_generate()


func _generate():
	seed_label.text = "Seed: %d" % seed

	# Clear old mob
	for child in mob_root.get_children():
		child.queue_free()

	# Generate grid from archetype structure
	var part_layout := Archetype.get_part_structure()
	var grid := SpriteBuilder.generate_grid(seed, part_layout)

	# Render the grid into a texture
	var image := SpriteBuilder.render_grid(grid)
	var texture := ImageTexture.create_from_image(image)
	sprite_preview.texture = texture
	sprite_preview.position = get_viewport_rect().size / 2 - Vector2(texture.get_width(), texture.get_height()) / 2

	# Assemble the mob with parts
	var mob_instance: Node2D = MobAssembler.new()
	mob_instance.archetype = Archetype
	mob_root.add_child(mob_instance)


func _on_generate_button_pressed():
	seed += 1
	_generate()
