extends TextureButton

@export var scene : String
@export var audio : AudioStream
var transitioning := false

func _on_mouse_entered() -> void:
	scale = Vector2(1.1,1.1)


func _on_mouse_exited() -> void:
	scale = Vector2(1.0,1.0)


func _on_button_up() -> void:
	if !transitioning:
		transitioning = true
		SceneTransition.change_scene_to(scene, audio)
