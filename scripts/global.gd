extends Node

var monete : int = 0

# Variabili prese
var costo_presa_singola : int = 8
var produzione_prese_avviata : bool = false
var prese_in_sala_macchinari : int = 0  # Quelle prodotte ma non raccolte
var prese_in_magazzino : int = 0 # Quelle raccolte e stoccate
var timer_produzione_prese : Timer
var prese_is_full : bool = false
var capienza_massima_prese : int = 10

# Variabili lampadine
var costo_lampadina_singola : int = 11
var produzione_lampadine_avviata : bool = false
var lampadine_in_sala_macchinari : int = 0  # Quelle prodotte ma non raccolte
var lampadine_in_magazzino : int = 0 # Quelle raccolte e stoccate
var timer_produzione_lampadine : Timer
var lampadine_is_full : bool = false
var capienza_massima_lampadine : int = 10
var lampadine_is_locked = true

# Variabili telecamere
var costo_telecamera_singola : int = 15
var produzione_telecamere_avviata : bool = false
var telecamere_in_sala_macchinari : int = 0  # Quelle prodotte ma non raccolte
var telecamere_in_magazzino : int = 0 # Quelle raccolte e stoccate
var timer_produzione_telecamere : Timer
var telecamere_is_full : bool = false
var capienza_massima_telecamere : int = 10
var telecamere_is_locked = true

# Variabili serrature
var costo_serratura_singola : int = 20
var produzione_serrature_avviata : bool = false
var serrature_in_sala_macchinari : int = 0  # Quelle prodotte ma non raccolte
var serrature_in_magazzino : int = 0 # Quelle raccolte e stoccate
var timer_produzione_serrature : Timer
var serrature_is_full : bool = false
var capienza_massima_serrature : int = 10
var serrature_is_locked = true


# DEFINIAMO I SEGNALI
# Servono per avvisare le scene di aggiornare le etichette (Label)
signal produzione_prese_aggiornata(quantita_in_sala_macchinari, quantita_massima_prese)
signal produzione_lampadine_aggiornata(quantita_in_sala_macchinari, quantita_massima_lampadine)
signal produzione_telecamere_aggiornata(quantita_in_sala_macchinari, quantita_massima_telecamere)
signal produzione_serrature_aggiornata(quantita_in_sala_macchinari, quantita_massima_serrature)

# SPEDIZIONE
signal parti_spedizione()
var timer_spedizione : Timer
var timer_animazione_spedizione : Timer
var spedizioni_avviate : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func avvia_spedizioni():
	if(!spedizioni_avviate):
		spedizioni_avviate = true
		timer_spedizione = Timer.new()
		timer_spedizione.wait_time = 40.0
		timer_spedizione.autostart = true
		timer_spedizione.one_shot = false # Si ripete all'infinito
		# Colleghiamo il segnale di timeout alla nostra funzione
		timer_spedizione.timeout.connect(_on_timer_spedizione_timeout)
		# Aggiungiamo il timer al nodo Global
		add_child(timer_spedizione)
		
		timer_animazione_spedizione = Timer.new()
		timer_animazione_spedizione.wait_time = 35.0
		timer_animazione_spedizione.autostart = true
		# Colleghiamo il segnale di timeout alla nostra funzione
		timer_animazione_spedizione.timeout.connect(_on_timer_animazione_spedizione_timeeout)
		# Aggiungiamo il timer al nodo Global
		add_child(timer_animazione_spedizione)

func _on_timer_spedizione_timeout():
	timer_animazione_spedizione.start()
	print("40 finiti - ora aggiornamento Monete: " + str(monete))

func _on_timer_animazione_spedizione_timeeout():
	vendi_tutto()
	parti_spedizione.emit()

func vendi_tutto():
	var totale : int = (prese_in_magazzino * costo_presa_singola) + (lampadine_in_magazzino * costo_lampadina_singola) + (telecamere_in_magazzino * costo_telecamera_singola) + (serrature_in_magazzino * costo_serratura_singola)
	prese_in_magazzino = 0
	lampadine_in_magazzino = 0
	telecamere_in_magazzino = 0
	serrature_in_magazzino = 0
	monete += totale
	print("35 finiti - Monete calcolate: " + str(monete))

