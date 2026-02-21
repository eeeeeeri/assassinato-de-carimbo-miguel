class_name StampLockPanel extends Control

@export var stampPartScene:PackedScene
@export var buttons:Array[TextureButton]

@onready var inspection_canvas_layer: InspectionCanvas = $".."

@onready var age_container: TabContainer = $Padlock/AgeContainer
@onready var profession_container: TabContainer = $Padlock/ProfessionContainer
@onready var mark_container: TabContainer = $Padlock/MarkContainer
@onready var birth_container: TabContainer = $Padlock/birthContainer
@onready var family_container: TabContainer = $Padlock/familyContainer

@onready var check_timer: Timer = $CheckTimer
@onready var animation_player: AnimationPlayer = $lock/AnimationPlayer

var tabContainers:Array[TabContainer] = []
var correctStamp:StampData
var correctSignal:Signal

func _ready() -> void:
	tabContainers = [age_container, profession_container, mark_container, birth_container, family_container]
	
	for age in GlobalResources.STAMPS_DATA.AgeSymbols.values():
		var newImg:TextureRect = stampPartScene.instantiate() as TextureRect
		newImg.texture = age
		age_container.add_child(newImg)
	
	for profession in GlobalResources.STAMPS_DATA.ProfessionSymbols.values():
		var newImg:TextureRect = stampPartScene.instantiate() as TextureRect
		newImg.texture = profession
		profession_container.add_child(newImg)
		
	for mark in GlobalResources.STAMPS_DATA.MarkSymbols.values():
		var newImg:TextureRect = stampPartScene.instantiate() as TextureRect
		newImg.texture = mark
		mark_container.add_child(newImg)
		
	for birth in GlobalResources.STAMPS_DATA.BirthSymbols.values():
		var newImg:TextureRect = stampPartScene.instantiate() as TextureRect
		newImg.texture = birth
		birth_container.add_child(newImg)
	
	for family in GlobalResources.STAMPS_DATA.FamiliesSymbols.values():
		var newImg:TextureRect = stampPartScene.instantiate() as TextureRect
		newImg.texture = family
		family_container.add_child(newImg)
		
	check_timer.timeout.connect(CheckCorrectStamp)

func StartInspection(_correctStamp:StampData, _correctSignal:Signal) -> void:
	correctStamp = _correctStamp
	correctSignal = _correctSignal
	
	for button in buttons:
			button.disabled = false
	
	check_timer.start()
	
func EndInspection() -> void:
	for container in tabContainers:
		container.current_tab = 0

func PressStampPart(containerIdx:int) -> void:
	var container:TabContainer = tabContainers.get(containerIdx)
	
	if(container.current_tab < container.get_children().size() - 1):
		container.select_next_available()
	else: container.current_tab = 0
	
	check_timer.start()
	
func CheckCorrectStamp() -> void:
	if(age_container.current_tab == correctStamp.Age && profession_container.current_tab == correctStamp.Profession &&
	mark_container.current_tab == correctStamp.Mark && birth_container.current_tab == correctStamp.Birth &&
	family_container.current_tab == correctStamp.Family):
		for button in buttons:
			button.disabled = true
		
		animation_player.play("lockOpen")
		animation_player.animation_finished.connect(func(animName:String):
			if(animName == "lockOpen"):
				correctSignal.emit()
				inspection_canvas_layer.EndInspection())
	
