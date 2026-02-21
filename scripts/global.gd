extends Node

# Tutorial
var tutorial_iniziale_effettuato: bool = false
var tutorial_totale_effettuato: bool = false

# Barra bilanciamento
# 0 = Centro
# -5 = 5 tacche verso Produzione
# +3 = 3 tacche verso Sicurezza
var bilanciamento: int = 0
var max_tacchette: int = 18
var totale_upgrade_produzione: int = 0
var totale_upgrade_sicurezza: int = 0
signal update_barra_bilanciamento()

var emetti_suono: bool = false
var monete: int = 300
signal update_monete(totale_monete)

var capienza_massima_per_livello: Array[int] = [10, 10, 12, 14]
var timer_produzione_per_livello: Array[float] = [5.0, 4.0, 4.0, 3.0]

var timer_spedizione_per_livello: Array[float] = [40.0, 35.0, 30.0]
var timer_animazione_spedizione_per_livello: Array[float] = [35.0, 30.0, 25.0]
var livello_magazzino: int = 0

# Variabili prese
var costo_presa_singola: int = 8
var livello_prese: int = 0
var timer_produzione_prese: Timer
var produzione_prese_avviata: bool = false
var prese_in_sala_macchinari: int = 0  # Quelle prodotte ma non raccolte
var prese_in_magazzino: int = 0 # Quelle raccolte e stoccate
var prese_is_full: bool = false
signal prese_svuotate()

# Variabili lampadine
var costo_lampadina_singola: int = 11
var livello_lampadine: int = 0
var produzione_lampadine_avviata: bool = false
var lampadine_in_sala_macchinari: int = 0  # Quelle prodotte ma non raccolte
var lampadine_in_magazzino: int = 0 # Quelle raccolte e stoccate
var timer_produzione_lampadine: Timer
var lampadine_is_full: bool = false
var lampadine_is_locked = true
var lucchetto_lampadine_scomparso = false
signal lampadine_svuotate()

# Variabili telecamere
var costo_telecamera_singola: int = 15
var livello_telecamere: int = 0
var produzione_telecamere_avviata: bool = false
var telecamere_in_sala_macchinari: int = 0  # Quelle prodotte ma non raccolte
var telecamere_in_magazzino: int = 0 # Quelle raccolte e stoccate
var timer_produzione_telecamere: Timer
var telecamere_is_full: bool = false
var telecamere_is_locked = true
var lucchetto_telecamere_scomparso = false
signal telecamere_svuotate()

# Variabili serrature
var costo_serratura_singola: int = 20
var livello_serrature: int = 0
var produzione_serrature_avviata: bool = false
var serrature_in_sala_macchinari: int = 0  # Quelle prodotte ma non raccolte
var serrature_in_magazzino: int = 0 # Quelle raccolte e stoccate
var timer_produzione_serrature: Timer
var serrature_is_full: bool = false
var serrature_is_locked = true
var lucchetto_serrature_scomparso = false
signal serrature_svuotate()

signal produzione_prese_aggiornata(quantita_in_sala_macchinari, quantita_massima_prese)
signal produzione_lampadine_aggiornata(quantita_in_sala_macchinari, quantita_massima_lampadine)
signal produzione_telecamere_aggiornata(quantita_in_sala_macchinari, quantita_massima_telecamere)
signal produzione_serrature_aggiornata(quantita_in_sala_macchinari, quantita_massima_serrature)

