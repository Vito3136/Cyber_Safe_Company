extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinario
@onready var anim_lampadina = $Lampadina/AnimationLampadina
@onready var anim_lucchetto = $Lock/AnimationLucchetto
@onready var lampadina = $Lampadina
@onready var lucchetto = $Lock

# Variabile per sapere se è bloccato (utile per impedire il click)
var is_locked = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ovviamente rimuovere il wait seguente
	await get_tree().create_timer(2.0).timeout
	sblocca_macchinario()

func start_produzione():
	anim_lucchetto.play("scomparsa")
	anim_macchinario.play("produzione")
	anim_lampadina.play("spostamento_lampadina")
	await anim_lucchetto.animation_finished # Aspetta che finisca
	lucchetto.visible = false

func sblocca_macchinario():
	is_locked = false
	# Mettendo il materiale a "null", rimuoviamo lo shader e torna l'immagine originale
	material = null 
	lampadina.visible = true
	start_produzione()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
