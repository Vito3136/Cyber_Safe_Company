extends Control

@onready var center_container = $CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_pressed() -> void:
	center_container.scale = Vector2(0.28, 0.28)
	await get_tree().create_timer(0.05).timeout
	center_container.scale = Vector2(0.35, 0.35)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/tutorial_2.tscn")
