extends TextureButton

@export var hoverTint:Color
@export var hoverScale:Vector2
@export var pressTint:Color
@export var pressScale:Vector2

@export var tweenDuration:float = 0.1

var defaultTint:Color
var defaultScale:Vector2

var scaleTween:Tween
var mouseHover:bool
var buttonPressed:bool

func _ready() -> void:
	defaultTint = modulate
	defaultScale = scale

func _on_button_down() -> void:
	buttonPressed = true
	
	if(scaleTween): scaleTween.kill()
	scaleTween = create_tween()
	scaleTween.tween_property(self, "scale", defaultScale * pressScale, tweenDuration)
	
	modulate = pressTint


func _on_button_up() -> void:
	buttonPressed = false
	
	var sValue:Vector2
	var tValue:Color
	if(mouseHover): 
		sValue = defaultScale * hoverScale
		tValue = hoverTint
	else:
		sValue = defaultScale
		tValue = defaultTint
	if(scaleTween): scaleTween.kill()
	scaleTween = create_tween()
	scaleTween.tween_property(self, "scale", sValue, tweenDuration)
	
	modulate = tValue


func _on_mouse_entered() -> void:
	mouseHover = true
	
	if(buttonPressed): return
	
	if(scaleTween): scaleTween.kill()
	scaleTween = create_tween()
	scaleTween.tween_property(self, "scale", defaultScale * hoverScale, tweenDuration)
	
	modulate = hoverTint


func _on_mouse_exited() -> void:
	mouseHover = false
	
	if(buttonPressed): return
	
	if(scaleTween): scaleTween.kill()
	scaleTween = create_tween()
	scaleTween.tween_property(self, "scale", defaultScale, tweenDuration)
	
	modulate = defaultTint
