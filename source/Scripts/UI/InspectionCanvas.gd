extends Node

@export var TextInstanceScene:PackedScene

@onready var _3d_object_panel: Control = $"CanvasLayer/3DObjectPanel"
@onready var object_cam_texture: TextureRect = $"CanvasLayer/3DObjectPanel/ObjectCamTexture"

@onready var text_panel: Control = $CanvasLayer/TextPanel
@onready var tab_container: TabContainer = $CanvasLayer/TextPanel/TabContainer
@onready var button_left: Button = $CanvasLayer/TextPanel/ButtonLeft
@onready var button_right: Button = $CanvasLayer/TextPanel/ButtonRight

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.OnInspect3D.connect(Inspect3D)
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(EndInspection)
	GlobalResources.GLOBAL_EVENTS.OnInteractInspectionText.connect(InspectText)
	
func Inspect3D(camTex:ViewportTexture) -> void:
	_3d_object_panel.visible = true
	object_cam_texture.texture = camTex
	
func InspectText(texts:Array[String]) -> void:
	var i:int = 1
	for text in texts:
		var newText = TextInstanceScene.instantiate() as Label
		newText.text = text
		newText.name = str(i)
		tab_container.add_child(newText)
		i+=1
	text_panel.visible = true
	tab_container.current_tab = 0
	button_left.visible = false
	button_right.visible = texts.size() > 1
	tab_container.tabs_visible = texts.size() > 1
	
func EndInspection() -> void:
	_3d_object_panel.visible = false
	text_panel.visible = false
	
	for child in tab_container.get_children():
		child.queue_free()

func _on_tab_container_tab_changed(tab: int) -> void:
	button_left.visible = tab > 0
	button_right.visible = tab < tab_container.get_children().size() - 1
	
#provisório
func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("Cancel")):
		GlobalResources.GLOBAL_EVENTS.EndInspection.emit()
