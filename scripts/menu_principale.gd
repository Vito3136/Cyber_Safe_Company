extends Control

@onready var center_container_new_game = $CenterContainerNewGame
@onready var center_container_continue_game = $CenterContainerContinueGame
@onready var continue_button = $CenterContainerContinueGame/ContinueGameButton
var path = "user://savegame.data"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(path):
		continue_button.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.

func _on_continue_game_button_pressed() -> void:
	GlobalAudioStreamPlayer.play()
	center_container_continue_game.scale = Vector2(0.20, 0.20)
	await get_tree().create_timer(0.05).timeout
	center_container_continue_game.scale = Vector2(0.22, 0.22)
	await get_tree().create_timer(0.05).timeout
	
	Global.load_game()
	
	if(Global.tutorial_iniziale_effettuato):
		get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/tutorial_1.tscn")


func _on_new_game_button_pressed() -> void:
	GlobalAudioStreamPlayer.play()
	center_container_new_game.scale = Vector2(0.20, 0.20)
	await get_tree().create_timer(0.05).timeout
	center_container_new_game.scale = Vector2(0.22, 0.22)
	await get_tree().create_timer(0.05).timeout
	
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	
	get_tree().change_scene_to_file("res://scenes/tutorial_1.tscn")
