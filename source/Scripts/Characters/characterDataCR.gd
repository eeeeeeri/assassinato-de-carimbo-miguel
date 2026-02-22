class_name CharacterData extends Resource
	
@export var Name:String
@export var Portrait:Texture2D
@export var Stamps:Array[StampData]
@export var InitialDialog:DialogData
@export var Dialogs:Array[DialogData]

var PlayedInitialDialog:bool
