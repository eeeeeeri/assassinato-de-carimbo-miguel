extends Control

const CONTOS_DE_CARIMBIA___TUTORIAL = preload("uid://cm4j107i25jh7")

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var main: Control = $Main
@onready var settings: Control = $Settings
@onready var tutorial: Control = $Tutorial
@onready var credits: Control = $Credits

var paused := false


func _on_sair_button_up() -> void:
	audio_stream_player.play()
	get_tree().quit()


func _on_ajuda_button_up() -> void:
	main.visible = false
	tutorial.page = -1
	tutorial.visible = true
	audio_stream_player.play()

func _on_back_button_button_up() -> void:
	main.visible = true
	settings.visible = false
	tutorial.visible = false
	credits.visible = false
	audio_stream_player.play()


func _on_config_button_up() -> void:
	main.visible = false
	settings.visible = true
	audio_stream_player.play()

func _on_iniciar_button_up() -> void:
	audio_stream_player.play()
	SceneTransition.change_scene_to("res://Scenes/UI/start_cutscene.tscn", CONTOS_DE_CARIMBIA___TUTORIAL)

func _on_creditos_button_up() -> void:
	main.visible = false
	credits.visible = true
	audio_stream_player.play()
