extends Control

@onready var center_container = $CenterContainerNewGame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	center_container.scale = Vector2(0.20, 0.20)
	await get_tree().create_timer(0.05).timeout
	center_container.scale = Vector2(0.22, 0.22)
	await get_tree().create_timer(0.05).timeout
	if(Global.tutorial_iniziale_effettuato):
		get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/tutorial_1.tscn")
