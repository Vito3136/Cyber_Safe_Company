extends Node2D

@onready var back_left_button = $BackLeftButton

@onready var prese_label = $PreseLabel
@onready var lampadine_label = $LampadineLabel
@onready var telecamere_label = $TelecamereLabel
@onready var serrature_label = $SerratureLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!Global.tutorial_totale_effettuato):
		Global.tutorial_totale_effettuato = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!Global.prese_is_full):
		prese_label.visible = true
		var tempo_rimanente_presa = ceil(Global.timer_produzione_prese.time_left)
		prese_label.text = "%d  s" % tempo_rimanente_presa
	else:
		prese_label.visible = false

	if(Global.produzione_lampadine_avviata && !Global.lampadine_is_full):
		lampadine_label.visible = true
		var tempo_rimanente_lampadina = ceil(Global.timer_produzione_lampadine.time_left)
		lampadine_label.text = "%d  s" % tempo_rimanente_lampadina
	else:
		lampadine_label.visible = false

	if(Global.produzione_telecamere_avviata && !Global.telecamere_is_full):
		telecamere_label.visible = true
		var tempo_rimanente_telecamera = ceil(Global.timer_produzione_telecamere.time_left)
		telecamere_label.text = "%d  s" % tempo_rimanente_telecamera
	else:
		telecamere_label.visible = false

	if(Global.produzione_serrature_avviata && !Global.serrature_is_full):
		serrature_label.visible = true
		var tempo_rimanente_serratura = ceil(Global.timer_produzione_serrature.time_left)
		serrature_label.text = "%d  s" % tempo_rimanente_serratura
	else:
		serrature_label.visible = false


func _on_back_left_button_pressed() -> void:
	back_left_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	back_left_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
