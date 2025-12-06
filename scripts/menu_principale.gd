extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	# Carica la scena del tuo gioco vero e proprio.
	# Assicurati di mettere il percorso corretto del tuo file .tscn
	get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
