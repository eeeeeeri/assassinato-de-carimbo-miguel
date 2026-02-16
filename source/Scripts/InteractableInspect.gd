extends Interactable

@export var InspectableScene:PackedScene

func _interacted() -> void:
	super()
	GlobalResources.GLOBAL_EVENTS.OnInteractInspection3D.emit(InspectableScene)
