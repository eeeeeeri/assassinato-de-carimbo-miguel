extends Control

@onready var tutorial_1: Sprite2D = $Tutorial1
@onready var tutorial_2: Sprite2D = $Tutorial2
@onready var tutorial_3: Sprite2D = $Tutorial3
@onready var avancar: Button = $Avancar
@onready var voltar: Button = $Voltar

var page := 0
const num_pages := 3

func _process(delta: float) -> void:
	match (page):
		0:
			tutorial_1.visible = true
			tutorial_2.visible = false
			tutorial_3.visible = false
			avancar.visible = true
			voltar.visible = false
		1:
			tutorial_1.visible = false
			tutorial_2.visible = true
			tutorial_3.visible = false
			avancar.visible = true
			voltar.visible = true
		2:
			tutorial_1.visible = false
			tutorial_2.visible = false
			tutorial_3.visible = true
			avancar.visible = false
			voltar.visible = true


func _on_avancar_button_up() -> void:
	page += 1


func _on_voltar_button_up() -> void:
	page -= 1