# SPEDIZIONE
signal parti_spedizione()
var timer_spedizione: Timer
var timer_animazione_spedizione: Timer
var spedizioni_avviate: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_spedizione = Timer.new()
	timer_spedizione.wait_time = timer_spedizione_per_livello[livello_magazzino]
	timer_spedizione.autostart = true
	timer_spedizione.one_shot = false # Si ripete all'infinito
	# Colleghiamo il segnale di timeout alla nostra funzione
	timer_spedizione.timeout.connect(_on_timer_spedizione_timeout)
	# Aggiungiamo il timer al nodo Global
	add_child(timer_spedizione)
		
	timer_animazione_spedizione = Timer.new()
	timer_animazione_spedizione.wait_time = timer_animazione_spedizione_per_livello[livello_magazzino]
	timer_animazione_spedizione.autostart = true
	# Colleghiamo il segnale di timeout alla nostra funzione
	timer_animazione_spedizione.timeout.connect(_on_timer_animazione_spedizione_timeeout)
	# Aggiungiamo il timer al nodo Global
	add_child(timer_animazione_spedizione)

	var autosave_timer = Timer.new()
	autosave_timer.wait_time = 30.0
	autosave_timer.autostart = true
	autosave_timer.one_shot = false
	autosave_timer.timeout.connect(_on_autosave_timeout)
	add_child(autosave_timer)

func _on_timer_spedizione_timeout():
	timer_animazione_spedizione.start()
	update_monete.emit(monete)
	if(emetti_suono):
		var asp = AudioStreamPlayer.new()
		asp.stream = load("res://sounds/drop_coin.mp3")
		add_child(asp)
		asp.play()
		asp.finished.connect(asp.queue_free)
	print("40 secondi finiti - ora aggiornamento Monete: " + str(monete))

func _on_timer_animazione_spedizione_timeeout():
	vendi_tutto()
	parti_spedizione.emit()

func vendi_tutto():
	var totale: int = (prese_in_magazzino * costo_presa_singola) + (lampadine_in_magazzino * costo_lampadina_singola) + (telecamere_in_magazzino * costo_telecamera_singola) + (serrature_in_magazzino * costo_serratura_singola)
	prese_in_magazzino = 0
	lampadine_in_magazzino = 0
	telecamere_in_magazzino = 0
	serrature_in_magazzino = 0
	if(totale > 0):
		emetti_suono = true
	else:
		emetti_suono = false
	monete += totale
	print("35 secondi finiti - Monete calcolate: " + str(monete))

# Funzione da chiamare quando fai un upgrade PRODUZIONE
func upgrade_produzione():
	# Andare verso sinistra significa SOTTRARRE al bilanciamento
	# Controllo di non superare il limite massimo a sinistra (-10)
	if bilanciamento > -max_tacchette:
		bilanciamento -= 1
		totale_upgrade_produzione += 1
		update_barra_bilanciamento.emit()

# Funzione da chiamare quando fai un upgrade SICUREZZA
func upgrade_sicurezza():
	# Andare verso destra significa AGGIUNGERE al bilanciamento
	# Controllo di non superare il limite massimo a destra (+10)
	if Global.bilanciamento < max_tacchette:
		Global.bilanciamento += 1
		totale_upgrade_sicurezza += 1
		update_barra_bilanciamento.emit()

func aumenta_livello_magazzino():
	if(livello_magazzino < 2):
		livello_magazzino += 1
		timer_spedizione.wait_time = timer_spedizione_per_livello[livello_magazzino]
		timer_animazione_spedizione.wait_time = timer_animazione_spedizione_per_livello[livello_magazzino]
		upgrade_produzione()

func aumenta_livello_prese():
	if(livello_prese < 3):
		livello_prese += 1
		timer_produzione_prese.wait_time = timer_produzione_per_livello[livello_prese]
		upgrade_produzione()

func aumenta_livello_lampadine():
	if(livello_lampadine < 3):
		livello_lampadine += 1
		timer_produzione_lampadine.wait_time = timer_produzione_per_livello[livello_lampadine]
		upgrade_produzione()

func aumenta_livello_telecamere():
	if(livello_telecamere < 3):
		livello_telecamere += 1
		timer_produzione_telecamere.wait_time = timer_produzione_per_livello[livello_telecamere]
		upgrade_produzione()

func aumenta_livello_serrature():
	if(livello_serrature < 3):
		livello_serrature += 1
		timer_produzione_serrature.wait_time = timer_produzione_per_livello[livello_serrature]
		upgrade_produzione()

