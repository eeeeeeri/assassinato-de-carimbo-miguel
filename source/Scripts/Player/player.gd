class_name Player extends CharacterBody2D

const SPEED = 300.0

const HUH = preload("uid://brvbdoqchxkay")

@export var stopMovingSpeedThreshold:float = 50
@export var stopMovingTimer:float = .75

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var possible_position: Area2D = $PossiblePosition
@onready var wait_position: Timer = $WaitPosition
@onready var camera_2d: Camera2D = $Camera2D
@onready var walk_timer: Timer = $WalkTimer
@onready var walk_sound: AudioStreamPlayer = $WalkSound
@onready var collision_timeout: Timer = $CollisionTimeout

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
var zoomTarget : Vector2
var sprite_scale := .3

func _ready() -> void:
	click_position = position
	zoomTarget = camera_2d.zoom
	
	GlobalResources.player = self
	GlobalResources.GLOBAL_EVENTS.OnInteract.connect(_on_interact)
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(_end_inspection)
	GlobalResources.GLOBAL_EVENTS.MapOpen.connect(tab_open)
	GlobalResources.GLOBAL_EVENTS.MapClose.connect(tab_close)
	GlobalResources.GLOBAL_EVENTS.SusOpen.connect(tab_open)
	GlobalResources.GLOBAL_EVENTS.SusClose.connect(tab_close)
	GlobalResources.GLOBAL_EVENTS.JournalOpen.connect(tab_open)
	GlobalResources.GLOBAL_EVENTS.JournalClose.connect(tab_close)
	GlobalResources.GLOBAL_EVENTS.StopMoving.connect(stop_moving)
	GlobalResources.GLOBAL_EVENTS.Paused.connect(paused)
	GlobalResources.GLOBAL_EVENTS.Unpaused.connect(unpaused)
	
	collision_timeout.wait_time = stopMovingTimer

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("left_click") && !is_interacting && !in_menu:
		ray_cast_2d.target_position = get_local_mouse_position()
		possible_position.position = get_local_mouse_position()
		wait_position.start()
		await wait_position.timeout
		_get_mouse_position()
	
	if Input.get_vector("left", "right", "up", "down"):
		mouse_mode = false
	
	if !is_interacting && !in_menu:
		zoom(delta)
		if mouse_mode:
			_move_mouse()
		else:
			_move_keyboard()
			collision_timeout.stop()


func _move_mouse() -> void:
	if position.direction_to(click_position).x > 0:
		animated_sprite.scale.x = -sprite_scale
	elif position.direction_to(click_position).x < 0:
		animated_sprite.scale.x = sprite_scale
	
	if position.distance_to(click_position) > 3:
		target_position = (click_position - position).normalized()
		velocity = target_position * SPEED
		animated_sprite.play("walk")
		move_and_slide()
	else:
		animated_sprite.play("idle")
		
	#if(get_slide_collision_count() > 0):
		#if(collision_timeout.is_stopped()):
			#collision_timeout.start()
	#else:
		#collision_timeout.stop()
		
	if(get_real_velocity().length() < stopMovingSpeedThreshold):
		if(collision_timeout.is_stopped()):
			collision_timeout.start()
	else:
		collision_timeout.stop()


func _move_keyboard() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction.x > 0:
		animated_sprite.scale.x = -sprite_scale
	elif direction.x < 0:
		animated_sprite.scale.x = sprite_scale
	
	if direction:
		velocity = direction * SPEED
		animated_sprite.play("walk")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
	
	move_and_slide()


func _get_mouse_position() -> void:
	var moving_to_object:bool = false
	for overlap in possible_position.get_overlapping_bodies():
		if(overlap as Interactable != null):
			moving_to_object = true
	
	if (!ray_cast_2d.is_colliding() and !possible_position.has_overlapping_bodies()) or moving_to_object:
		mouse_mode = true
		click_position = get_global_mouse_position()
	elif !is_interacting and !moving_to_object and !in_menu:
		var huh = HUH.instantiate()
		huh.position = Vector2(0,-128)
		add_child(huh)


func move_to_object(object_position : Vector2) -> void:
	ray_cast_2d.target_position = object_position
	possible_position.position = object_position
	_get_mouse_position()


func stop_moving() -> void:
	click_position = position
	velocity = Vector2.ZERO
	animated_sprite.play("idle")


func zoom(delta : float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoomTarget *= 1.1
	
	if Input.is_action_just_pressed("zoom_out"):
		zoomTarget *= 0.9
	
	zoomTarget = clamp(zoomTarget, Vector2(.3,.3), Vector2(1.5,1.5))
	camera_2d.zoom = camera_2d.zoom.slerp(zoomTarget, 10 * delta)


func _on_interact():
	velocity = Vector2.ZERO
	mouse_mode = false
	animated_sprite.play("idle")
	click_position = Vector2.ZERO
	interationCalls += 1


func _end_inspection():
	interationCalls -= 1

func tab_open() -> void:
	animated_sprite.play("idle")
	walk_sound.stop()
	interationCalls += 1

func tab_close() -> void:
	interationCalls -= 1

func paused() -> void:
	animated_sprite.play("idle")
	walk_sound.stop()
	in_menu = true


func unpaused() -> void:
	in_menu = false


func _on_walk_timer_timeout() -> void:
	if animated_sprite.animation == "walk":
		walk_sound.play()
