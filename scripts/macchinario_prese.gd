extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinarioPrese
@onready var anim_presa = $Presa/AnimationPresa
@onready var presa = $Presa

# 1. Creiamo due variabili "esportate". 
# Questo farà apparire due caselle vuote nell'Inspector di Godot!
@export var texture_vuota : Texture2D
@export var texture_piena : Texture2D
@export var scatolo_prese : Node2D
@export var anim_scatolo : AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_produzione()
	await get_tree().create_timer(9.0).timeout
	stop_produzione()

func start_produzione():
	presa.visible = true
	anim_macchinario.play("produzione")
	anim_presa.play("spostamento_presa")
	scatolo_prese.texture = texture_vuota

func stop_produzione():
	anim_macchinario.stop()
	anim_presa.stop()
	presa.visible = false
	scatolo_prese.texture = texture_piena
	anim_scatolo.play("scatolo_pieno")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