func sblocca_macchinario_lampadine():
	lampadine_is_locked = false
	upgrade_produzione()

func sblocca_macchinario_telecamere():
	telecamere_is_locked = false
	upgrade_produzione()

func sblocca_macchinario_serrature():
	serrature_is_locked = false
	upgrade_produzione()

func avvia_produzione_prese():
	if(!produzione_prese_avviata):
		timer_produzione_prese = Timer.new()
		timer_produzione_prese.wait_time = timer_produzione_per_livello[livello_prese]
		timer_produzione_prese.autostart = true
		timer_produzione_prese.one_shot = false # Si ripete all'infinito
		produzione_prese_avviata = true
		
		# Colleghiamo il segnale di timeout alla nostra funzione
		timer_produzione_prese.timeout.connect(_on_timer_produzione_prese_timeout)
		
		# Aggiungiamo il timer al nodo Global
		add_child(timer_produzione_prese)

func avvia_produzione_lampadine():
	if(!produzione_lampadine_avviata):
		timer_produzione_lampadine = Timer.new()
		timer_produzione_lampadine.wait_time = timer_produzione_per_livello[livello_lampadine]
		timer_produzione_lampadine.autostart = true
		timer_produzione_lampadine.one_shot = false # Si ripete all'infinito
		produzione_lampadine_avviata = true
		
		# Colleghiamo il segnale di timeout alla nostra funzione
		timer_produzione_lampadine.timeout.connect(_on_timer_produzione_lampadine_timeout)
		
		# Aggiungiamo il timer al nodo Global
		add_child(timer_produzione_lampadine)

func avvia_produzione_telecamere():
	if(!produzione_telecamere_avviata):
		timer_produzione_telecamere = Timer.new()
		timer_produzione_telecamere.wait_time = timer_produzione_per_livello[livello_telecamere]
		timer_produzione_telecamere.autostart = true
		timer_produzione_telecamere.one_shot = false # Si ripete all'infinito
		produzione_telecamere_avviata = true
		
		# Colleghiamo il segnale di timeout alla nostra funzione
		timer_produzione_telecamere.timeout.connect(_on_timer_produzione_telecamere_timeout)
		
		# Aggiungiamo il timer al nodo Global
		add_child(timer_produzione_telecamere)

func avvia_produzione_serrature():
	if(!produzione_serrature_avviata):
		timer_produzione_serrature = Timer.new()
		timer_produzione_serrature.wait_time = timer_produzione_per_livello[livello_serrature]
		timer_produzione_serrature.autostart = true
		timer_produzione_serrature.one_shot = false # Si ripete all'infinito
		produzione_serrature_avviata = true
		
		# Colleghiamo il segnale di timeout alla nostra funzione
		timer_produzione_serrature.timeout.connect(_on_timer_produzione_serrature_timeout)
		
		# Aggiungiamo il timer al nodo Global
		add_child(timer_produzione_serrature)

# Questa funzione scatta ogni 5 secondi, SEMPRE
func _on_timer_produzione_prese_timeout():
	if prese_is_full:
		return
	
	prese_in_sala_macchinari += 1
	print("Prodotta una presa! In macchina: ", prese_in_sala_macchinari)
	
	produzione_prese_aggiornata.emit(prese_in_sala_macchinari, capienza_massima_per_livello[livello_prese])
	
	# Controlla se abbiamo raggiunto il limite
	if prese_in_sala_macchinari >= capienza_massima_per_livello[livello_prese]:
		prese_is_full = true
		timer_produzione_prese.stop() # FERMA IL TIMER: Smette di produrre

# Questa funzione scatta ogni 5 secondi, SEMPRE
func _on_timer_produzione_lampadine_timeout():
	if lampadine_is_full:
		return
	
	lampadine_in_sala_macchinari += 1
	print("Prodotta una lampadina! In macchina: ", lampadine_in_sala_macchinari)
	
	produzione_lampadine_aggiornata.emit(lampadine_in_sala_macchinari, capienza_massima_per_livello[livello_lampadine])
	
	# Controlla se abbiamo raggiunto il limite
	if lampadine_in_sala_macchinari >= capienza_massima_per_livello[livello_lampadine]:
		lampadine_is_full = true
		timer_produzione_lampadine.stop() # FERMA IL TIMER: Smette di produrre

