class_name Interactable extends Node

var is_interactable := false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_interactable:
		if(event.is_action_released("left_click")):
			_interacted()

func _interacted() -> void:
	GlobalResources.GLOBAL_EVENTS.OnInteract.emit()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	is_interactable = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	is_interactable = false
