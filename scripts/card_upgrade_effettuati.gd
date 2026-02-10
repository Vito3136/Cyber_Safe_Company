extends PanelContainer

# Variabile per tracciare lo stato
var is_expanded: bool = false

# Nodi figli cruciali (Assicurati che i nomi dei percorsi siano corretti!)
@onready var description_panel: PanelContainer = $VBoxContainer/DescriptionPanel
@onready var interaction_area: Control = $VBoxContainer/MarginContainer # Usiamo il contenitore del titolo come area cliccabile

@onready var title_label: Label = $VBoxContainer/MarginContainer/Label
@onready var description_label: Label = $VBoxContainer/DescriptionPanel/MarginContainer/DescriptionLabel

func setup(data: CardData): # Deve essere scritto proprio così
	if data:
		title_label.text = data.titolo
		description_label.text = data.descrizione

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
	is_expanded = false
	
	# DEBUG: Verifica che il mouse filter sia corretto
	print("Mouse filter del PanelContainer: ", mouse_filter)
	print("Può ricevere input: ", mouse_filter != Control.MOUSE_FILTER_IGNORE)


func _gui_input(event):
	# Se l'evento è un click del mouse
	if event is InputEventMouseButton and event.pressed:
		# Se è il tasto sinistro
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Click rilevato sulla card!") # Questo ti conferma che il click passa
			_on_card_clicked() # Esegue l'apertura/chiusura
			get_viewport().set_input_as_handled() # Impedisce al click di andare altrove
