extends Node

@export var camera:Camera3D
@export var directory:String

func TakeScreenshot() -> void:
	var img = camera.get_viewport().get_texture().get_image()
	img.save_png(directory)
	
func _input(event: InputEvent) -> void:
	if(Input.is_key_pressed(KEY_P)):
		TakeScreenshot()
