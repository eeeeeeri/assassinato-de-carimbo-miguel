class_name VisibleStateSaver extends Node

@export var boolArrayData:BoolArrayData
@export var targetNodes:Array[Node2D]

func _ready() -> void:
	if(boolArrayData.BoolArray.size() != targetNodes.size()): SaveData()
	
	for i in range(boolArrayData.BoolArray.size()):
		targetNodes.get(i).visible = boolArrayData.BoolArray.get(i)
		
	for node in targetNodes:
		node.visibility_changed.connect(SaveData)
		
func SaveData() -> void:
	boolArrayData.BoolArray = []
	for node in targetNodes:
		boolArrayData.BoolArray.push_back(node.visible)
	
	print(boolArrayData.BoolArray)
