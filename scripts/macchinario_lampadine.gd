extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinarioLampadine
@onready var anim_lampadina = $Lampadina/AnimationLampadina
@onready var anim_lucchetto = $Lucchetto/AnimationLucchetto
@onready var lampadina = $Lampadina
@onready var lucchetto = $Lucchetto

@export var texture_vuota : Texture2D
@export var texture_piena : Texture2D
@export var scatolo_lampadine : Node2D
@export var anim_scatolo : AnimationPlayer

@export var label_contatore_lampadine : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Global.lampadine_is_locked):
		await get_tree().create_timer(2.0).timeout
		anim_lucchetto.play("scomparsa")
		await anim_lucchetto.animation_finished # Aspetta che finisca
		Global.lampadine_is_locked = false
	material = null
	scatolo_lampadine.material = null
	lucchetto.visible = false
	Global.avvia_produzione_lampadine()
	start_produzione()
	aggiorna_interfaccia(Global.lampadine_in_sala_macchinari, Global.capienza_massima_lampadine)
	Global.produzione_lampadine_aggiornata.connect(_aggiorna_produzione)

func start_produzione():
	if(Global.lampadine_is_full):
		anim_macchinario.stop()
		anim_lampadina.stop()
		lampadina.visible = false
		scatolo_lampadine.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		lampadina.visible = true
		anim_macchinario.play("produzione")
		var timer = Global.timer_produzione_lampadine
		var tempo_corrente = timer.wait_time - timer.time_left
		anim_lampadina.play("spostamento_lampadina")
		anim_lampadina.seek(tempo_corrente, true)
		scatolo_lampadine.texture = texture_vuota

func _aggiorna_produzione(_quantita, _totale):
	aggiorna_interfaccia(_quantita, _totale)
	if(_quantita == _totale):
		anim_macchinario.stop()
		anim_lampadina.stop()
		lampadina.visible = false
		scatolo_lampadine.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		lampadina.visible = true
		anim_macchinario.play("produzione")
		anim_lampadina.play("spostamento_lampadina")
		scatolo_lampadine.texture = texture_vuota
		anim_scatolo.stop()
		

func aggiorna_interfaccia(quant, tot):
	label_contatore_lampadine.text = str(quant) + "/" + str(tot)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.raccogli_tutto_lampadine()
