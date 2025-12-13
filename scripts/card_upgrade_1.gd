extends PanelContainer

# Variabile per tracciare lo stato
var is_expanded: bool = false
# Altezza desiderata per la parte di approfondimento (Regola questo valore in base al tuo testo)
const EXPANDED_HEIGHT: float = 180.0 
# Durata dell'animazione
const ANIMATION_DURATION: float = 0.25 

# Nodi figli cruciali (Assicurati che i nomi dei percorsi siano corretti!)
# La tua gerarchia corretta: $VBoxContainer/DescriptionPanel
@onready var description_panel: PanelContainer = $VBoxContainer/DescriptionPanel
@onready var interaction_area: Control = $VBoxContainer/MarginContainer # Usiamo il contenitore del titolo come area cliccabile

func _on_card_clicked():
	# Inverti lo stato
	is_expanded = not is_expanded

	# Applica il cambio di visibilità
	if is_expanded:
		description_panel.show()
	else:
		description_panel.hide()

	# Opzionale: Forza un aggiornamento del layout per far sì che il popup si ridimensioni
	# in base al nuovo contenuto mostrato/nascosto.
	get_parent().queue_sort()

# Called when the node enters the scene tree for the first time.
func _ready():
	# 1. Nascondi il pannello dei dettagli all'avvio.
	# Questo garantisce che la card appaia compressa (Stato Iniziale).
	description_panel.hide()
	
	print(description_panel)
	# 2. Imposta lo stato iniziale (compresso)
	is_expanded = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_description_invisible():
	# Chiamato solo quando la card si chiude
	if not is_expanded:
		description_panel.visible = false

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 2. Controlliamo se è un click sinistro del mouse (indice 1)
		# o, più in generale, il primo tocco/click (event.pressed è 'true' quando viene premuto)
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# 3. Controlliamo che la posizione del click sia all'interno dell'area del PanelContainer
			# (anche se Mouse Filter = STOP dovrebbe già assicurare che l'evento sia per noi)
			if get_rect().has_point(event.position):
				# Chiama la funzione di gestione del click/tocco
				_on_card_clicked()
				# Molto importante: marca l'evento come gestito.
				# Questo impedisce che l'input venga processato anche da altri nodi GUI.
				get_viewport().set_input_as_handled()
