extends Interactable

func _interacted() -> void:
	GlobalResources.PLAYER_DATA.AddCurrency()
	visible = false
