extends Control

# Configuriamo i limiti
@export var max_tacchette : int = 10 

# Riferimenti ai nodi
@onready var bar_prod = $HBoxContainer/BarraProduzione
@onready var bar_sic = $HBoxContainer/BarraSicurezza

# Questa variabile rappresenta lo stato attuale
# 0 = Centro
# -5 = 5 tacche verso Produzione
# +3 = 3 tacche verso Sicurezza
var bilanciamento : int = 0

func _ready():
	# Impostiamo i massimi delle barre grafiche
	bar_prod.max_value = max_tacchette
	bar_sic.max_value = max_tacchette
	aggiorna_grafica()
	await get_tree().create_timer(2.0).timeout
	upgrade_produzione()
	await get_tree().create_timer(2.0).timeout
	upgrade_produzione()
	await get_tree().create_timer(2.0).timeout
	upgrade_sicurezza()
	await get_tree().create_timer(2.0).timeout
	upgrade_sicurezza()
	await get_tree().create_timer(2.0).timeout
	upgrade_sicurezza()

# Funzione da chiamare quando fai un upgrade PRODUZIONE
func upgrade_produzione():
	# Andare verso sinistra significa SOTTRARRE al bilanciamento
	# Controllo di non superare il limite massimo a sinistra (-10)
	if bilanciamento > -max_tacchette:
		bilanciamento -= 1
		aggiorna_grafica()

# Funzione da chiamare quando fai un upgrade SICUREZZA
func upgrade_sicurezza():
	# Andare verso destra significa AGGIUNGERE al bilanciamento
	# Controllo di non superare il limite massimo a destra (+10)
	if bilanciamento < max_tacchette:
		bilanciamento += 1
		aggiorna_grafica()

func aggiorna_grafica():
	print("Bilanciamento attuale: ", bilanciamento)
	
	if bilanciamento == 0:
		# Siamo al centro esatto
		bar_prod.value = 0
		bar_sic.value = 0
		
	elif bilanciamento < 0:
		# Siamo sbilanciati verso PRODUZIONE (numeri negativi)
		# abs() trasforma -3 in 3, perché la progress bar vuole numeri positivi
		bar_prod.value = abs(bilanciamento)
		bar_sic.value = 0
		
	else:
		# Siamo sbilanciati verso SICUREZZA (numeri positivi)
		bar_prod.value = 0
		bar_sic.value = bilanciamento
