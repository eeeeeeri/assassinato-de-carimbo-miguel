extends Interactable

@export var Character:CharacterData

func _interacted() -> void:
	super()
	GlobalResources.GLOBAL_EVENTS.OnStartDialog.emit(Character)
