extends Interactable

@export var correctStamp:StampData

signal OnCorrectStampLock

func _interacted() -> void:
	super()
	GlobalResources.GLOBAL_EVENTS.OnInspectStampLock.emit(correctStamp, OnCorrectStampLock)
