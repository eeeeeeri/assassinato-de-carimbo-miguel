extends CanvasLayer

@export var advanceSpeedScale:float = 4

@onready var crowning: Control = $crowning
@onready var poem: Control = $Poem
@onready var credits: Control = $Credits
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click: AudioStreamPlayer = $click

const CARIMBO_MIGUEL_OST___MENU = preload("uid://c07mdq7itl1bi")
			
func _process(delta: float) -> void:
	if(animation_player.is_playing()):
		if(Input.is_action_pressed("Press")):
			animation_player.speed_scale = advanceSpeedScale
		else:
			animation_player.speed_scale = 1

func _on_continuar_button_up() -> void:
	crowning.visible = false
	poem.visible = false
	animation_player.play("credits")
	click.play()
	

func _on_menu_button_up() -> void:
	SceneTransition.change_scene_to("res://Scenes/UI/main_menu.tscn",CARIMBO_MIGUEL_OST___MENU)
	click.play()
