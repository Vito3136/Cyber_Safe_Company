extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinarioPrese
@onready var anim_presa = $Presa/AnimationPresa
@onready var presa = $Presa

@export var texture_vuota : Texture2D
@export var texture_piena : Texture2D
@export var scatolo_prese : Node2D
@export var anim_scatolo : AnimationPlayer

@export var label_contatore_prese : Label

var animazioni_spostamento_presa: Array[String] = ["spostamento_presa_5", "spostamento_presa_4", "spostamento_presa_4", "spostamento_presa_3"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.avvia_produzione_prese()
	start_produzione()
	aggiorna_interfaccia(Global.prese_in_sala_macchinari, Global.capienza_massima_per_livello[Global.livello_prese])
	Global.produzione_prese_aggiornata.connect(_aggiorna_produzione)

func start_produzione():
	if(Global.prese_is_full):
		anim_macchinario.stop()
		anim_presa.stop()
		presa.visible = false
		scatolo_prese.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		presa.visible = true
		anim_macchinario.play("produzione")
		var timer = Global.timer_produzione_prese
		var tempo_corrente = timer.wait_time - timer.time_left
		anim_presa.play(animazioni_spostamento_presa[Global.livello_prese])
		anim_presa.seek(tempo_corrente, true)
		scatolo_prese.texture = texture_vuota

func _aggiorna_produzione(_quantita, _totale):
	aggiorna_interfaccia(_quantita, _totale)
	if(_quantita == _totale):
		anim_macchinario.stop()
		anim_presa.stop()
		presa.visible = false
		scatolo_prese.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		presa.visible = true
		anim_macchinario.play("produzione")
		anim_presa.play(animazioni_spostamento_presa[Global.livello_prese])
		scatolo_prese.texture = texture_vuota
		anim_scatolo.stop()
		

func aggiorna_interfaccia(quant, tot):
	label_contatore_prese.text = str(quant) + "/" + str(tot)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.raccogli_tutto_prese()
