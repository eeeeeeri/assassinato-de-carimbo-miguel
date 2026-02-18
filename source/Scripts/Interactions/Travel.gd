extends Interactable

@export var scene : String

func _interacted() -> void:
	super()
	SceneTransition.change_scene_to(scene)
