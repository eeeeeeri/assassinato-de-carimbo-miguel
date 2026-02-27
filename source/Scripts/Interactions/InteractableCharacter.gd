extends Interactable

@export var Character:CharacterData

func _interacted(override:bool = false) -> void:
	if(!override && GlobalResources.player.is_interacting):return
	
	super(override)
	GlobalResources.GLOBAL_EVENTS.OnStartDialog.emit(Character)

func _has_said_name() -> void:
	Character.hasSaidName = true
