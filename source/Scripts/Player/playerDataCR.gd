class_name PlayerData extends Resource

@export var currencyAmount:int

func AddCurrency() -> void:
	currencyAmount += 1
	GlobalResources.GLOBAL_EVENTS.OnUpdateGameUI.emit()

func RemoveCurrency() -> void:
	currencyAmount = clamp(currencyAmount - 1, 0, 1000)
	GlobalResources.GLOBAL_EVENTS.OnUpdateGameUI.emit()
