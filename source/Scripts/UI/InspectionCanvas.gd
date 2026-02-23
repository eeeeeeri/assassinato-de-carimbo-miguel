class_name InspectionCanvas extends Node

@export var TextInstanceScene:PackedScene
@export var FinalImageInstanceScene:PackedScene
@export var DialogButtonScene:PackedScene
@export var DialogButtonCoinScene:PackedScene
@export var ModularStampScene:PackedScene

@onready var _3d_object_panel: Control = $"3DObjectPanel"
@onready var object_cam_texture: TextureRect = $"3DObjectPanel/ObjectCamTexture"

@onready var text_panel: Control = $TextPanel
@onready var tab_container: TabContainer = $TextPanel/TabContainer
@onready var back_image: TextureRect = $TextPanel/BackImage
@onready var button_left: Button = $TextPanel/ButtonLeft
@onready var button_right: Button = $TextPanel/ButtonRight

const FINALIMAGENODE = "FinalImage"

@onready var dialog_panel: Control = $DialogPanel
@onready var character_portrait: TextureRect = $DialogPanel/CharacterPortrait
@onready var dialog_options: VBoxContainer = $DialogPanel/ColorRect/DialogOptions
@onready var dialog_label: Label = $DialogPanel/ColorRect/DialogLabel
@onready var character_name: Label = $DialogPanel/ColorRect/CharacterName
@onready var stamp_container: HBoxContainer = $DialogPanel/stampContainer

@onready var stamp_lock_panel: StampLockPanel = $StampLockPanel

var inDialog:bool
var currentCharacter:CharacterData
var currentDialog:DialogData
var currentDialogLineIndex:int
var textHasFinalImage:bool

var inspecting:bool

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.OnInspect3D.connect(Inspect3D)
	GlobalResources.GLOBAL_EVENTS.OnInteractInspectionText.connect(InspectText)
	GlobalResources.GLOBAL_EVENTS.OnStartDialog.connect(InteractCharacter)
	GlobalResources.GLOBAL_EVENTS.OnInspectStampLock.connect(InspectStampLock)
	
func Inspect3D(camTex:ViewportTexture) -> void:
	_3d_object_panel.visible = true
	object_cam_texture.texture = camTex
	
	inspecting = true
	
func InspectText(texts:Array[String], finalImage:Texture2D, backImage:Texture2D) -> void:
	textHasFinalImage = finalImage != null
	var i:int = 1
	for text in texts:
		var newText = TextInstanceScene.instantiate() as Label
		newText.text = text
		newText.name = str(i)
		tab_container.add_child(newText)
		i+=1
	if(textHasFinalImage):
		var newImageContainer = FinalImageInstanceScene.instantiate()
		var newImage = newImageContainer.find_child("FinalImage") as TextureRect
		newImageContainer.name = str(i)
		newImage.texture = finalImage
		tab_container.add_child(newImageContainer)
	back_image.visible = finalImage == null || texts.size() > 0
	back_image.texture = backImage
	tab_container.current_tab = 0
	button_left.visible = false
	button_right.visible = (texts.size() > 1 && !textHasFinalImage) || (texts.size() > 0 && textHasFinalImage)
	tab_container.tabs_visible = (texts.size() > 1 && !textHasFinalImage) || (texts.size() > 0 && textHasFinalImage)
	text_panel.visible = true
	
	inspecting = true
	
func _on_tab_container_tab_changed(tab: int) -> void:
	button_left.visible = tab > 0
	button_right.visible = tab < tab_container.get_children().size() - 1
	tab_container.tabs_visible = !textHasFinalImage || tab < tab_container.get_children().size() - 1
	
