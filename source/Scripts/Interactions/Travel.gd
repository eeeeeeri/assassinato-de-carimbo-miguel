extends Interactable

@export var scene : String

func _interacted() -> void:
	super()
	SceneTransition.change_scene_to(scene)

func _on_stop_area_body_entered(body: Node2D) -> void:
	if moving_to_object:
		moving_to_object = false
		SceneTransition.change_scene_to(scene)
	super(body)
