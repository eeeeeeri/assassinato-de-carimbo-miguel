extends CanvasLayer

@export var advanceSpeedScale:float = 4

@onready var crowning: Control = $crowning
@onready var poem: Control = $Poem
@onready var credits: Control = $Credits
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click: AudioStreamPlayer = $click
@onready var sfx_stream_player: AudioStreamPlayer = $sfxStreamPlayer

const CARIMBO_MIGUEL_OST___MENU = preload("uid://c07mdq7itl1bi")
			
func _process(delta: float) -> void:
	if(animation_player.is_playing()):
		if(Input.is_action_pressed("Press")):
			animation_player.speed_scale = advanceSpeedScale
			sfx_stream_player.pitch_scale = advanceSpeedScale
			sfx_stream_player.volume_linear = 0
		else:
			animation_player.speed_scale = 1
			sfx_stream_player.pitch_scale = 1
			sfx_stream_player.volume_linear = 1

func _on_continuar_button_up() -> void:
	crowning.visible = false
	poem.visible = false
	animation_player.play("credits")
	click.play()
	

func _on_menu_button_up() -> void:
	SceneTransition.change_scene_to("res://Scenes/UI/main_menu.tscn",CARIMBO_MIGUEL_OST___MENU)
	click.play()
