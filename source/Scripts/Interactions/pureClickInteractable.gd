class_name PureClickInteractable extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var sprite_scale = 1
var outline_thickness = 0
var startSpriteScale:Vector2

func _ready() -> void:
	startSpriteScale = sprite_2d.scale


func _interacted() -> void:
	GlobalResources.GLOBAL_EVENTS.OnInteract.emit()
