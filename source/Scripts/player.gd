extends CharacterBody2D

const SPEED = 300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var possible_position: Area2D = $PossiblePosition

var click_position : Vector2
var target_position : Vector2
var mouse_mode := false
var is_interacting := false
var is_possible_position := true

func _ready() -> void:
	click_position = position
	GlobalResources.GLOBAL_EVENTS.OnInteract.connect(_on_interact)
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(_end_inspection)
	GlobalResources.GLOBAL_EVENTS.MapOpen.connect(map_open)
	GlobalResources.GLOBAL_EVENTS.MapClose.connect(map_close)


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("left_click"):
		ray_cast_2d.target_position = get_local_mouse_position()
		possible_position.position = get_local_mouse_position()
		_get_mouse_position()
	
	if Input.get_vector("left", "right", "up", "down"):
		mouse_mode = false
	
	if !is_interacting:
		if mouse_mode:
			_move_mouse()
		else:
			_move_keyboard()


func _move_mouse() -> void:
	
	if position.direction_to(click_position).x > 0:
		animated_sprite.scale.x = 1
	elif position.direction_to(click_position).x < 0:
		animated_sprite.scale.x = -1
	
	if position.distance_to(click_position) > 3:
		target_position = (click_position - position).normalized()
		velocity = target_position * SPEED
		animated_sprite.play("walk")
		move_and_slide()
	else:
		animated_sprite.play("idle")


func _move_keyboard() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction.x > 0:
		animated_sprite.scale.x = 1
	elif direction.x < 0:
		animated_sprite.scale.x = -1
	
	if direction:
		velocity = direction * SPEED
		animated_sprite.play("walk")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
	
	move_and_slide()


func _get_mouse_position() -> void:
	if !ray_cast_2d.is_colliding() && !possible_position.has_overlapping_bodies():
		mouse_mode = true
		click_position = get_global_mouse_position()


func _on_interact():
	velocity = Vector2.ZERO
	mouse_mode = false
	animated_sprite.play("idle")
	click_position = Vector2.ZERO
	is_interacting = true


func _end_inspection():
	is_interacting = false


func map_open() -> void:
	is_interacting = true


func map_close() -> void:
	is_interacting = false
