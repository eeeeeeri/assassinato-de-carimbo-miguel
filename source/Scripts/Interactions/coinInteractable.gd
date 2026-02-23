extends Interactable

func _interacted(override:bool = false) -> void:
	if(GlobalResources.player.is_interacting):return
	
	GlobalResources.PLAYER_DATA.AddCurrency()
	visible = false
