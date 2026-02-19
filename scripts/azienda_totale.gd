extends Node

@onready var go_magazzino = $GoMagazzino
@onready var go_uffici = $GoUffici
@onready var go_sala_macchinari = $GoSalaMacchinari
@onready var go_sala_res = $GoSalaRES
@onready var go_sala_siem_soc = $GoSalaSiemSoc
@onready var go_sala_server = $GoSalaServer
@onready var back_left_button = $BackLeftButton

@onready var color_rect_maschera = $MascheraTutorial/ColorRect
@onready var maschera_tutorial = $MascheraTutorial
@onready var index_finger = $IndexFinger
@onready var animation_index = $IndexFinger/AnimationIndex
@onready var popup_tutorial = $PopupPanel
var mat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!Global.tutorial_iniziale_effettuato):
		Global.tutorial_iniziale_effettuato = true
	
	if(!Global.tutorial_totale_effettuato):
		maschera_tutorial.visible = true
		mat = color_rect_maschera.material as ShaderMaterial
		color_rect_maschera.mouse_filter = Control.MOUSE_FILTER_IGNORE
		index_finger.visible = true
		animation_index.play("pointing")
		start_tutorial()
		var target_position = Vector2(640, 520)
		popup_tutorial.position = target_position - Vector2(popup_tutorial.size) / 2
		popup_tutorial.popup()
	else:
		maschera_tutorial.visible = false
		index_finger.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# SALA MACCHINARI
func _on_go_sala_macchinari_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/sala_macchinari.tscn")

func _on_go_sala_macchinari_button_down() -> void:
	go_sala_macchinari.modulate = Color(0.7, 0.7, 0.7)

func _on_go_sala_macchinari_button_up() -> void:
	go_sala_macchinari.modulate = Color(1, 1, 1)


# SALA SERVER
func _on_go_sala_server_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/sala_server.tscn")

func _on_go_sala_server_button_down() -> void:
	go_sala_server.modulate = Color(0.7, 0.7, 0.7)

func _on_go_sala_server_button_up() -> void:
	go_sala_server.modulate = Color(1, 1, 1)


# MAGAZZINO
func _on_go_magazzino_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/magazzino.tscn")

func _on_go_magazzino_button_down() -> void:
	go_magazzino.modulate = Color(0.7, 0.7, 0.7)

func _on_go_magazzino_button_up() -> void:
	go_magazzino.modulate = Color(1, 1, 1)


# UFFICI
func _on_go_uffici_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/uffici.tscn")

func _on_go_uffici_button_down() -> void:
	go_uffici.modulate = Color(0.7, 0.7, 0.7)

func _on_go_uffici_button_up() -> void:
	go_uffici.modulate = Color(1, 1, 1)


# SALA RES
func _on_go_sala_res_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/sala_res.tscn")

func _on_go_sala_res_button_down() -> void:
	go_sala_res.modulate = Color(0.7, 0.7, 0.7)

func _on_go_sala_res_button_up() -> void:
	go_sala_res.modulate = Color(1, 1, 1)


# SALA SIEM SOC
func _on_go_sala_siem_soc_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/sala_siem_soc.tscn")

func _on_go_sala_siem_soc_button_down() -> void:
	go_sala_siem_soc.modulate = Color(0.7, 0.7, 0.7)

func _on_go_sala_siem_soc_button_up() -> void:
	go_sala_siem_soc.modulate = Color(1, 1, 1)


func _on_back_left_button_pressed() -> void:
	back_left_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	back_left_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/menu_principale.tscn")

func start_tutorial():
	var screen_size = get_viewport().get_visible_rect().size
	var pos_centro = (go_sala_res.global_position + go_sala_res.size / 2.0) / screen_size
	var dim_normalizzata = go_sala_res.size / screen_size
		
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
