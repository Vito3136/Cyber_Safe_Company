extends Control

# Riferimenti ai nodi
@onready var bar_prod = $HBoxContainer/BarraProduzione
@onready var bar_sic = $HBoxContainer/BarraSicurezza
@onready var label_contatore_monete = $ContenitoreMonete/LabelContatoreMonete
@onready var security_label = $SecurityLabel
@onready var production_label = $ProductionLabel


func _ready():
	# Impostiamo i massimi delle barre grafiche
	bar_prod.max_value = Global.max_tacchette
	bar_sic.max_value = Global.max_tacchette
	Global.update_barra_bilanciamento.connect(_aggiorna_grafica_barra)
	Global.update_monete.connect(_aggiorna_grafica_monete)
	_aggiorna_grafica_barra()
	_aggiorna_grafica_monete(Global.monete)


func _aggiorna_grafica_monete(monete):
	label_contatore_monete.text = str(monete)

func _aggiorna_grafica_barra():
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
	
	production_label.text = "PRODUCTION   (" + str(Global.totale_upgrade_produzione) + ")" 
	security_label.text = "(" + str(Global.totale_upgrade_sicurezza) + ")   SECURITY"
