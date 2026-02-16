extends CharacterBody2D

const SPEED = 300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var click_position : Vector2
var target_position : Vector2
var mouse_mode := false

func _ready() -> void:
	click_position = position


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("left_click"):
		mouse_mode = true
	
	if Input.get_vector("left", "right", "up", "down"):
		mouse_mode = false
	
	if mouse_mode:
		_move_mouse(delta)
	else:
		_move_keyboard(delta)


func _move_mouse(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		click_position = get_global_mouse_position()
	
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


func _move_keyboard(delta: float) -> void:
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
