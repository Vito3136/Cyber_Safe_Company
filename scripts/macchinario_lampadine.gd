extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinario

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_produzione()

func start_produzione():
	anim_macchinario.play("produzione")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
