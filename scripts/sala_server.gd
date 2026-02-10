extends Node2D

@onready var back_left_button = $BackLeftButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_upgrade_button_pressed() -> void:
	# Ottieni il riferimento al nodo PopupPanel
	# $UpgradePopup usa il percorso breve del nodo figlio.
	var upgrade_popup = $UpgradePopup.open_popup()

	# Controlla se il popup esiste ed è istanziato
	if upgrade_popup:
		# Questo metodo mostra il popup e lo centra sullo schermo.
		# Usa i margini che hai impostato per occupare i 3/4 dello schermo.
		upgrade_popup.popup_centered()

func _on_back_left_button_pressed() -> void:
	back_left_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	back_left_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
