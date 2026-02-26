class_name TransformStateSaver extends Node

@export var transformArrayData:TransformArrayData
@export var targetNodes:Array[Node2D] = []

func _ready() -> void:
	if(transformArrayData.PositionArray.size() != targetNodes.size()): SaveData()
	
	for i in range(transformArrayData.PositionArray.size()):
		targetNodes.get(i).global_position = transformArrayData.PositionArray.get(i)
		targetNodes.get(i).global_rotation = transformArrayData.RotationArray.get(i)
		
func SaveData() -> void:
	transformArrayData.PositionArray = []
	transformArrayData.RotationArray = []
	for node in targetNodes:
		transformArrayData.PositionArray.push_back(node.global_position)
		transformArrayData.RotationArray.push_back(node.global_rotation)
