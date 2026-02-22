extends CanvasLayer

@onready var bg: ColorRect = $BG
@onready var sub_viewport: SubViewportContainer = $SubViewportContainer
@onready var player: CharacterBody2D = $".."

var bg_tween : Tween
var scale_tween : Tween
var showing = false

func _ready() -> void:
	visible = true
	sub_viewport.scale = Vector2(0.0,0.0)
	bg.color.a = .0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		if showing:
			hide_map()
			GlobalResources.GLOBAL_EVENTS.MapClose.emit()
			showing = false
		else:
			show_map()
			GlobalResources.GLOBAL_EVENTS.MapOpen.emit()
			showing = true
	
	if Input.is_action_just_pressed("Cancel") && showing:
		hide_map()
		showing = false

func show_map() -> void:
	if bg_tween: bg_tween.kill()
	if scale_tween: scale_tween.kill()
	
	sub_viewport.scale = Vector2(0.0,0.0)
	bg.color.a = .0
	
	scale_tween = create_tween().set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(sub_viewport,"scale",Vector2(1.0,1.0),.2)
	
	bg_tween = create_tween().set_trans(Tween.TRANS_SINE)
	bg_tween.tween_property(bg,"color:a",.5,.2)

func hide_map() -> void:
	if bg_tween: bg_tween.kill()
	if scale_tween: scale_tween.kill()
	
	sub_viewport.scale = Vector2(1.0,1.0)
	bg.color.a = .5
	
	scale_tween = create_tween().set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(sub_viewport,"scale",Vector2(0.0,0.0),.2)
	
	bg_tween = create_tween().set_trans(Tween.TRANS_SINE)
	bg_tween.tween_property(bg,"color:a",.0,.2)
