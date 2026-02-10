extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinarioTelecamere
@onready var anim_telecamera = $Telecamera/AnimationTelecamera
@onready var anim_lucchetto = $Lucchetto/AnimationLucchetto
@onready var telecamera = $Telecamera
@onready var lucchetto = $Lucchetto

@export var texture_vuota : Texture2D
@export var texture_piena : Texture2D
@export var scatolo_telecamere : Node2D
@export var anim_scatolo : AnimationPlayer

@export var label_contatore_telecamere : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Global.telecamere_is_locked):
		await get_tree().create_timer(2.0).timeout
		anim_lucchetto.play("scomparsa")
		await anim_lucchetto.animation_finished # Aspetta che finisca
		Global.telecamere_is_locked = false
	material = null
	scatolo_telecamere.material = null
	lucchetto.visible = false
	Global.avvia_produzione_telecamere()
	start_produzione()
	aggiorna_interfaccia(Global.telecamere_in_sala_macchinari, Global.capienza_massima_telecamere)
	Global.produzione_telecamere_aggiornata.connect(_aggiorna_produzione)

func start_produzione():
	if(Global.telecamere_is_full):
		anim_macchinario.stop()
		anim_telecamera.stop()
		telecamera.visible = false
		scatolo_telecamere.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		telecamera.visible = true
		anim_macchinario.play("produzione")
		var timer = Global.timer_produzione_telecamere
		var tempo_corrente = timer.wait_time - timer.time_left
		anim_telecamera.play("spostamento_telecamera")
		anim_telecamera.seek(tempo_corrente, true)
		scatolo_telecamere.texture = texture_vuota

func _aggiorna_produzione(_quantita, _totale):
	aggiorna_interfaccia(_quantita, _totale)
	if(_quantita == _totale):
		anim_macchinario.stop()
		anim_telecamera.stop()
		telecamera.visible = false
		scatolo_telecamere.texture = texture_piena
		anim_scatolo.play("scatolo_pieno")
	else:
		telecamera.visible = true
		anim_macchinario.play("produzione")
		anim_telecamera.play("spostamento_telecamera")
		scatolo_telecamere.texture = texture_vuota
		anim_scatolo.stop()
		

func aggiorna_interfaccia(quant, tot):
	label_contatore_telecamere.text = str(quant) + "/" + str(tot)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.raccogli_tutto_telecamere()
