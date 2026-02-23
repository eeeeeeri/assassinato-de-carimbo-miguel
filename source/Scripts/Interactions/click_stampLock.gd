extends Interactable

@export var correctStamp:StampData

signal OnCorrectStampLock

func _interacted(override:bool = false) -> void:
	if(!override && GlobalResources.player.is_interacting):return
	
	super()
	GlobalResources.GLOBAL_EVENTS.OnInspectStampLock.emit(correctStamp, OnCorrectStampLock)
