extends Interactable

@export_multiline var TextsList:Array[String]
@export var FinalImage:Texture2D
@export var BackImage:Texture2D

func _interacted() -> void:
	super()
	GlobalResources.GLOBAL_EVENTS.OnInteractInspectionText.emit(TextsList, FinalImage, BackImage)
