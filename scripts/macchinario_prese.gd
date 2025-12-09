extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinarioPrese
@onready var anim_presa = $Presa/AnimationPresa


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_produzione()

func start_produzione():
	anim_macchinario.play("produzione")
	anim_presa.play("spostamento_presa")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
