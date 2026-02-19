class_name Interactable extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

var is_interactable := false
var time := 0.0
var sprite_scale = 1
var outline_thickness = 0
var moving_to_object := false
var startSpriteScale:Vector2

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(end_inspection)
	startSpriteScale = sprite_2d.scale

func _process(delta: float) -> void:
	if is_interactable:
		time += delta
		sprite_scale = sin(time + 1.5*PI) * .05 + 1.05
		outline_thickness = 3
	else:
		time = 0
		sprite_scale = 1
		outline_thickness = 0
	sprite_2d.material.set_shader_parameter("thickness", outline_thickness)
	sprite_2d.scale = startSpriteScale * sprite_scale


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_released("left_click")):
		if is_interactable:
			_interacted()
		else:
			moving_to_object = true
			GlobalResources.GLOBAL_EVENTS.MoveToObject.emit(position)


func _interacted() -> void:
	is_interactable = false
	GlobalResources.GLOBAL_EVENTS.OnInteract.emit()


func end_inspection() -> void:
	if interaction_area.has_overlapping_bodies():
		is_interactable = true


func _on_interaction_area_body_entered(body: Node2D) -> void:
	is_interactable = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	is_interactable = false


func _on_stop_area_body_entered(body: Node2D) -> void:
	if moving_to_object:
		moving_to_object = false
		GlobalResources.GLOBAL_EVENTS.StopMoving.emit()
