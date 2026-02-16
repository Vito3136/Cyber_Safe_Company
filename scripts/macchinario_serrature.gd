extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinarioSerrature
@onready var anim_serratura = $Serratura/AnimationSerratura
@onready var anim_lucchetto = $Lucchetto/AnimationLucchetto
@onready var serratura = $Serratura
@onready var lucchetto = $Lucchetto

@export var texture_vuota : Texture2D
@export var texture_piena : Texture2D
@export var scatolo_serrature : Node2D
@export var anim_scatolo : AnimationPlayer

@export var label_contatore_serrature : Label

var animazioni_spostamento_serratura: Array[String] = ["spostamento_serratura_5", "spostamento_serratura_4", "spostamento_serratura_4", "spostamento_serratura_3"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Global.serrature_is_locked):
		return
	
	if(!Global.lucchetto_serrature_scomparso):
		anim_lucchetto.play("scomparsa")
		await anim_lucchetto.animation_finished # Aspetta che finisca
		Global.lucchetto_serrature_scomparso = true
	material = null
	scatolo_serrature.material = null
	lucchetto.visible = false
	Global.avvia_produzione_serrature()
	start_produzione()
	aggiorna_interfaccia(Global.serrature_in_sala_macchinari, Global.capienza_massima_per_livello[Global.livello_serrature])
	Global.produzione_serrature_aggiornata.connect(_aggiorna_produzione)

func start_produzione():
	if(Global.serrature_is_full):
		anim_macchinario.stop()
		anim_serratura.stop()
		serratura.visible = false
		scatolo_serrature.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		serratura.visible = true
		anim_macchinario.play("produzione")
		var timer = Global.timer_produzione_serrature
		var tempo_corrente = timer.wait_time - timer.time_left
		anim_serratura.play(animazioni_spostamento_serratura[Global.livello_serrature])
		anim_serratura.seek(tempo_corrente, true)
		scatolo_serrature.texture = texture_vuota

func _aggiorna_produzione(_quantita, _totale):
	aggiorna_interfaccia(_quantita, _totale)
	if(_quantita == _totale):
		anim_macchinario.stop()
		anim_serratura.stop()
		serratura.visible = false
		scatolo_serrature.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		serratura.visible = true
		anim_macchinario.play("produzione")
		anim_serratura.play(animazioni_spostamento_serratura[Global.livello_serrature])
		scatolo_serrature.texture = texture_vuota
		anim_scatolo.stop()
		

func aggiorna_interfaccia(quant, tot):
	label_contatore_serrature.text = str(quant) + "/" + str(tot)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.raccogli_tutto_serrature()