func InteractCharacter(character:CharacterData) -> void:
	currentCharacter = character
	character_portrait.texture = character.Portrait
	character_name.text = character.Name
	
	for child in dialog_options.get_children():
		child.queue_free()
	
	for option in character.Dialogs:
		if(option.disabled): continue
		var scene:PackedScene = DialogButtonScene
		if(option.requireCurrency): scene = DialogButtonCoinScene
		var newDialog:Button = scene.instantiate() as Button
		newDialog.text = option.dialogOption
		newDialog.pressed.connect(func():
			StartDialog(option))
		dialog_options.add_child(newDialog)
		option.currentInstance = newDialog
	dialog_panel.visible = true
	
	inspecting = true
	
	if(!character.PlayedInitialDialog && character.InitialDialog != null):
		StartDialog(character.InitialDialog)
		return
	
	dialog_options.visible = true
	dialog_label.visible = false
	
func StartDialog(dialog:DialogData) -> void:
	if(dialog.requireCurrency):
		if(GlobalResources.PLAYER_DATA.currencyAmount <= 0): return
		else: GlobalResources.PLAYER_DATA.RemoveCurrency()
		
	if(dialog.disableOnPlay && currentCharacter.Dialogs.has(dialog)):
		dialog.disabled = true
		if(dialog.currentInstance != null): dialog.currentInstance.queue_free()
	
	if(dialog.charResponses.size() == 0):
		dialog.onFinishDialog.emit()
		return
	
	inDialog = true
	currentDialog = dialog
	currentDialogLineIndex = 0
	
	dialog_label.text = currentDialog.charResponses.get(currentDialogLineIndex)
	if(currentDialog.responsePortraits.size() > currentDialogLineIndex && currentDialog.responsePortraits.get(currentDialogLineIndex) != null):
		character_portrait.texture = currentDialog.responsePortraits.get(currentDialogLineIndex)
	
	CheckForShowStamp()
	
	dialog_options.visible = false
	dialog_label.visible = true
	
func CheckForShowStamp() -> void:
	ClearStampsContainer()
	if(currentDialogLineIndex == currentDialog.showStampsLineIndex):
		for stamp in currentCharacter.Stamps:
			var stampInstance = ModularStampScene.instantiate() as ModularStamp
			stamp_container.add_child(stampInstance)
			stampInstance.SetupStamp(stamp)	

func ClearStampsContainer() -> void:
	for child in stamp_container.get_children():
		child.queue_free()
	
func NextDialog() -> void:
	if(currentDialogLineIndex >= currentDialog.charResponses.size() - 1):
		dialog_options.visible = true
		dialog_label.visible = false
		character_portrait.texture = currentCharacter.Portrait
		inDialog = false
		if(currentDialog == currentCharacter.InitialDialog):
			currentCharacter.PlayedInitialDialog = true
		currentDialog.onFinishDialog.emit()
		currentDialog = null
		ClearStampsContainer()
		return
	currentDialogLineIndex += 1
	dialog_label.text = currentDialog.charResponses.get(currentDialogLineIndex)
	if(currentDialog.responsePortraits.size() > currentDialogLineIndex && currentDialog.responsePortraits.get(currentDialogLineIndex) != null):
		character_portrait.texture = currentDialog.responsePortraits.get(currentDialogLineIndex)
	
	CheckForShowStamp()
	
func InspectStampLock(correctStamp:StampData, correctSignal:Signal) -> void:
	stamp_lock_panel.visible = true
	stamp_lock_panel.StartInspection(correctStamp, correctSignal)
	
	inspecting = true

func EndInspection() -> void:
	GlobalResources.GLOBAL_EVENTS.EndInspection.emit()
	
	_3d_object_panel.visible = false
	text_panel.visible = false
	dialog_panel.visible = false
	stamp_lock_panel.EndInspection()
	stamp_lock_panel.visible = false
	
	inDialog = false
	ClearStampsContainer()
	
	for child in tab_container.get_children():
		child.queue_free()
	
	inspecting = false
		
func _input(event: InputEvent) -> void:
	if(Input.is_action_just_released("Cancel")):
		if(inspecting):
			EndInspection()
	if(Input.is_action_just_released("AdvanceDialog") && inDialog):
		NextDialog()
