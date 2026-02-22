class_name DialogData extends Resource

@export var dialogOption:String
@export var charResponses:Array[String]
@export var responsePortraits:Array[Texture2D]
@export var requireCurrency:bool
@export var disableOnPlay:bool
@export var showStampsLineIndex:int = -1

var disabled:bool
var currentInstance:Node

signal onFinishDialog
