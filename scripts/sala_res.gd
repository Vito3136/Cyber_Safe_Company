extends Node2D

@onready var back_left_button = $BackLeftButton
@onready var upgrade_button = $UpgradeButton
@onready var upgrade_popup = $UpgradePopup

@onready var color_rect_maschera = $MascheraTutorial/ColorRect
@onready var maschera_tutorial = $MascheraTutorial
@onready var index_finger = $IndexFinger
@onready var animation_index = $IndexFinger/AnimationIndex
var mat

const MASCHERA_SCENE = preload("res://scenes/maschera_tutorial.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!Global.tutorial_totale_effettuato):
		maschera_tutorial.visible = true
		mat = color_rect_maschera.material as ShaderMaterial
		color_rect_maschera.mouse_filter = Control.MOUSE_FILTER_IGNORE
		index_finger.visible = true
		animation_index.play("pointing_2")
		var global_pos_upgrade_btn = upgrade_button.global_position
		var size_upgrade_btn = upgrade_button.size
		continue_tutorial(global_pos_upgrade_btn, size_upgrade_btn)
	else:
		maschera_tutorial.visible = false
		index_finger.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!Global.tutorial_totale_effettuato):
		if (upgrade_popup.visible && animation_index.current_animation == "pointing_2"):
			animation_index.play("pointing_3")
		elif(!upgrade_popup.visible && animation_index.current_animation == "pointing_3"):
			animation_index.play("pointing_2")

func _on_upgrade_button_pressed() -> void:
	upgrade_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	upgrade_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	# Ottieni il riferimento al nodo PopupPanel
	# $UpgradePopup usa il percorso breve del nodo figlio.
	var popup = upgrade_popup.open_popup()

	# Controlla se il popup esiste ed è istanziato
	if popup:
		# Questo metodo mostra il popup e lo centra sullo schermo.
		# Usa i margini che hai impostato per occupare i 3/4 dello schermo.
		popup.popup_centered()

func _on_back_left_button_pressed() -> void:
	back_left_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	back_left_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")

func continue_tutorial(global_pos: Vector2, size: Vector2):
	var screen_size = get_viewport().get_visible_rect().size
	var pos_centro = (global_pos + size / 2.0) / screen_size
	var dim_normalizzata = size / screen_size
		
	# Inviamo i dati allo shader
	mat.set_shader_parameter("center", pos_centro)
	mat.set_shader_parameter("size", dim_normalizzata)

func _input(event):
	if(!Global.tutorial_totale_effettuato):
		if event is InputEventMouseButton and event.pressed:
			if is_click_inside_hole(event.global_position):
				# Cerchiamo il pulsante partendo dal genitore (self o get_tree().current_scene)
				var clicked_button = find_button_at_position(get_tree().current_scene, event.global_position)
				
				if clicked_button:
					print("Pulsante trovato e cliccato: ", clicked_button.name)
					# In Godot 4 si usa .emit(), in Godot 3 .emit_signal("pressed")
					clicked_button.button_down.emit()
					clicked_button.pressed.emit() 
					
					# Opzionale: consuma l'evento
					get_viewport().set_input_as_handled()
			else:
				# Fuori dal buco blocchiamo tutto
				print("fuori")
				get_viewport().set_input_as_handled()

func is_click_inside_hole(click_pos: Vector2) -> bool:
	var center = mat.get_shader_parameter("center")
	var size_p = mat.get_shader_parameter("size")
	var screen_size = get_viewport().get_visible_rect().size
	
	# Calcoliamo il rettangolo del buco in pixel reali
	var rect = Rect2(
		(center.x - size_p.x / 2.0) * screen_size.x,
		(center.y - size_p.y / 2.0) * screen_size.y,
		size_p.x * screen_size.x,
		size_p.y * screen_size.y
	)
	return rect.has_point(click_pos)

func find_button_at_position(node: Node, pos: Vector2) -> Button:
	# Se il nodo è un bottone, è visibile e il click è dentro la sua area
	if node is Button and node.is_visible_in_tree():
		if node.get_global_rect().has_point(pos):
			return node
	
	# Altrimenti, controlla i figli di questo nodo
	for child in node.get_children():
		var found = find_button_at_position(child, pos)
		if found:
			return found
			
	return null
