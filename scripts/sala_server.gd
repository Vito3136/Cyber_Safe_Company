extends Node2D


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
