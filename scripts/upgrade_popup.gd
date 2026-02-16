extends PopupPanel

@onready var close_button: Button = $ContentsContainer/CloseButton
@export var card_template_effettuabili: PackedScene
@export var card_template_effettuati: PackedScene

@export var server_room_path = "res://scenes/sala_server.tscn"
@export var office_path = "res://scenes/uffici.tscn"
@export var siem_room_path = "res://scenes/sala_siem_soc.tscn"

@export var server_room_available_upgrades_starting_setup: Array[CardData]
@export var server_room_performed_upgrades_starting_setup: Array[CardData]
@export var office_available_upgrades_starting_setup: Array[CardData]
@export var office_performed_upgrades_starting_setup: Array[CardData]
@export var siem_room_available_upgrades_starting_setup: Array[CardData]
@export var siem_room_performed_upgrades_starting_setup: Array[CardData]

@onready var performed_upgrades_container = $ContentsContainer/TwoPartsContainer/UpgradeEffettuatiContainer/ScrollContainer/VBoxContainer
@onready var available_upgrades_container = $ContentsContainer/TwoPartsContainer/UpgradeEffettuabiliContainer/ScrollContainer/VBoxContainer

var path_scena: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_inside_tree():
		await tree_entered
		
	path_scena = get_tree().current_scene.scene_file_path
	
	if (path_scena == server_room_path):
		if Global.server_room_available_upgrades.is_empty() and Global.server_room_performed_upgrades.is_empty():
			Global.server_room_performed_upgrades = server_room_performed_upgrades_starting_setup.duplicate()
			Global.server_room_available_upgrades = server_room_available_upgrades_starting_setup.duplicate()
	elif (path_scena == office_path):
		if Global.office_available_upgrades.is_empty() and Global.office_performed_upgrades.is_empty():
			Global.office_performed_upgrades = office_performed_upgrades_starting_setup.duplicate()
			Global.office_available_upgrades = office_available_upgrades_starting_setup.duplicate()
	elif (path_scena == siem_room_path):
		if Global.siem_room_available_upgrades.is_empty() and Global.siem_room_performed_upgrades.is_empty():
			Global.siem_room_performed_upgrades = siem_room_performed_upgrades_starting_setup.duplicate()
			Global.siem_room_available_upgrades = siem_room_available_upgrades_starting_setup.duplicate()
	
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
	
	var purchased_ids = []
	if (Global.siem_team):
		purchased_ids.append("siem_team")
	
	# Verifichiamo che i container esistano per evitare errori
	if (path_scena == server_room_path):
		
		for data in Global.server_room_performed_upgrades:
			if data:
				purchased_ids.append(data.upgrade_id)
	
		Global.server_room_available_upgrades.sort_custom(func(a, b):
			var a_unlocked = a.required_id == "" or a.required_id in purchased_ids
			var b_unlocked = b.required_id == "" or b.required_id in purchased_ids
			
			# Se 'a' è sbloccato e 'b' no, 'a' deve venire prima (true)
			if a_unlocked and not b_unlocked:
				return true
			# Se 'b' è sbloccato e 'a' no, 'b' deve venire prima (false)
			elif not a_unlocked and b_unlocked:
				return false
			# Se sono entrambi sbloccati o entrambi bloccati, mantieni l'ordine originale (o usa il titolo)
			else:
				var index_a = Global.server_room_available_upgrades.find(a)
				var index_b = Global.server_room_available_upgrades.find(b)
				return index_a < index_b
		)
		
		popola_lista(performed_upgrades_container, Global.server_room_performed_upgrades, true, purchased_ids)
		popola_lista(available_upgrades_container, Global.server_room_available_upgrades, false, purchased_ids)
	
	elif (path_scena == office_path):
		
		for data in Global.office_performed_upgrades:
			if data:
				purchased_ids.append(data.upgrade_id)
	
		Global.office_available_upgrades.sort_custom(func(a, b):
			var a_unlocked = a.required_id == "" or a.required_id in purchased_ids
			var b_unlocked = b.required_id == "" or b.required_id in purchased_ids
			
			# Se 'a' è sbloccato e 'b' no, 'a' deve venire prima (true)
			if a_unlocked and not b_unlocked:
				return true
			# Se 'b' è sbloccato e 'a' no, 'b' deve venire prima (false)
			elif not a_unlocked and b_unlocked:
				return false
			# Se sono entrambi sbloccati o entrambi bloccati, mantieni l'ordine originale (o usa il titolo)
			else:
				var index_a = Global.office_available_upgrades.find(a)
				var index_b = Global.office_available_upgrades.find(b)
				return index_a < index_b
		)
		
		popola_lista(performed_upgrades_container, Global.office_performed_upgrades, true, purchased_ids)
		popola_lista(available_upgrades_container, Global.office_available_upgrades, false, purchased_ids)
	
	elif (path_scena == siem_room_path):
		
		for data in Global.siem_room_performed_upgrades:
			if data:
				purchased_ids.append(data.upgrade_id)
	
		Global.siem_room_available_upgrades.sort_custom(func(a, b):
			var a_unlocked = a.required_id == "" or a.required_id in purchased_ids
			var b_unlocked = b.required_id == "" or b.required_id in purchased_ids
			
			# Se 'a' è sbloccato e 'b' no, 'a' deve venire prima (true)
			if a_unlocked and not b_unlocked:
				return true
			# Se 'b' è sbloccato e 'a' no, 'b' deve venire prima (false)
			elif not a_unlocked and b_unlocked:
				return false
			# Se sono entrambi sbloccati o entrambi bloccati, mantieni l'ordine originale (o usa il titolo)
			else:
				var index_a = Global.siem_room_available_upgrades.find(a)
				var index_b = Global.siem_room_available_upgrades.find(b)
				return index_a < index_b
		)
		
		popola_lista(performed_upgrades_container, Global.siem_room_performed_upgrades, true, purchased_ids)
		popola_lista(available_upgrades_container, Global.siem_room_available_upgrades, false, purchased_ids)

