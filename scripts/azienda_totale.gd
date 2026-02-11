extends Node

@onready var go_magazzino = $GoMagazzino
@onready var go_uffici = $GoUffici
@onready var go_sala_macchinari = $GoSalaMacchinari
@onready var go_sala_res = $GoSalaRES
@onready var go_sala_siem_soc = $GoSalaSiemSoc
@onready var go_sala_server = $GoSalaServer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
