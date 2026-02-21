extends CanvasLayer

@onready var continuar_button: Button = $Main/VBoxContainer/Continuar
@onready var config_button: Button = $Main/VBoxContainer/Config
@onready var ajuda_button: Button = $Main/VBoxContainer/Ajuda
@onready var sair_button: Button = $Main/VBoxContainer/Sair

@onready var main: Control = $Main
@onready var settings: Control = $Settings
@onready var tutorial: Control = $Tutorial

var paused := false

func _ready() -> void:
	_unpause()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			_unpause()
		else:
			_pause()

func _pause():
	visible = true
	paused = true
	main.visible = true
	settings.visible = false
	tutorial.visible = false
	GlobalResources.GLOBAL_EVENTS.Paused.emit()
	Engine.time_scale = 0

func _unpause():
	visible = false
	paused = false
	GlobalResources.GLOBAL_EVENTS.Unpaused.emit()
	Engine.time_scale = 1


func _on_continuar_button_up() -> void:
	_unpause()


func _on_sair_button_up() -> void:
	get_tree().quit()


func _on_ajuda_button_up() -> void:
	main.visible = false
	tutorial.page = -1
	tutorial.visible = true


func _on_back_button_button_up() -> void:
	main.visible = true
	settings.visible = false
	tutorial.visible = false


func _on_config_button_up() -> void:
	main.visible = false
	settings.visible = true