func popola_lista(container: VBoxContainer, lista_dati: Array[CardData], isEffettuato: bool, purchased_ids: Array):
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
			
			# 1. Verifica Requisito ID
			var unlocked_required_id = info.required_id == "" or info.required_id in purchased_ids
			
			# 2. Verifica Requisito Evento
			var unlocked_event = true
			if info.get("required_event") and info.required_event != "":
				unlocked_event = Global.completed_events.get(info.required_event, false)
			
			# La card diventa ARANCIONE solo se ha il precedente E l'evento è ok
			nuova_card.is_unlocked = unlocked_required_id and unlocked_event
			
			if nuova_card.has_signal("requested_purchase"):
				if not nuova_card.requested_purchase.is_connected(_on_bought_upgrade):
					nuova_card.requested_purchase.connect(_on_bought_upgrade)
			
		container.add_child(nuova_card)
		
		# Inizializza la card con i dati del file .tres
		if nuova_card.has_method("setup"):
			nuova_card.setup(info)
			print("Card creata: ", info.titolo)
		else:
			print("ERRORE: Lo script della card non ha la funzione setup()")

func _on_bought_upgrade(data: CardData):
	if Global.monete >= data.costo:
		# 2. Sottrai i soldi
		Global.monete -= data.costo
		
		if (path_scena == server_room_path):
			Global.server_room_unlock_upgrade(data)
		elif (path_scena == office_path):
			Global.office_unlock_upgrade(data)
		elif (path_scena == siem_room_path):
			Global.siem_room_unlock_upgrade(data)
		
		# 4. Aggiorna tutto
		refresh_popup()
		print("Acquisto effettuato! Monete rimanenti: ", Global.monete)
	else:
		print("Non hai abbastanza monete!")