func _on_timer_produzione_telecamere_timeout():
	if telecamere_is_full:
		return
	
	telecamere_in_sala_macchinari += 1
	print("Prodotta una lampadina! In macchina: ", telecamere_in_sala_macchinari)
	
	produzione_telecamere_aggiornata.emit(telecamere_in_sala_macchinari, capienza_massima_per_livello[livello_telecamere])
	
	# Controlla se abbiamo raggiunto il limite
	if telecamere_in_sala_macchinari >= capienza_massima_per_livello[livello_telecamere]:
		telecamere_is_full = true
		timer_produzione_telecamere.stop() # FERMA IL TIMER: Smette di produrre


func _on_timer_produzione_serrature_timeout():
	if serrature_is_full:
		return
	
	serrature_in_sala_macchinari += 1
	print("Prodotta una serratura! In macchina: ", serrature_in_sala_macchinari)
	
	produzione_serrature_aggiornata.emit(serrature_in_sala_macchinari, capienza_massima_per_livello[livello_serrature])
	
	# Controlla se abbiamo raggiunto il limite
	if serrature_in_sala_macchinari >= capienza_massima_per_livello[livello_serrature]:
		serrature_is_full = true
		timer_produzione_serrature.stop() # FERMA IL TIMER: Smette di produrre

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_prese():
	if prese_in_sala_macchinari > 0:
		prese_svuotate.emit()
		
		if(prese_is_full):
			prese_is_full = false
			if timer_produzione_prese.is_stopped():
				timer_produzione_prese.start()
		
		# Spostiamo i numeri
		prese_in_magazzino += prese_in_sala_macchinari
		prese_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_prese_aggiornata.emit(prese_in_sala_macchinari, capienza_massima_per_livello[livello_prese])

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_lampadine():
	if lampadine_in_sala_macchinari > 0:
		lampadine_svuotate.emit()
		
		if(lampadine_is_full):
			lampadine_is_full = false
			if timer_produzione_lampadine.is_stopped():
				timer_produzione_lampadine.start()
		
		# Spostiamo i numeri
		lampadine_in_magazzino += lampadine_in_sala_macchinari
		lampadine_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_lampadine_aggiornata.emit(lampadine_in_sala_macchinari, capienza_massima_per_livello[livello_lampadine]) # Diventerà 0

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_telecamere():
	if telecamere_in_sala_macchinari > 0:
		telecamere_svuotate.emit()
		
		if(telecamere_is_full):
			telecamere_is_full = false
			if timer_produzione_telecamere.is_stopped():
				timer_produzione_telecamere.start()
		
		# Spostiamo i numeri
		telecamere_in_magazzino += telecamere_in_sala_macchinari
		telecamere_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_telecamere_aggiornata.emit(telecamere_in_sala_macchinari, capienza_massima_per_livello[livello_telecamere]) # Diventerà 0

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_serrature():
	if serrature_in_sala_macchinari > 0:
		serrature_svuotate.emit()
		
		if(serrature_is_full):
			serrature_is_full = false
			if timer_produzione_serrature.is_stopped():
				timer_produzione_serrature.start()
		
		# Spostiamo i numeri
		serrature_in_magazzino += serrature_in_sala_macchinari
		serrature_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_serrature_aggiornata.emit(serrature_in_sala_macchinari, capienza_massima_per_livello[livello_serrature]) # Diventerà 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	


##################################### UPGRADE ######################################################
var server_room_performed_upgrades: Array[CardData]
var server_room_available_upgrades: Array[CardData]
var office_performed_upgrades: Array[CardData]
var office_available_upgrades: Array[CardData]
var siem_room_performed_upgrades: Array[CardData]
var siem_room_available_upgrades: Array[CardData]
var all_machine_performed_upgrades: Array[CardData]
var all_machine_available_upgrades: Array[CardData]
var all_warehouse_performed_upgrades: Array[CardData]
var all_warehouse_available_upgrades: Array[CardData]

