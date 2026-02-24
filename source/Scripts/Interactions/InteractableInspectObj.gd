extends Interactable

@export var InspectableScene:PackedScene

func _interacted(override:bool = false) -> void:
	if(!override && GlobalResources.player.is_interacting):return
	
	super(override)
	GlobalResources.GLOBAL_EVENTS.OnInteractInspection3D.emit(InspectableScene)
