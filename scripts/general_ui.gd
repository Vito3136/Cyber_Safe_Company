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
	
	var style_prod = bar_prod.get_theme_stylebox("fill")
	var style_sic = bar_sic.get_theme_stylebox("fill")
	
	var valore_bilanciamento = Global.bilanciamento
	var valore_bilanciamento_abs = abs(valore_bilanciamento)
	
	if valore_bilanciamento == 0:
		# Siamo al centro esatto
		bar_prod.value = 0
		bar_sic.value = 0
	
	elif valore_bilanciamento < 0:
		# Siamo sbilanciati verso PRODUZIONE (numeri negativi)
		# abs() trasforma -3 in 3, perché la progress bar vuole numeri positivi
		bar_prod.value = valore_bilanciamento_abs
		bar_sic.value = 0
		if(valore_bilanciamento_abs <= 3):
			style_prod.bg_color = Color("00ff00ff")
		elif(valore_bilanciamento_abs > 3 && valore_bilanciamento_abs <= 6):
			style_prod.bg_color = Color("ffe036ff")
		else:
			style_prod.bg_color = Color("ff0000ff")
	
	else:
		# Siamo sbilanciati verso SICUREZZA (numeri positivi)
		bar_prod.value = 0
		bar_sic.value = valore_bilanciamento_abs
		if(valore_bilanciamento_abs <= 3):
			style_sic.bg_color = Color("00ff00ff")
		elif(valore_bilanciamento_abs > 3 && valore_bilanciamento_abs <= 6):
			style_sic.bg_color = Color("ffe036ff")
		else:
			style_sic.bg_color = Color("ff0000ff")
	
	production_label.text = "PRODUCTION   (" + str(Global.totale_upgrade_produzione) + ")" 
	security_label.text = "(" + str(Global.totale_upgrade_sicurezza) + ")   SECURITY"