var completed_events: Dictionary = {}

var siem_team = false

func server_room_unlock_upgrade(upgrade: CardData):
	if upgrade in server_room_available_upgrades:
		server_room_available_upgrades.erase(upgrade)
		server_room_performed_upgrades.append(upgrade)

func office_unlock_upgrade(upgrade: CardData):
	if upgrade in office_available_upgrades:
		office_available_upgrades.erase(upgrade)
		office_performed_upgrades.append(upgrade)
		
func siem_room_unlock_upgrade(upgrade: CardData):
	if upgrade in siem_room_available_upgrades:
		siem_room_available_upgrades.erase(upgrade)
		siem_room_performed_upgrades.append(upgrade)
		
		if (upgrade.upgrade_id == "siem_team"): siem_team = true
		
func all_machine_unlock_upgrade(upgrade: CardData):
	if upgrade in all_machine_available_upgrades:
		all_machine_available_upgrades.erase(upgrade)
		all_machine_performed_upgrades.append(upgrade)
		
func all_warehouse_unlock_upgrade(upgrade: CardData):
	if upgrade in all_warehouse_available_upgrades:
		all_warehouse_available_upgrades.erase(upgrade)
		all_warehouse_performed_upgrades.append(upgrade)

func event_registration(event_id: String):
	completed_events[event_id] = true
	print("Registrated event: ", event_id)

##################################### POPUP ######################################################
var timer_residuo_informativo: float = 0.0
var timer_residuo_tentato: float = 0.0
var timer_residuo_riuscito: float = 0.0
var apparizione_attuale_informativo: int = 0
var apparizione_attuale_tentato: int = 0
var apparizione_attuale_riuscito: int = 0

##################################### SALVATAGGIO ######################################################
const SAVE_PATH = "user://savegame.data"

