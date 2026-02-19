extends PanelContainer

var is_expanded: bool = false
signal requested_purchase(data: CardData)
signal animation_stop_requested
var card_data_attiva: CardData

const COLOR_ACTIVE = Color("ffb000d2")
const COLOR_LOCKED = Color("ffb00069")

@export var upgrade_id: String
@export var required_id: String
@export var is_unlocked: bool = false

# Nodi figli cruciali (Assicurati che i nomi dei percorsi siano corretti!)
@onready var description_panel: PanelContainer = $VBoxContainer/DescriptionPanel
@onready var interaction_area: Control = $VBoxContainer/MarginContainer # Usiamo il contenitore del titolo come area cliccabile

@onready var title_label: Label = $VBoxContainer/MarginContainer/HBoxContainer/Label
@onready var description_label: Label = $VBoxContainer/DescriptionPanel/MarginContainer/DescriptionLabel
@onready var buy_button: Button = $VBoxContainer/CenterContainer/BuyButton
@onready var option_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	var style_box = get_theme_stylebox("panel").duplicate()
	add_theme_stylebox_override("panel", style_box)
	
	await get_tree().process_frame
	
	option_button.pivot_offset = option_button.size / 2
	
	description_panel.hide()
	is_expanded = false
	
	update_appearance()

func setup(data: CardData):
	if data:
		card_data_attiva = data
		title_label.text = data.titolo
		description_label.text = data.descrizione
		
		upgrade_id = data.upgrade_id
		required_id = data.required_id
		
		update_appearance()

func _on_buy_button_pressed():
	if not is_unlocked: return
	
	if !Global.tutorial_totale_effettuato:
		animation_stop_requested.emit()
	
	await get_tree().create_timer(0.5).timeout
	
	requested_purchase.emit(card_data_attiva)
	Global.save_game()

func update_appearance():
	var sb = get_theme_stylebox("panel") as StyleBoxFlat
	if not sb: return

	if is_unlocked:
		buy_button.text = "BUY (" + str(card_data_attiva.costo) + ")"
		
		if sb.bg_color != COLOR_ACTIVE:
			var tween = create_tween()
			tween.tween_property(sb, "bg_color", COLOR_ACTIVE, 0.25).set_trans(Tween.TRANS_CUBIC)
		
		if Global.monete >= card_data_attiva.costo:
			buy_button.disabled = false
			
		else:
			buy_button.disabled = true
	else:
		buy_button.text = str(card_data_attiva.costo)
		sb.bg_color = COLOR_LOCKED
		buy_button.disabled = true

func _on_option_button_pressed() -> void:
	option_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	option_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
		
	is_expanded = not is_expanded
	
	var margin_container = $VBoxContainer/MarginContainer

	# Applica il cambio di visibilità
	if is_expanded:
		description_panel.show()
		margin_container.add_theme_constant_override("margin_bottom", 10)
	else:
		description_panel.hide()
		margin_container.add_theme_constant_override("margin_bottom", 0)

	get_parent().queue_sort()
