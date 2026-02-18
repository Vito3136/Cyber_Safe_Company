extends PanelContainer

# Variabile per tracciare lo stato
var is_expanded: bool = false

# Nodi figli cruciali (Assicurati che i nomi dei percorsi siano corretti!)
@onready var description_panel: PanelContainer = $VBoxContainer/DescriptionPanel
@onready var interaction_area: Control = $VBoxContainer/MarginContainer # Usiamo il contenitore del titolo come area cliccabile

@onready var h_box_container: HBoxContainer = $VBoxContainer/MarginContainer/HBoxContainer
@onready var margin_container: MarginContainer = $VBoxContainer/MarginContainer
@onready var title_label: Label = $VBoxContainer/MarginContainer/HBoxContainer/Label
@onready var description_label: Label = $VBoxContainer/DescriptionPanel/MarginContainer/DescriptionLabel
@onready var option_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/OptionButton

func setup(data: CardData): # Deve essere scritto proprio così
	if data:
		title_label.text = data.titolo
		description_label.text = data.descrizione

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	# Imposta il pivot esattamente a metà della dimensione attuale
	option_button.pivot_offset = option_button.size / 2
	# 1. Nascondi il pannello dei dettagli all'avvio.
	# Questo garantisce che la card appaia compressa (Stato Iniziale).
	description_panel.hide()
	is_expanded = false

func _on_option_button_pressed() -> void:
	# Inverti lo stato
		
	option_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	option_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
		
	is_expanded = not is_expanded
	
	var margin_container = $VBoxContainer/MarginContainer

	# Applica il cambio di visibilità
	if is_expanded:
		description_panel.show()
	else:
		description_panel.hide()

	# Opzionale: Forza un aggiornamento del layout per far sì che il popup si ridimensioni
	# in base al nuovo contenuto mostrato/nascosto.
	get_parent().queue_sort()
