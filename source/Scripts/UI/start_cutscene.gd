extends Control

const CARIMBO_MIGUEL_OST___VILA_DE_CARIMBIA = preload("uid://btb6burm64qvp")
const CARIMBO_MIGUEL_OST___REINO_DE_CARIMBIA = preload("uid://c6my8483ht875")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var card_open = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("AdvanceDialog"):
		if card_open:
			SceneTransition.change_scene_to("res://Scenes/Maps/castelo.tscn",CARIMBO_MIGUEL_OST___REINO_DE_CARIMBIA)
		else:
			animation_player.play("abrir carta")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	card_open = true
