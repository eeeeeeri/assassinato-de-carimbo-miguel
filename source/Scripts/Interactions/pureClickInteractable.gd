class_name PureClickInteractable extends Node2D

@export var hoverSizeIncrease:float = 1.25
@export var outlineThickness:float = 3

@onready var sprite_2d: Sprite2D = $Sprite2D

var sprite_scale = 1
var startSpriteScale:Vector2
var isInteracting:bool

var scaleTween:Tween

signal onInteracted
signal onEndInteraction

func _ready() -> void:
	startSpriteScale = sprite_2d.scale
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(EndInteraction)

func _interacted() -> void:
	if(isInteracting): return
	
	onInteracted.emit()
	isInteracting = true
	
func _on_input_event(node, event, shape) -> void:
	if(Input.is_action_just_released("Press")):
		_interacted()
		
func EndInteraction() -> void:
	if(!isInteracting): return
	
	onEndInteraction.emit()
	isInteracting = false

func _on_mouse_entered() -> void:
	if(scaleTween): scaleTween.kill()
	scaleTween = create_tween()
	scaleTween.tween_property(sprite_2d, "scale", startSpriteScale * hoverSizeIncrease, .1)
	
	if(sprite_2d.material != null):
		sprite_2d.material.set_shader_parameter("thickness", outlineThickness)


func _on_mouse_exited() -> void:
	if(scaleTween): scaleTween.kill()
	scaleTween = create_tween()
	scaleTween.tween_property(sprite_2d, "scale", startSpriteScale, .1)
	
	if(sprite_2d.material != null):
		sprite_2d.material.set_shader_parameter("thickness", Vector2.ZERO)
