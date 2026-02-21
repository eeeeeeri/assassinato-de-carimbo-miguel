extends Control

@onready var tutorial_1: Sprite2D = $Tutorial1
@onready var tutorial_2: Sprite2D = $Tutorial2

const num_pages := 2
var page := 0

func _process(delta: float) -> void:
	
	if Input.is_action_just_released("left_click"):
		page += 1
		if page >= num_pages:
			page = 0
	
	match (page):
		0:
			tutorial_1.visible = true
			tutorial_2.visible = false
		1:
			tutorial_1.visible = false
			tutorial_2.visible = true
