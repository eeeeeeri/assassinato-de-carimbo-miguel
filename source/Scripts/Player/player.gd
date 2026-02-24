class_name Player extends CharacterBody2D

const SPEED = 300.0

const HUH = preload("uid://brvbdoqchxkay")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var possible_position: Area2D = $PossiblePosition
@onready var wait_position: Timer = $WaitPosition
@onready var camera_2d: Camera2D = $Camera2D
@onready var walk_timer: Timer = $WalkTimer
@onready var walk_sound: AudioStreamPlayer = $WalkSound

var click_position : Vector2
var target_position : Vector2
var mouse_mode := false
var is_interacting:bool:
	get():
		return interationCalls > 0
var interationCalls : int = 0:
	set(value):
		interationCalls = clamp(value, 0, 1000)
var in_menu := false
var is_possible_position := true
var moving_to_object := false

func _ready() -> void:
	click_position = position
	GlobalResources.player = self
	GlobalResources.GLOBAL_EVENTS.OnInteract.connect(_on_interact)
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(_end_inspection)
	GlobalResources.GLOBAL_EVENTS.MapOpen.connect(map_open)
	GlobalResources.GLOBAL_EVENTS.MapClose.connect(map_close)
	GlobalResources.GLOBAL_EVENTS.SusOpen.connect(sus_open)
	GlobalResources.GLOBAL_EVENTS.SusClose.connect(sus_close)
	GlobalResources.GLOBAL_EVENTS.MoveToObject.connect(move_to_object)
	GlobalResources.GLOBAL_EVENTS.StopMoving.connect(stop_moving)
	GlobalResources.GLOBAL_EVENTS.Paused.connect(paused)
	GlobalResources.GLOBAL_EVENTS.Unpaused.connect(unpaused)


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("left_click") && !is_interacting && !in_menu:
		ray_cast_2d.target_position = get_local_mouse_position()
		possible_position.position = get_local_mouse_position()
		wait_position.start()
		await wait_position.timeout
		if !moving_to_object:
			_get_mouse_position()
	
	if Input.get_vector("left", "right", "up", "down"):
		mouse_mode = false
	
	if !is_interacting && !in_menu:
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
	if (!ray_cast_2d.is_colliding() and !possible_position.has_overlapping_bodies()) or moving_to_object:
		mouse_mode = true
		click_position = get_global_mouse_position()
	else:
		if !is_interacting and !moving_to_object and !in_menu:
			var huh = HUH.instantiate()
			huh.position = Vector2(0,-128)
			add_child(huh)


func move_to_object(object_position : Vector2) -> void:
	moving_to_object = true
	ray_cast_2d.target_position = object_position
	possible_position.position = object_position
	_get_mouse_position()


func stop_moving() -> void:
	if moving_to_object:
		moving_to_object = false
		click_position = position
		velocity = Vector2.ZERO
		animated_sprite.play("idle")


func _on_interact():
	velocity = Vector2.ZERO
	mouse_mode = false
	animated_sprite.play("idle")
	click_position = Vector2.ZERO
	interationCalls += 1


func _end_inspection():
	interationCalls -= 1

func map_open() -> void:
	interationCalls += 1


func map_close() -> void:
	interationCalls -= 1


func sus_open() -> void:
	interationCalls += 1


func sus_close() -> void:
	interationCalls -= 1


func paused() -> void:
	in_menu = true


func unpaused() -> void:
	in_menu = false


func _on_walk_timer_timeout() -> void:
	if animated_sprite.animation == "walk":
		walk_sound.play()