func avvia_produzione_prese():
	if(!produzione_prese_avviata):
		timer_produzione_prese = Timer.new()
		timer_produzione_prese.wait_time = 5.0 # Ogni 5 secondi
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
		timer_produzione_lampadine.wait_time = 5.0 # Ogni 5 secondi
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
		timer_produzione_telecamere.wait_time = 5.0 # Ogni 5 secondi
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
		timer_produzione_serrature.wait_time = 5.0 # Ogni 5 secondi
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
	
	produzione_prese_aggiornata.emit(prese_in_sala_macchinari, capienza_massima_prese)
	
	# Controlla se abbiamo raggiunto il limite
	if prese_in_sala_macchinari >= capienza_massima_prese:
		prese_is_full = true
		timer_produzione_prese.stop() # FERMA IL TIMER: Smette di produrre

# Questa funzione scatta ogni 5 secondi, SEMPRE
func _on_timer_produzione_lampadine_timeout():
	if lampadine_is_full:
		return
	
	lampadine_in_sala_macchinari += 1
	print("Prodotta una lampadina! In macchina: ", lampadine_in_sala_macchinari)
	
	produzione_lampadine_aggiornata.emit(lampadine_in_sala_macchinari, capienza_massima_lampadine)
	
	# Controlla se abbiamo raggiunto il limite
	if lampadine_in_sala_macchinari >= capienza_massima_lampadine:
		lampadine_is_full = true
		timer_produzione_lampadine.stop() # FERMA IL TIMER: Smette di produrre

func _on_timer_produzione_telecamere_timeout():
	if telecamere_is_full:
		return
	
	telecamere_in_sala_macchinari += 1
	print("Prodotta una lampadina! In macchina: ", telecamere_in_sala_macchinari)
	
	produzione_telecamere_aggiornata.emit(telecamere_in_sala_macchinari, capienza_massima_telecamere)
	
	# Controlla se abbiamo raggiunto il limite
	if telecamere_in_sala_macchinari >= capienza_massima_telecamere:
		telecamere_is_full = true
		timer_produzione_telecamere.stop() # FERMA IL TIMER: Smette di produrre


func _on_timer_produzione_serrature_timeout():
	if serrature_is_full:
		return
	
	serrature_in_sala_macchinari += 1
	print("Prodotta una lampadina! In macchina: ", serrature_in_sala_macchinari)
	
	produzione_serrature_aggiornata.emit(serrature_in_sala_macchinari, capienza_massima_serrature)
	
	# Controlla se abbiamo raggiunto il limite
	if serrature_in_sala_macchinari >= capienza_massima_serrature:
		serrature_is_full = true
		timer_produzione_serrature.stop() # FERMA IL TIMER: Smette di produrre

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_prese():
	if prese_in_sala_macchinari > 0:
		
		if(prese_is_full):
			prese_is_full = false
			if timer_produzione_prese.is_stopped():
				timer_produzione_prese.start()
		
		# Spostiamo i numeri
		prese_in_magazzino += prese_in_sala_macchinari
		prese_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_prese_aggiornata.emit(prese_in_sala_macchinari, capienza_massima_prese) # Diventerà 0

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_lampadine():
	if lampadine_in_sala_macchinari > 0:
		
		if(lampadine_is_full):
			lampadine_is_full = false
			if timer_produzione_lampadine.is_stopped():
				timer_produzione_lampadine.start()
		
		# Spostiamo i numeri
		lampadine_in_magazzino += lampadine_in_sala_macchinari
		lampadine_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_lampadine_aggiornata.emit(lampadine_in_sala_macchinari, capienza_massima_lampadine) # Diventerà 0

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_telecamere():
	if telecamere_in_sala_macchinari > 0:
		
		if(telecamere_is_full):
			telecamere_is_full = false
			if timer_produzione_telecamere.is_stopped():
				timer_produzione_telecamere.start()
		
		# Spostiamo i numeri
		telecamere_in_magazzino += telecamere_in_sala_macchinari
		telecamere_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_telecamere_aggiornata.emit(telecamere_in_sala_macchinari, capienza_massima_telecamere) # Diventerà 0

# Funzione chiamata quando l'utente tappa nella Sala Macchinari
func raccogli_tutto_serrature():
	if serrature_in_sala_macchinari > 0:
		
		if(serrature_is_full):
			serrature_is_full = false
			if timer_produzione_serrature.is_stopped():
				timer_produzione_serrature.start()
		
		# Spostiamo i numeri
		serrature_in_magazzino += serrature_in_sala_macchinari
		serrature_in_sala_macchinari = 0
		
		# Emettiamo i segnali per aggiornare entrambe le grafiche
		produzione_serrature_aggiornata.emit(serrature_in_sala_macchinari, capienza_massima_serrature) # Diventerà 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
