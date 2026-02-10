extends Node2D

@onready var back_left_button = $BackLeftButton
@onready var label_contatore_prese = $ContenitoreContatorePrese/LabelContatorePrese
@onready var label_contatore_lampadine = $ContenitoreContatoreLampadine/LabelContatoreLampadine
@onready var label_contatore_serrature = $ContenitoreContatoreSerrature/LabelContatoreSerrature
@onready var label_contatore_telecamere = $ContenitoreContatoreTelecamere/LabelContatoreTelecamere
@onready var anim_camion = $Camion/AnimationSpedizioneCamion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.avvia_spedizioni()
	
	aggiorna_contatori()
	Global.parti_spedizione.connect(_start_animazione)
	

func _start_animazione():
	anim_camion.play("spedizione")
	aggiorna_contatori()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func aggiorna_contatori():
	label_contatore_prese.text = str(Global.prese_in_magazzino)
	label_contatore_lampadine.text = str(Global.lampadine_in_magazzino)
	label_contatore_serrature.text = str(Global.serrature_in_magazzino)
	label_contatore_telecamere.text = str(Global.telecamere_in_magazzino)

func _on_back_left_button_pressed() -> void:
	back_left_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	back_left_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
