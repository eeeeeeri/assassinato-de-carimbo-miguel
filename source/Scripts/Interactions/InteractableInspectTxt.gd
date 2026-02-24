extends Interactable

@export_multiline var TextsList:Array[String]
@export var FinalImage:Texture2D
@export var BackImage:Texture2D

func _interacted(override:bool = false) -> void:
	if(!override && GlobalResources.player.is_interacting):return
	
	super(override)
	GlobalResources.GLOBAL_EVENTS.OnInteractInspectionText.emit(TextsList, FinalImage, BackImage)
