extends Node

@onready var _3d_object_panel: Control = $"3DObjectPanel"
@onready var object_cam_texture: TextureRect = $"3DObjectPanel/ObjectCamTexture"

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.OnInspect3D.connect(Inspect3D)
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(EndInspection)
	
func Inspect3D(camTex:ViewportTexture) -> void:
	_3d_object_panel.visible = true
	object_cam_texture.texture = camTex
	
func EndInspection() -> void:
	_3d_object_panel.visible = false
