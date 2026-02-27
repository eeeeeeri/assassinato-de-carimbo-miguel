class_name Culpado extends SubViewportContainer

@onready var sprite_2d: Sprite2D = $SubViewport/Panel/ColorRect/Sprite2D
@onready var label: Label = $SubViewport/Panel/Label

@export var sus_name : String
@export var sus_sprite : Texture2D
@export var sus_spritePosition:Vector2
@export var sus_character:CharacterData

func _ready() -> void:
	label.text = sus_name
	sprite_2d.texture = sus_sprite
	sprite_2d.position = sus_spritePosition
	shake(1)

func shake(value) -> void:
	material.set_shader_parameter("shake_intensity", value)
