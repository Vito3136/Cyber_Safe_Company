extends Sprite2D

@onready var anim_macchinario = $AnimationMacchinarioPrese
@onready var anim_presa = $Presa/AnimationPresa
@onready var presa = $Presa

# 1. Creiamo due variabili "esportate". 
# Questo farà apparire due caselle vuote nell'Inspector di Godot!
@export var texture_vuota : Texture2D
@export var texture_piena : Texture2D
@export var scatolo_prese : Node2D
@export var anim_scatolo : AnimationPlayer

# Configurazione modificabile dall'Inspector
@export var tempo_produzione : float = 5.0
@export var capienza_massima : int = 3

@onready var timer = $Timer
@export var label_contatore_prese : Label

# Variabili interne
var prese_attuali : int = 0
var is_full : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_produzione()
	# Impostiamo il timer con il tempo scelto
	timer.wait_time = tempo_produzione
	
	# Aggiorniamo la scritta iniziale
	aggiorna_interfaccia()
	
	# Facciamo partire la produzione (se non hai messo Autostart)
	timer.start()
	
	
	
	#await get_tree().create_timer(9.0).timeout
	#stop_produzione()

func start_produzione():
	presa.visible = true
	anim_macchinario.play("produzione")
	anim_presa.play("spostamento_presa")
	scatolo_prese.texture = texture_vuota

func stop_produzione():
	anim_macchinario.stop()
	anim_presa.stop()
	presa.visible = false
	scatolo_prese.texture = texture_piena
	anim_scatolo.play("scatolo_pieno")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Questa funzione viene chiamata automaticamente dal Timer ogni 5 secondi
func _on_timer_timeout():
	# Se siamo già pieni, non facciamo nulla (sicurezza extra)
	if is_full:
		return

	# Produci una presa
	prese_attuali += 1
	
	# Aggiorna la grafica
	aggiorna_interfaccia()
	
	# Controlla se abbiamo raggiunto il limite
	if prese_attuali >= capienza_massima:
		macchinario_pieno()

func macchinario_pieno():
	is_full = true
	timer.stop() # FERMA IL TIMER: Smette di produrre
	
	# Qui puoi cambiare colore o mostrare un'icona "FULL"
	stop_produzione() # Esempio: diventa rossiccio

func aggiorna_interfaccia():
	# Scrive ad esempio "3 / 10"
	label_contatore_prese.text = str(prese_attuali) + " / " + str(capienza_massima)

# Funzione per raccogliere le prese (collegata all'Area2D)
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		raccogli_tutto()

func raccogli_tutto():
	if prese_attuali == 0:
		return # Niente da raccogliere

	# Aggiungi al globale
	#Global.aggiungi_monete(prese_attuali * 10) # Esempio: 10 monete a presa
	
	# Resetta il macchinario
	prese_attuali = 0
	is_full = false
	start_produzione() # Torna colore normale
	
	aggiorna_interfaccia()
	
	# IMPORTANTE: Riavvia il timer se era fermo!
	if timer.is_stopped():
		timer.start()
