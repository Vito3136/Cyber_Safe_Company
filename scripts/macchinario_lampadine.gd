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

var animazioni_spostamento_lampadina: Array[String] = ["spostamento_lampadina_5", "spostamento_lampadina_4", "spostamento_lampadina_4", "spostamento_lampadina_3"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Global.lampadine_is_locked):
		return
	
	if(Global.lucchetto_lampadine_scomparso):
		anim_lucchetto.play("scomparsa")
		await anim_lucchetto.animation_finished # Aspetta che finisca
		Global.lucchetto_lampadine_scomparso = true
	material = null
	scatolo_lampadine.material = null
	lucchetto.visible = false
	Global.avvia_produzione_lampadine()
	start_produzione()
	aggiorna_interfaccia(Global.lampadine_in_sala_macchinari, Global.capienza_massima_per_livello[Global.livello_lampadine])
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
		anim_lampadina.play(animazioni_spostamento_lampadina[Global.livello_lampadine])
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
		anim_lampadina.play(animazioni_spostamento_lampadina[Global.livello_lampadine])
		scatolo_lampadine.texture = texture_vuota
		anim_scatolo.stop()

func aggiorna_interfaccia(quant, tot):
	label_contatore_lampadine.text = str(quant) + "/" + str(tot)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.raccogli_tutto_lampadine()
