extends CPUParticles2D

@onready var huh_sound: AudioStreamPlayer = $HuhSound

func _ready() -> void:
	huh_sound.play()
	emitting = true

func _on_finished() -> void:
	queue_free()
