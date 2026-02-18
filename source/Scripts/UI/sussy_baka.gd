extends Control

@onready var label: Label = $Panel/Label
@onready var sprite_2d: Sprite2D = $Panel/ColorRect/Sprite2D
@onready var mark: Sprite2D = $Panel/Mark
@onready var panel: Panel = $Panel
@onready var shadow: ColorRect = $Panel/Shadow

@export var sus_name : String
@export var sus_sprite : Texture2D

var scale_tween : Tween
var angle_tween : Tween
var shadow_tween : Tween
var mark_tween : Tween

func _ready() -> void:
	label.text = sus_name
	sprite_2d.texture = sus_sprite
	mark.scale = Vector2.ZERO
	rotate()


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		mark_size(1)
	else:
		mark_size(0)


func rotate() -> void:
	var angle = deg_to_rad(randf_range(-5,5))
	if angle_tween: angle_tween.kill()
	angle_tween = create_tween().set_trans(Tween.TRANS_SINE)
	angle_tween.tween_property(panel,"rotation",angle,.1)


func size(value : float) -> void:
	if scale_tween: scale_tween.kill()
	scale_tween = create_tween().set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(panel,"scale",Vector2(value,value),.2)


func _shadow(n1 : float, n2 : float) -> void:
	if shadow_tween: shadow_tween.kill()
	shadow_tween = create_tween().set_trans(Tween.TRANS_SINE)
	shadow_tween.tween_method(shade,n1,n2,.2)


func shade(value : float) -> void:
	shadow.material.set_shader_parameter("shadow_offset",Vector2(value,value))


func mark_size(value : float) -> void:
	if mark_tween: mark_tween.kill()
	mark_tween = create_tween().set_trans(Tween.TRANS_SINE)
	mark_tween.tween_property(mark,"scale",Vector2(value,value),.2)


func _on_mouse_entered() -> void:
	_shadow(0,8)
	size(1.1)


func _on_mouse_exited() -> void:
	_shadow(8,0)
	size(1.0)
	rotate()
