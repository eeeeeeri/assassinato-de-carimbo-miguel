extends AudioStreamPlayer

var tween : Tween

func _ready() -> void:
	GlobalResources.GLOBAL_EVENTS.UpdateMusic.connect(_update_music)

func _update_music(audio : AudioStream):
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"volume_linear",0.0,.5)
	await tween.finished
	stream = audio
	volume_db = -10
	play()

func _mute():
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"volume_linear",0.0,.5)
