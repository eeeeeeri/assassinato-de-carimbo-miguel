extends CanvasLayer

@onready var panel_container: PanelContainer = $PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var showing = false

func _ready() -> void:
	panel_container.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select_culpado"):
		if showing:
			animation_player.play("hide")
			GlobalResources.GLOBAL_EVENTS.SusClose.emit()
			showing = false
		else:
			animation_player.play("show")
			GlobalResources.GLOBAL_EVENTS.SusOpen.emit()
			visible = true
			showing = true
	
	if Input.is_action_just_pressed("Cancel") && showing:
		animation_player.play("hide")
		showing = false
