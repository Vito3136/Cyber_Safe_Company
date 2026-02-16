extends Control

# Riferimenti ai nodi
@onready var bar_prod = $HBoxContainer/BarraProduzione
@onready var bar_sic = $HBoxContainer/BarraSicurezza


func _ready():
	# Impostiamo i massimi delle barre grafiche
	bar_prod.max_value = Global.max_tacchette
	bar_sic.max_value = Global.max_tacchette
	Global.update_barra_bilanciamento.connect(_aggiorna_grafica)
	_aggiorna_grafica()
	#await get_tree().create_timer(2.0).timeout
	#upgrade_produzione()
	#await get_tree().create_timer(2.0).timeout
	#upgrade_produzione()
	#await get_tree().create_timer(2.0).timeout
	#upgrade_sicurezza()
	#await get_tree().create_timer(2.0).timeout
	#upgrade_sicurezza()
	#await get_tree().create_timer(2.0).timeout
	#upgrade_sicurezza()


func _aggiorna_grafica():
	print("Bilanciamento attuale: ", Global.bilanciamento)
	
	if Global.bilanciamento == 0:
		# Siamo al centro esatto
		bar_prod.value = 0
		bar_sic.value = 0
		
	elif Global.bilanciamento < 0:
		# Siamo sbilanciati verso PRODUZIONE (numeri negativi)
		# abs() trasforma -3 in 3, perché la progress bar vuole numeri positivi
		bar_prod.value = abs(Global.bilanciamento)
		bar_sic.value = 0
		
	else:
		# Siamo sbilanciati verso SICUREZZA (numeri positivi)
		bar_prod.value = 0
		bar_sic.value = Global.bilanciamento
