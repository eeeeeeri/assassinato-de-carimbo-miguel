class_name EditableStamp extends TextureRect

@export var stampPartScene:PackedScene
@export var guessStamp:StampData
@export var correctStamps:Array[StampData]

@onready var age_container: TabContainer = $AgeContainer
@onready var profession_container: TabContainer = $MarkContainer
@onready var mark_container: TabContainer = $ProfessionContainer
@onready var birth_container: TabContainer = $birthContainer
@onready var family_container: TabContainer = $familyContainer

var tabContainers:Array[TabContainer] = []

var isCorrect:bool
signal OnUpdateIsCorrect
signal OnButtonClick

func _ready() -> void:
	tabContainers = [age_container, profession_container, mark_container, birth_container, family_container]
	
	for container in tabContainers:
		for img in container.get_children():
			img.queue_free()
	
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
	
	self.visibility_changed.connect(UpdateCurrentGuess)

func PressStampPart(containerIdx:int) -> void:
	OnButtonClick.emit()
	
	var container:TabContainer = tabContainers.get(containerIdx)
	
	if(container.current_tab < container.get_children().size() - 1):
		container.select_next_available()
	else: container.current_tab = 0
	
	guessStamp.Age = age_container.current_tab as StampsData.Age
	guessStamp.Profession = profession_container.current_tab as StampsData.Professions
	guessStamp.Mark = mark_container.current_tab as StampsData.Marks
	guessStamp.Birth = birth_container.current_tab as StampsData.Birth
	guessStamp.Family = family_container.current_tab as StampsData.Families
	
	isCorrect = CheckCorrectStamp()
	OnUpdateIsCorrect.emit()
	
func CheckCorrectStamp() -> bool:
	var correct = false
	for stamp in correctStamps:
		if(compareStamps(guessStamp, stamp)):
			correct = true
	return correct

func compareStamps(stamp1:StampData, stamp2:StampData) -> bool:
	return (stamp1.Age == stamp2.Age && stamp1.Profession == stamp2.Profession &&
	stamp1.Mark == stamp2.Mark && stamp1.Birth == stamp2.Birth &&
	stamp1.Family == stamp2.Family)

func UpdateCurrentGuess() -> void:
	if(!visible): return
	
	SetCurrentStamp(guessStamp)

func SetCurrentStamp(stamp:StampData) -> void:
	age_container.current_tab = stamp.Age
	guessStamp.Age = stamp.Age
	profession_container.current_tab = stamp.Profession
	guessStamp.Profession = stamp.Profession
	mark_container.current_tab = stamp.Mark
	guessStamp.Mark = stamp.Mark
	birth_container.current_tab = stamp.Birth
	guessStamp.Birth = stamp.Birth
	family_container.current_tab = stamp.Family
	guessStamp.Family = stamp.Family
	
	isCorrect = CheckCorrectStamp()
	OnUpdateIsCorrect.emit()
	
#func _input(event: InputEvent) -> void:
	#if(Input.is_key_pressed(KEY_B)):
		#SetCurrentStamp(correctStamps.get(0))
	#
	#if(Input.is_key_pressed(KEY_C)):
		#UpdateCurrentGuess()
