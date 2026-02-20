class_name Inspector extends Node

@onready var sub_viewport: SubViewport = $SubViewport
@onready var inspection_camera: Camera3D = $SubViewport/InspectionCamera
@onready var object_parent_point: Node3D = $SubViewport/ObjectParentPoint

@export var RotationSensitivity:float = 1
@export var ZoomSensitivity:float = 8

@export var PopupAnimDuration:float = .2

var currentInspectable:Inspectable
var scaleTween:Tween
var initialized:bool
var mouseDelta:Vector2

func _ready() -> void:
	object_parent_point.scale = Vector3(.01, .01, .01)
	sub_viewport.size = DisplayServer.window_get_size()
	GlobalResources.GLOBAL_EVENTS.OnInteractInspection3D.connect(StartInspection)
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(EndInspection)

func StartInspection(inspectableScene:PackedScene) -> void:
	GlobalResources.GLOBAL_EVENTS.OnInspect3D.emit(sub_viewport.get_texture())
	initialized = false
	currentInspectable = inspectableScene.instantiate() as Inspectable
	if(currentInspectable == null): return
	
	object_parent_point.global_rotation_degrees = Vector3.ZERO
	object_parent_point.global_position = inspection_camera.global_position + -inspection_camera.global_basis.z.normalized() * currentInspectable.defaultCameraDistance
	object_parent_point.add_child(currentInspectable)
	object_parent_point.scale = Vector3(.01, .01, .01)
	if(scaleTween): scaleTween.kill()
	scaleTween = create_tween()
	scaleTween.tween_property(object_parent_point, "scale", Vector3.ONE, PopupAnimDuration).finished.connect(func():
		initialized = true)
	
func  EndInspection() -> void:
	initialized = false
	if(currentInspectable != null): currentInspectable.queue_free()
	
	#if(scaleTween): scaleTween.kill()
	#scaleTween = create_tween()
	#scaleTween.tween_property(object_parent_point, "scale", Vector3(.01, .01, .01), PopupAnimDuration).finished.connect(func():
		#currentInspectable.queue_free()
		#GlobalResources.GLOBAL_EVENTS.EndInspection.emit())
	
func _input(event: InputEvent) -> void:
	if(currentInspectable == null): return
	
	if(event is InputEventMouseMotion):
		mouseDelta = event.relative
		
func _process(delta: float) -> void:
	if(currentInspectable == null || !initialized): return
	
	if(initialized && Input.is_action_pressed("InspectRotate")):
		object_parent_point.rotate(inspection_camera.global_basis.y, delta * mouseDelta.x * RotationSensitivity)
		object_parent_point.rotate(inspection_camera.global_basis.x, delta * mouseDelta.y * RotationSensitivity)
	
	var scrollValue = 0
	if(Input.is_action_just_released("InspectZoomUp")): scrollValue = 1
	if(Input.is_action_just_released("InspectZoomDown")): scrollValue = -1
	
	var zoomMoveAmount = scrollValue * delta * ZoomSensitivity
	var currentDistance = object_parent_point.global_position.distance_to(inspection_camera.global_position)
	var newDistance = currentDistance - zoomMoveAmount
	newDistance = clamp(newDistance, currentInspectable.minCameraDistance, currentInspectable.maxCameraDistance)

	object_parent_point.global_position = inspection_camera.global_position + -inspection_camera.global_basis.z.normalized() * newDistance
			
	mouseDelta = Vector2.ZERO
