extends CanvasLayer

@export var incorrectColor:Color = Color.DARK_RED
@export var incorrectString:String = "Vários carimbos estão incorretos"
@export var almostColor:Color = Color.YELLOW
@export var almostString:String = "Dois ou menos carimbos estão incorretos"
@export var correctColor:Color = Color.DARK_GREEN
@export var correctString:String = "Todos os carimbos estão corretos!"

@export var editableStamps:Array[EditableStamp]

@onready var panel_container: Control = $Panel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var feedback_text: Label = $Panel/feedbackText
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var showing = false

func _ready() -> void:
	panel_container.visible = false
	UpdateFeedbackText()
	for stamp in editableStamps:
		stamp.OnUpdateIsCorrect.connect(UpdateFeedbackText)
		stamp.OnButtonClick.connect(ClickSFX)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("journal") && !GlobalResources.player.in_menu:
		if showing:
			animation_player.play("hide")
			GlobalResources.GLOBAL_EVENTS.JournalClose.emit()
			showing = false
		else:
			if(GlobalResources.player.is_interacting):return
			
			animation_player.play("show")
			GlobalResources.GLOBAL_EVENTS.JournalOpen.emit()
			UpdateFeedbackText()
			visible = true
			showing = true
	
	if Input.is_action_just_pressed("Cancel") && showing:
		animation_player.play("hide")
		GlobalResources.GLOBAL_EVENTS.JournalClose.emit()
		showing = false

func UpdateFeedbackText() -> void:
	var correctCount = 0
	for stamp in editableStamps:
		if(stamp.isCorrect):
			correctCount += 1
	if(correctCount >= editableStamps.size()):
		feedback_text.label_settings.font_color = correctColor
		feedback_text.text = correctString
	elif correctCount >= editableStamps.size() / 2:
		feedback_text.label_settings.font_color = almostColor
		feedback_text.text = almostString
	else:
		feedback_text.label_settings.font_color = incorrectColor
		feedback_text.text = incorrectString

func ClickSFX() -> void:
	audio_stream_player.play()
