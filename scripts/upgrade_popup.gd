extends PopupPanel

@onready var close_button: Button = $ContentsContainer/CloseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if close_button:
		close_button.pressed.connect(self._on_close_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_close_button_pressed() -> void:
	hide()
	
func open_popup():
	# Assicura che sia mostrato e centrato
	popup_centered_ratio(0.75)
