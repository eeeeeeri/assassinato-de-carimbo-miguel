extends CanvasLayer

const CULPADO = preload("uid://duu8ety807k0j")
const PORTRAIT_TEMP = preload("uid://bn720yj88xobh")

@onready var panel_container: PanelContainer = $PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var suspeitos_grid: GridContainer = $PanelContainer/VBoxContainer/Suspeitos
@onready var confirm: HBoxContainer = $PanelContainer/VBoxContainer/Confirm
@onready var sim: Button = $PanelContainer/VBoxContainer/Confirm/Sim
@onready var nao: Button = $PanelContainer/VBoxContainer/Confirm/Nao
@onready var culpado_select: Button = $PanelContainer/VBoxContainer/CulpadoSelect
@onready var culpados_box: GridContainer = $PanelContainer/VBoxContainer/Culpados/CulpadosContainer
@onready var click: AudioStreamPlayer = $Click

var showing = false
var suspeitos = []
var culpados = []
var confirming = false
var lockedin := false

func _ready() -> void:
	panel_container.visible = false
	for i in suspeitos_grid.get_children():
		suspeitos.append(i)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select_culpado") && !lockedin:
		if showing:
			animation_player.play("hide")
			GlobalResources.GLOBAL_EVENTS.SusClose.emit()
			showing = false
		else:
			if(GlobalResources.player.is_interacting):return
			
			animation_player.play("show")
			GlobalResources.GLOBAL_EVENTS.SusOpen.emit()
			visible = true
			showing = true
	
	if Input.is_action_just_pressed("Cancel") && showing && !lockedin:
		animation_player.play("hide")
		GlobalResources.GLOBAL_EVENTS.SusClose.emit()
		showing = false


func _shake(value: float) -> void:
	for i in culpados:
		i.shake(value)


func _on_culpado_select_button_up() -> void:
	click.play()
	for i in suspeitos:
		if i.selected:
			var culpado = CULPADO.instantiate()
			culpado.sus_name = i.sus_name
			culpado.sus_sprite = i.sus_sprite
			culpados.append(culpado)
	if !culpados.is_empty():
		for i in culpados:
			culpados_box.add_child(i)
		animation_player.play("confirm")


func _on_nao_button_up() -> void:
	click.play()
	for i in culpados_box.get_children():
		culpados_box.remove_child(i)
	culpados.clear()
	for i in suspeitos:
		i._unselected()
	animation_player.play("RESET")


func _on_sim_button_up() -> void:
	click.play()
	lockedin = true
	var correct = 0
	var incorrect = 0
	Music._mute()
	for i in culpados:
		if i.sus_name == "Cadu" or i.sus_name == "Armando":
			correct += 1
		else:
			incorrect += 1
	if correct == 2 && incorrect == 0:
		animation_player.play("success")
	else:
		animation_player.play("failed")
