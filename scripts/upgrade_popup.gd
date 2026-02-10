extends PopupPanel

@onready var close_button: Button = $ContentsContainer/CloseButton
@export var card_template_effettuabili: PackedScene # Qui trascinerai il tuo card_upgrade_1.tscn
@export var card_template_effettuati: PackedScene
@export var dati_effettuati: Array[CardData]
@export var dati_effettuabili: Array[CardData]

@onready var container_effettuati = $ContentsContainer/TwoPartsContainer/UpgradeEffettuatiContainer/ScrollContainer/VBoxContainer
@onready var container_effettuabili = $ContentsContainer/TwoPartsContainer/UpgradeEffettuabiliContainer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if close_button:
		close_button.pressed.connect(self._on_close_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_close_button_pressed() -> void:
	hide()
	
func open_popup():
	# Assicura che sia mostrato e centrato
	aggiorna_popup()
	popup_centered_ratio(0.75)
	show()

func aggiorna_popup():
	# Verifichiamo che i container esistano per evitare errori
	if container_effettuati and container_effettuabili:
		popola_lista(container_effettuati, dati_effettuati, true)
		popola_lista(container_effettuabili, dati_effettuabili, false)
	else:
		print("ERRORE: Uno dei container non è stato trovato. Controlla i percorsi @onready")

func popola_lista(container: VBoxContainer, lista_dati: Array[CardData], isEffettuato: bool):
	print("Popolando: ", container.name, " (Elementi: ", lista_dati.size(), ")")
	
	# 1. Pulizia dei vecchi nodi
	for child in container.get_children():
		child.queue_free()
	
	# 2. Creazione delle nuove card (Un solo ciclo for!)
	for info in lista_dati:
		var nuova_card
		if info == null: 
			continue # Salta gli slot vuoti nell'ispettore senza crashare
		
		if isEffettuato:
			nuova_card = card_template_effettuati.instantiate()
		else: 
			nuova_card = card_template_effettuabili.instantiate()
			if nuova_card.has_signal("requested_purchase"):
				# Usiamo 'bind' per passare i dati specifici di questa card alla funzione
				nuova_card.requested_purchase.connect(_on_bought_upgrade)
			
		container.add_child(nuova_card)
		
		# Inizializza la card con i dati del file .tres
		if nuova_card.has_method("setup"):
			nuova_card.setup(info)
			print("Card creata: ", info.titolo)
		else:
			print("ERRORE: Lo script della card non ha la funzione setup()")

func _on_bought_upgrade(data: CardData):
	# 1. Rimuovi dai disponibili
	dati_effettuabili.erase(data)
	
	# 2. Aggiungi agli effettuati
	dati_effettuati.append(data)
	
	# 3. Rinfresca il popup per spostare visivamente la card
	aggiorna_popup()
	print("Acquisto completato per: ", data.titolo)
