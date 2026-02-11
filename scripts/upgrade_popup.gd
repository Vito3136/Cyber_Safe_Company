extends PopupPanel

@onready var close_button: Button = $ContentsContainer/CloseButton
@export var card_template_effettuabili: PackedScene
@export var card_template_effettuati: PackedScene

@export var available_upgrades_starting_setup: Array[CardData]
@export var performed_upgrades_starting_setup: Array[CardData]

@onready var performed_upgrades_container = $ContentsContainer/TwoPartsContainer/UpgradeEffettuatiContainer/ScrollContainer/VBoxContainer
@onready var available_upgrades_container = $ContentsContainer/TwoPartsContainer/UpgradeEffettuabiliContainer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.available_upgrades.is_empty() and Global.performed_upgrades.is_empty():
		Global.performed_upgrades = performed_upgrades_starting_setup.duplicate()
		Global.available_upgrades = available_upgrades_starting_setup.duplicate()
	
	# Collega il pulsante chiudi come hai già fatto
	if close_button:
		close_button.pressed.connect(self.hide)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_close_button_pressed() -> void:
	hide()
	
func open_popup():
	# Assicura che sia mostrato e centrato
	refresh_popup()
	popup_centered_ratio(0.75)
	show()

func refresh_popup():
	# Verifichiamo che i container esistano per evitare errori
	popola_lista(performed_upgrades_container, Global.performed_upgrades, true)
	popola_lista(available_upgrades_container, Global.available_upgrades, false)

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
	Global.unlock_upgrade(data)
	
	refresh_popup()
	print("Acquisto completato per: ", data.titolo)
