extends Node

@onready var coin_info: Control = $Canvas/CoinInfo
@onready var coins_count: Label = $Canvas/CoinInfo/CoinsCount
@onready var coin_sound: AudioStreamPlayer = $CoinSound

var first_load := true

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.OnUpdateGameUI.connect(UpdateUI)
	
	UpdateUI()
	if first_load: first_load = false

func UpdateUI() -> void:
	coin_info.visible = GlobalResources.PLAYER_DATA.currencyAmount > 0
	coins_count.text = str(GlobalResources.PLAYER_DATA.currencyAmount)
	if !first_load: coin_sound.play()