func save_game():
	var save_data = {
		"tutorial_iniziale_effettuato": tutorial_iniziale_effettuato,
		"tutorial_totale_effettuato": tutorial_totale_effettuato,
		"bilanciamento": bilanciamento,
		"totale_upgrade_produzione": totale_upgrade_produzione,
		"totale_upgrade_sicurezza": totale_upgrade_sicurezza,
		"monete": monete,
		"livello_magazzino": livello_magazzino,
		"livello_prese": livello_prese,
		"produzione_prese_avviata": produzione_prese_avviata,
		"prese_in_sala_macchinari": prese_in_sala_macchinari,
		"prese_in_magazzino": prese_in_magazzino,
		"prese_is_full": prese_is_full,
		"livello_lampadine": livello_lampadine,
		"produzione_lampadine_avviata": produzione_lampadine_avviata,
		"lampadine_in_sala_macchinari": lampadine_in_sala_macchinari,
		"lampadine_in_magazzino": lampadine_in_magazzino,
		"lampadine_is_full": lampadine_is_full,
		"lampadine_is_locked": lampadine_is_locked,
		"lucchetto_lampadine_scomparso": lucchetto_lampadine_scomparso,
		"livello_telecamere": livello_telecamere,
		"produzione_telecamere_avviata": produzione_telecamere_avviata,
		"telecamere_in_sala_macchinari": telecamere_in_sala_macchinari,
		"telecamere_in_magazzino": telecamere_in_magazzino,
		"telecamere_is_full": telecamere_is_full,
		"telecamere_is_locked": telecamere_is_locked,
		"lucchetto_telecamere_scomparso": lucchetto_telecamere_scomparso,
		"livello_serrature": livello_serrature,
		"produzione_serrature_avviata": produzione_serrature_avviata,
		"serrature_in_sala_macchinari": serrature_in_sala_macchinari,
		"serrature_in_magazzino": serrature_in_magazzino,
		"serrature_is_full": serrature_is_full,
		"serrature_is_locked": serrature_is_locked,
		"lucchetto_serrature_scomparso": lucchetto_serrature_scomparso,
		"spedizioni_avviate": spedizioni_avviate,
		"server_room_performed_upgrades": _serializza_upgrades(server_room_performed_upgrades),
		"server_room_available_upgrades": _serializza_upgrades(server_room_available_upgrades),
		"office_performed_upgrades": _serializza_upgrades(office_performed_upgrades),
		"office_available_upgrades": _serializza_upgrades(office_available_upgrades),
		"siem_room_performed_upgrades": _serializza_upgrades(siem_room_performed_upgrades),
		"siem_room_available_upgrades": _serializza_upgrades(siem_room_available_upgrades),
		"all_machine_performed_upgrades": _serializza_upgrades(all_machine_performed_upgrades),
		"all_machine_available_upgrades": _serializza_upgrades(all_machine_available_upgrades),
		"all_warehouse_performed_upgrades": _serializza_upgrades(all_warehouse_performed_upgrades),
		"all_warehouse_available_upgrades": _serializza_upgrades(all_warehouse_available_upgrades),
		"completed_events": completed_events,
		"timer_residuo_informativo": PopupInformativo.get_node("Timer").time_left,
		"timer_residuo_riuscito": PopupAttaccoRiuscito.get_node("Timer").time_left,
		"timer_residuo_tentato": PopupAttaccoTentato.get_node("Timer").time_left,
		"apparizione_attuale_informativo": apparizione_attuale_informativo,
		"apparizione_attuale_tentato": apparizione_attuale_tentato,
		"apparizione_attuale_riuscito": apparizione_attuale_riuscito,
		"siem_team": siem_team
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Gioco Salvato!")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	tutorial_iniziale_effettuato = save_data["tutorial_iniziale_effettuato"]
	tutorial_totale_effettuato = save_data["tutorial_totale_effettuato"]
	bilanciamento = save_data["bilanciamento"]
	totale_upgrade_produzione = save_data["totale_upgrade_produzione"]
	totale_upgrade_sicurezza = save_data["totale_upgrade_sicurezza"]
	monete = save_data["monete"]
	livello_magazzino = save_data["livello_magazzino"]
	livello_prese = save_data["livello_prese"]
	produzione_prese_avviata = save_data["produzione_prese_avviata"]
	prese_in_sala_macchinari = save_data["prese_in_sala_macchinari"]
	prese_in_magazzino = save_data["prese_in_magazzino"]
	prese_is_full = save_data["prese_is_full"]
	livello_lampadine = save_data["livello_lampadine"]
	produzione_lampadine_avviata = save_data["produzione_lampadine_avviata"]
	lampadine_in_sala_macchinari = save_data["lampadine_in_sala_macchinari"]
	lampadine_in_magazzino = save_data["lampadine_in_magazzino"]
	lampadine_is_full = save_data["lampadine_is_full"]
	lampadine_is_locked = save_data["lampadine_is_locked"]
	lucchetto_lampadine_scomparso = save_data["lucchetto_lampadine_scomparso"]
	livello_telecamere = save_data["livello_telecamere"]
	produzione_telecamere_avviata = save_data["produzione_telecamere_avviata"]
	telecamere_in_sala_macchinari = save_data["telecamere_in_sala_macchinari"]
	telecamere_in_magazzino = save_data["telecamere_in_magazzino"]
	telecamere_is_full = save_data["telecamere_is_full"]
	telecamere_is_locked = save_data["telecamere_is_locked"]
	lucchetto_telecamere_scomparso = save_data["lucchetto_telecamere_scomparso"]
	livello_serrature = save_data["livello_serrature"]
	produzione_serrature_avviata = save_data["produzione_serrature_avviata"]
	serrature_in_sala_macchinari = save_data["serrature_in_sala_macchinari"]
	serrature_in_magazzino = save_data["serrature_in_magazzino"]
	serrature_is_full = save_data["serrature_is_full"]
	serrature_is_locked = save_data["serrature_is_locked"]
	lucchetto_serrature_scomparso = save_data["lucchetto_serrature_scomparso"]
	spedizioni_avviate = save_data["spedizioni_avviate"]
	server_room_performed_upgrades = _deserializza_upgrades(save_data["server_room_performed_upgrades"], "safety/server_room")
	server_room_available_upgrades = _deserializza_upgrades(save_data["server_room_available_upgrades"], "safety/server_room")
	office_performed_upgrades = _deserializza_upgrades(save_data["office_performed_upgrades"], "safety/office")
	office_available_upgrades = _deserializza_upgrades(save_data["office_available_upgrades"], "safety/office")
	siem_room_performed_upgrades = _deserializza_upgrades(save_data["siem_room_performed_upgrades"], "safety/siem_room")
	siem_room_available_upgrades = _deserializza_upgrades(save_data["siem_room_available_upgrades"], "safety/siem_room")
	all_machine_performed_upgrades = _deserializza_upgrades(save_data["all_machine_performed_upgrades"], "machines")
	all_machine_available_upgrades = _deserializza_upgrades(save_data["all_machine_available_upgrades"], "machines")
	all_warehouse_performed_upgrades = _deserializza_upgrades(save_data["all_warehouse_performed_upgrades"], "warehouse")
	all_warehouse_available_upgrades = _deserializza_upgrades(save_data["all_warehouse_available_upgrades"], "warehouse")
	completed_events = save_data["completed_events"]
	siem_team = save_data["siem_team"]
	timer_residuo_informativo = save_data["timer_residuo_informativo"]
	timer_residuo_riuscito = save_data["timer_residuo_riuscito"]
	timer_residuo_tentato = save_data["timer_residuo_tentato"]
	apparizione_attuale_informativo = save_data["apparizione_attuale_informativo"]
	apparizione_attuale_tentato = save_data["apparizione_attuale_tentato"]
	apparizione_attuale_riuscito = save_data["apparizione_attuale_riuscito"]
	
	if produzione_prese_avviata:
		produzione_prese_avviata = false
		avvia_produzione_prese()
	if produzione_lampadine_avviata:
		produzione_lampadine_avviata = false
		avvia_produzione_lampadine()
	if produzione_telecamere_avviata:
		produzione_telecamere_avviata = false
		avvia_produzione_telecamere()
	if produzione_serrature_avviata:
		produzione_serrature_avviata = false
		avvia_produzione_serrature()
		
	print("Gioco Caricato!")
	update_monete.emit(monete)
	update_barra_bilanciamento.emit()

func _serializza_upgrades(lista_upgrades: Array[CardData]) -> Array:
	var ids = []
	for up in lista_upgrades:
		ids.append(up.upgrade_id)
	return ids

func _deserializza_upgrades(ids_salvati: Array, cartella: String) -> Array[CardData]:
	var lista_risultato: Array[CardData] = []
	
	for id in ids_salvati:
		var percorso_completo = "res://upgrades/" + cartella + "/" + id + ".tres"
		
		if ResourceLoader.exists(percorso_completo):
			var risorsa = load(percorso_completo) as CardData
			if risorsa:
				lista_risultato.append(risorsa)
		else:
			print("ATTENZIONE: Non trovo il file per l'ID: ", id, " al percorso: ", percorso_completo)
			
	return lista_risultato

func _notification(what):
	# Questo segnale viene inviato quando l'utente tenta di chiudere la finestra
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST || what == NOTIFICATION_APPLICATION_PAUSED:
		print("Chiusura gioco rilevata: salvataggio in corso...")
		save_game() # Chiama la tua funzione di salvataggio
		
		# Opzionale: Se vuoi essere sicuro che Godot abbia il tempo di scrivere il file
		# prima di chiudersi, puoi forzare la chiusura dopo il salvataggio:
		get_tree().quit()
		
func _on_autosave_timeout():
	save_game()
