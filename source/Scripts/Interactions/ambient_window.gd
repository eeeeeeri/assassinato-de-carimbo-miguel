class_name AmbientWindow extends Node2D

@onready var interactions: Node2D = $Interactions

var hoveringWindow:bool
var isInteracting:bool:
	get():
		var interacting = false
		for child in interactions.get_children():
			var interaction = child as PureClickInteractable
			if(interaction && interaction.isInteracting): interacting = true
		return interacting

func EndInteraction() -> void:
	if(isInteracting): return
	
	GlobalResources.GLOBAL_EVENTS.EndInspection.emit()

func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("Cancel")):
		EndInteraction()
		
func WindowHoverEnter() -> void:
	hoveringWindow = true
	
func WindowHoverExit() -> void:
	hoveringWindow = false

func BackgroundInputEvent(viewport, event, shapeIdx) -> void:
	if(Input.is_action_just_pressed("Press") && !hoveringWindow && !isInteracting):
		EndInteraction()
