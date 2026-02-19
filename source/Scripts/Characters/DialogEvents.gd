extends Node

@export var SourceDialog:DialogData

signal DialogEnd

func _ready() -> void:
	SourceDialog.onFinishDialog.connect(func(): 
		DialogEnd.emit())
		
