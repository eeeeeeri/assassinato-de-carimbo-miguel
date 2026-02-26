extends Interactable

@export var window:PackedScene
@export var popupDuration:float = 0.25
@onready var close: AudioStreamPlayer = $Close

var currentWindow:AmbientWindow
var popupPositionTween:Tween
var popupScaleTween:Tween

func _interacted(override:bool = false) -> void:
	if(!override && GlobalResources.player.is_interacting):return
	
	super(override)
	currentWindow = window.instantiate() as AmbientWindow
	currentWindow.scale = Vector2(0.01, 0.01)
	currentWindow.global_position = global_position
	get_tree().root.add_child(currentWindow)
	
	var targetPosition = GlobalResources.player.camera_2d.get_screen_center_position()
	if(popupPositionTween): popupPositionTween.kill()
	popupPositionTween = create_tween()
	popupPositionTween.tween_property(currentWindow,"global_position", targetPosition, popupDuration)
	
	if(popupScaleTween): popupScaleTween.kill()
	popupScaleTween = create_tween()
	popupScaleTween.tween_property(currentWindow,"scale", Vector2.ONE, popupDuration)
		
	
func end_inspection() -> void:
	if(currentWindow != null && currentWindow.isInteracting): return
	
	super()
	if(currentWindow != null):
		close.play()
		currentWindow.queue_free()
