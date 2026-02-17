extends Interactable

@export var TextsList:Array[String]

func _interacted() -> void:
	super()
	GlobalResources.GLOBAL_EVENTS.OnInteractInspectionText.emit(TextsList)
