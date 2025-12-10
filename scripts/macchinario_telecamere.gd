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

# Variabile per sapere se è bloccato (utile per impedire il click)
var is_locked = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ovviamente rimuovere il wait seguente
	await get_tree().create_timer(2.0).timeout
	sblocca_macchinario()
	await get_tree().create_timer(9.0).timeout
	stop_produzione()
	

func start_produzione():
	anim_lucchetto.play("scomparsa")
	anim_macchinario.play("produzione")
	telecamera.visible = true
	anim_telecamera.play("spostamento_telecamera")
	scatolo_telecamere.texture = texture_vuota
	await anim_lucchetto.animation_finished # Aspetta che finisca
	lucchetto.visible = false

func sblocca_macchinario():
	is_locked = false
	material = null # Mettendo il materiale a "null", rimuoviamo lo shader e torna l'immagine originale
	scatolo_telecamere.material = null
	telecamera.visible = true
	start_produzione()

func stop_produzione():
	anim_macchinario.stop()
	anim_telecamera.stop()
	telecamera.visible = false
	scatolo_telecamere.texture = texture_piena
	anim_scatolo.play("scatolo_pieno")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
