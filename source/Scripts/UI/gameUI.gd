extends Node

@onready var coins_count: Label = $Canvas/CoinInfo/CoinsCount

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.OnUpdateGameUI.connect(UpdateUI)
	
	UpdateUI()

func UpdateUI() -> void:
	coins_count.text = str(GlobalResources.PLAYER_DATA.currencyAmount)
