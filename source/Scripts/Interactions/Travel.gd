extends Interactable

@export var scene : String
@export var next_audio : AudioStream

func _interacted(override:bool = false) -> void:
	super()
	SceneTransition.change_scene_to(scene, next_audio)

func _on_stop_area_body_entered(body: Node2D) -> void:
	if moving_to_object:
		moving_to_object = false
		SceneTransition.change_scene_to(scene, next_audio)
	super(body)
