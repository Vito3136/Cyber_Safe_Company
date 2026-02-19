extends PopupPanel

@onready var ok_button = $MarginContainer/VBoxContainer/OkButton
@onready var popup = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if popup:
		popup.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ok_button_pressed() -> void:
	ok_button.pivot_offset = ok_button.size / 2
	ok_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	ok_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	popup.hide()
