extends Node2D

@onready var back_left_button = $BackLeftButton
@onready var label_contatore_prese = $ContenitoreContatorePrese/LabelContatorePrese
@onready var label_contatore_lampadine = $ContenitoreContatoreLampadine/LabelContatoreLampadine
@onready var label_contatore_serrature = $ContenitoreContatoreSerrature/LabelContatoreSerrature
@onready var label_contatore_telecamere = $ContenitoreContatoreTelecamere/LabelContatoreTelecamere
@onready var anim_camion = $Camion/AnimationSpedizioneCamion
@onready var timer_label = $TimerLabel

@onready var upgrade_button = $UpgradeButton
@onready var upgrade_popup = $UpgradePopup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aggiorna_animazione_camion()
	aggiorna_contatori()
	Global.parti_spedizione.connect(_start_animazione)

func _start_animazione():
	anim_camion.play("spedizione")
	aggiorna_contatori()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tempo_rimanente = ceil(Global.timer_spedizione.time_left)
	timer_label.text = "Next shipment in: %d s" % tempo_rimanente
	
func _on_upgrade_button_pressed() -> void:
	upgrade_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	upgrade_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	# Ottieni il riferimento al nodo PopupPanel
	# $UpgradePopup usa il percorso breve del nodo figlio.
	var popup = upgrade_popup.open_popup()

	# Controlla se il popup esiste ed è istanziato
	if popup:
		# Questo metodo mostra il popup e lo centra sullo schermo.
		# Usa i margini che hai impostato per occupare i 3/4 dello schermo.
		popup.popup_centered()

func aggiorna_contatori():
	label_contatore_prese.text = str(Global.prese_in_magazzino)
	label_contatore_lampadine.text = str(Global.lampadine_in_magazzino)
	label_contatore_serrature.text = str(Global.serrature_in_magazzino)
	label_contatore_telecamere.text = str(Global.telecamere_in_magazzino)

func aggiorna_animazione_camion():
	var stato_timer_animazione = Global.timer_spedizione.time_left - Global.timer_animazione_spedizione.time_left
	print(str(stato_timer_animazione))
	if(stato_timer_animazione < 5):
		var seek_animazione = Global.timer_animazione_spedizione.wait_time - Global.timer_animazione_spedizione.time_left
		print(str(seek_animazione))
		anim_camion.play("spedizione")
		anim_camion.seek(seek_animazione, true)

func _on_back_left_button_pressed() -> void:
	back_left_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	back_left_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
