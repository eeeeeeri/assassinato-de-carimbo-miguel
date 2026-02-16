class_name Interactable extends Node

signal OnInteracted

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_action_released("Press")):
		OnInteracted.emit()
