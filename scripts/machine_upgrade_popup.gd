extends PopupPanel

@onready var close_button: Button = $ContentsContainer/CloseButton
@export var card_template_effettuabili: PackedScene
@export var card_template_effettuati: PackedScene

@export var all_machine_available_upgrades_starting_setup: Array[CardData]
@export var all_machine_performed_upgrades_starting_setup: Array[CardData]

@onready var performed_upgrades_container = $ContentsContainer/TwoPartsContainer/UpgradeEffettuatiContainer/ScrollContainer/VBoxContainer
@onready var available_upgrades_container = $ContentsContainer/TwoPartsContainer/UpgradeEffettuabiliContainer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_inside_tree():
		await tree_entered
	
	if Global.all_machine_available_upgrades.is_empty() and Global.all_machine_performed_upgrades.is_empty():
		Global.all_machine_performed_upgrades = all_machine_performed_upgrades_starting_setup.duplicate()
		Global.all_machine_available_upgrades = all_machine_available_upgrades_starting_setup.duplicate()
	
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
	var purchased_ids = get_purchased_ids()
	
	Global.all_machine_available_upgrades.sort_custom(func(a, b):
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
			var index_a = Global.all_machine_available_upgrades.find(a)
			var index_b = Global.all_machine_available_upgrades.find(b)
			return index_a < index_b
	)
	
	popola_lista(performed_upgrades_container, Global.all_machine_performed_upgrades, true, purchased_ids)
	popola_lista(available_upgrades_container, Global.all_machine_available_upgrades, false, purchased_ids)

func popola_lista(container: VBoxContainer, lista_dati: Array[CardData], isEffettuato: bool, purchased_ids: Array):
	for child in container.get_children():
		child.queue_free()
	
	for info in lista_dati:
		if info == null: continue
		
		var nuova_card
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
		
		if nuova_card.has_method("setup"):
			nuova_card.setup(info)

func _on_bought_upgrade(data: CardData):
	if Global.monete >= data.costo:
		# 2. Sottrai i soldi
		Global.monete -= data.costo
		
		# 3. Sposta l'upgrade (la tua funzione nel Global)
		Global.all_machine_unlock_upgrade(data)
		
		# 4. Aggiorna tutto
		refresh_popup()
		print("Acquisto effettuato! Monete rimanenti: ", Global.monete)
	else:
		print("Non hai abbastanza monete!")

func get_purchased_ids() -> Array:
	var ids = []
	for data in Global.all_machine_performed_upgrades:
		if data:
			ids.append(data.upgrade_id)
	return ids
