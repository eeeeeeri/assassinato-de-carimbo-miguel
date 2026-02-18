extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var tween : Tween
var new_scene : String


func change_scene_to(scene : String) -> void:
	if tween:
		tween.kill()
	
	new_scene = scene
	color_rect.material.set_shader_parameter("invert", true)
	
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(update_shader, 0.0, 3.0, .5).connect("finished", _load_new_scene)
	tween.chain().tween_method(update_shader, 0.0, 3.0, .5)

func update_shader(value : float) -> void:
	color_rect.material.set_shader_parameter("progress", value)

func _load_new_scene() -> void:
	color_rect.material.set_shader_parameter("invert", false)
	get_tree().change_scene_to_file(new_scene)
