extends Node2D

@onready var back_left_button = $BackLeftButton
@onready var upgrade_button = $UpgradeButton
@onready var upgrade_popup = $UpgradePopup
@onready var polygon_2d_animation = $Polygon2D/AnimationPlayer
@onready var polygon_2d_2_animation = $Polygon2D2/AnimationPlayer2
@onready var polygon_2d_3_animation = $Polygon2D3/AnimationPlayer3
@onready var polygon_2d_4_animation = $Polygon2D4/AnimationPlayer4
@onready var polygon_2d_5_animation = $Polygon2D5/AnimationPlayer5
@onready var polygon_2d_6_animation = $Polygon2D6/AnimationPlayer6
@onready var polygon_2d_7_animation = $Polygon2D7/AnimationPlayer7
@onready var polygon_2d_8_animation = $Polygon2D8/AnimationPlayer8
@onready var polygon_2d_9_animation = $Polygon2D9/AnimationPlayer9
@onready var polygon_2d_10_animation = $Polygon2D10/AnimationPlayer10
@onready var polygon_2d_11_animation = $Polygon2D11/AnimationPlayer11
@onready var polygon_2d_12_animation = $Polygon2D12/AnimationPlayer12
@onready var polygon_2d_13_animation = $Polygon2D13/AnimationPlayer13
@onready var polygon_2d_14_animation = $Polygon2D14/AnimationPlayer14
@onready var polygon_2d_15_animation = $Polygon2D15/AnimationPlayer2
@onready var polygon_2d_16_animation = $Polygon2D16/AnimationPlayer2
@onready var polygon_2d_17_animation = $Polygon2D17/AnimationPlayer2
@onready var polygon_2d_18_animation = $Polygon2D18/AnimationPlayer2
@onready var polygon_2d_19_animation = $Polygon2D19/AnimationPlayer2
@onready var polygon_2d_20_animation = $Polygon2D20/AnimationPlayer2
@onready var polygon_2d_21_animation = $Polygon2D21/AnimationPlayer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d_animation.play("blink")
	polygon_2d_9_animation.play("blink_9")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_18_animation.play("blink_18")
	polygon_2d_11_animation.play("blink_11")
	polygon_2d_2_animation.play("blink_2")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_3_animation.play("blink_3")
	polygon_2d_7_animation.play("blink_7")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_16_animation.play("blink_16")
	polygon_2d_4_animation.play("blink_4")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_8_animation.play("blink_8")
	polygon_2d_5_animation.play("blink_5")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_17_animation.play("blink_17")
	polygon_2d_6_animation.play("blink_6")
	polygon_2d_10_animation.play("blink_10")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_21_animation.play("blink_21")
	polygon_2d_15_animation.play("blink_15")
	polygon_2d_12_animation.play("blink_12")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_19_animation.play("blink_19")
	polygon_2d_13_animation.play("blink_13")
	await get_tree().create_timer(0.1).timeout
	polygon_2d_20_animation.play("blink_20")
	polygon_2d_14_animation.play("blink_14")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_upgrade_button_pressed() -> void:
	upgrade_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	upgrade_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	
	var popup = upgrade_popup.open_popup()
	if popup:
		popup.popup_centered()

func _on_back_left_button_pressed() -> void:
	back_left_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	back_left_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/azienda_totale.tscn")
