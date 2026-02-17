extends Node

@export var TextInstanceScene:PackedScene
@export var DialogButtonScene:PackedScene

@onready var _3d_object_panel: Control = $"CanvasLayer/3DObjectPanel"
@onready var object_cam_texture: TextureRect = $"CanvasLayer/3DObjectPanel/ObjectCamTexture"

@onready var text_panel: Control = $CanvasLayer/TextPanel
@onready var tab_container: TabContainer = $CanvasLayer/TextPanel/TabContainer
@onready var button_left: Button = $CanvasLayer/TextPanel/ButtonLeft
@onready var button_right: Button = $CanvasLayer/TextPanel/ButtonRight

@onready var dialog_panel: Control = $CanvasLayer/DialogPanel
@onready var character_portrait: TextureRect = $CanvasLayer/DialogPanel/CharacterPortrait
@onready var dialog_options: VBoxContainer = $CanvasLayer/DialogPanel/ColorRect/DialogOptions
@onready var dialog_label: Label = $CanvasLayer/DialogPanel/ColorRect/DialogLabel
@onready var character_name: Label = $CanvasLayer/DialogPanel/ColorRect/CharacterName

var inDialog:bool
var currentCharacter:CharacterData
var currentDialog:DialogData
var currentDialogLineIndex:int

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.OnInspect3D.connect(Inspect3D)
	GlobalResources.GLOBAL_EVENTS.EndInspection.connect(EndInspection)
	GlobalResources.GLOBAL_EVENTS.OnInteractInspectionText.connect(InspectText)
	GlobalResources.GLOBAL_EVENTS.OnStartDialog.connect(InteractCharacter)
	
func Inspect3D(camTex:ViewportTexture) -> void:
	_3d_object_panel.visible = true
	object_cam_texture.texture = camTex
	
func InspectText(texts:Array[String]) -> void:
	var i:int = 1
	for text in texts:
		var newText = TextInstanceScene.instantiate() as Label
		newText.text = text
		newText.name = str(i)
		tab_container.add_child(newText)
		i+=1
	text_panel.visible = true
	tab_container.current_tab = 0
	button_left.visible = false
	button_right.visible = texts.size() > 1
	tab_container.tabs_visible = texts.size() > 1
	
func InteractCharacter(character:CharacterData) -> void:
	currentCharacter = character
	character_portrait.texture = character.Portrait
	character_name.text = character.Name
	
	for child in dialog_options.get_children():
		child.queue_free()
	
	for option in character.Dialogs:
		var newDialog:Button = DialogButtonScene.instantiate() as Button
		newDialog.text = option.dialogOption
		newDialog.pressed.connect(func():
			StartDialog(option))
		dialog_options.add_child(newDialog)
	dialog_panel.visible = true
	dialog_options.visible = true
	dialog_label.visible = false
	
func StartDialog(dialog:DialogData) -> void:
	inDialog = true
	currentDialog = dialog
	currentDialogLineIndex = 0
	
	dialog_label.text = currentDialog.charResponses.get(currentDialogLineIndex)
	if(currentDialog.responsePortraits.size() > currentDialogLineIndex && currentDialog.responsePortraits.get(currentDialogLineIndex) != null):
		character_portrait.texture = currentDialog.responsePortraits.get(currentDialogLineIndex)
	
	dialog_options.visible = false
	dialog_label.visible = true
	
func NextDialog() -> void:
	if(currentDialogLineIndex >= currentDialog.charResponses.size() - 1):
		dialog_options.visible = true
		dialog_label.visible = false
		character_portrait.texture = currentCharacter.Portrait
		inDialog = false
		currentDialog = null
		return
	currentDialogLineIndex += 1
	dialog_label.text = currentDialog.charResponses.get(currentDialogLineIndex)
	if(currentDialog.responsePortraits.size() > currentDialogLineIndex && currentDialog.responsePortraits.get(currentDialogLineIndex) != null):
		character_portrait.texture = currentDialog.responsePortraits.get(currentDialogLineIndex)
	
func EndInspection() -> void:
	_3d_object_panel.visible = false
	text_panel.visible = false
	dialog_panel.visible = false
	
	inDialog = false
	
	for child in tab_container.get_children():
		child.queue_free()

func _on_tab_container_tab_changed(tab: int) -> void:
	button_left.visible = tab > 0
	button_right.visible = tab < tab_container.get_children().size() - 1
	
#provisório
func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("Cancel")):
		GlobalResources.GLOBAL_EVENTS.EndInspection.emit()
	if(Input.is_action_just_pressed("AdvanceDialog") && inDialog):
		NextDialog()
