extends CanvasLayer

@onready var title_label = $PopupPanel/MarginContainer/VBoxContainer/TitleLabel
@onready var content_label = $PopupPanel/MarginContainer/VBoxContainer/ContentLabel
@onready var green_label = $PopupPanel/MarginContainer/VBoxContainer/ContentLabel2
@onready var yellow_label = $PopupPanel/MarginContainer/VBoxContainer/ContentLabel3
@onready var red_label = $PopupPanel/MarginContainer/VBoxContainer/ContentLabel4
@onready var popup = $PopupPanel
@onready var colorRect = $ColorRect
@onready var audio_stream_player = $PopupPanel/AudioStreamPlayer
@onready var continue_button = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer/ContinueButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if popup:
		popup.hide()
		colorRect.hide()
		
		popup.popup_hide.connect(_on_popup_panel_hide)
	
	Global.end_game.connect(_show_end_game_popup)

func _show_end_game_popup():
	var total_counter = Global.contatore_verde + Global.contatore_giallo + Global.contatore_rosso
	var perc_contatore_verde = (float(Global.contatore_verde) / total_counter) * 100
	var perc_contatore_giallo = (float(Global.contatore_giallo) / total_counter) * 100
	var perc_contatore_rosso = (float(Global.contatore_rosso) / total_counter) * 100
	if perc_contatore_verde >= 70:
		title_label.text = "Outstanding Security Balance!"
		title_label.add_theme_color_override("font_color", Color("00ff00"))
		content_label.text = "The game is done! Congratulations!
		
		You ran this company the right way. Throughout the entire game, you kept your production and security investments in sync — growing your factory without ever leaving it exposed. This is exactly how real companies should operate: every expansion matched by a layer of protection. Your company is not just profitable. It's resilient. Well done.\n"
		green_label.text = "Green status bar perc: %.2f%%" % perc_contatore_verde
		yellow_label.text = "Yellow status bar perc: %.2f%%" % perc_contatore_giallo
		red_label.text = "Red status bar perc: %.2f%%" % perc_contatore_rosso
	elif perc_contatore_rosso >= 30 or perc_contatore_verde < 40:
		title_label.text = "Dangerously Unbalanced!"
		title_label.add_theme_color_override("font_color", Color("ff4233"))
		content_label.text = "The game is done.
		
		Your company grew — but not safely. For most of the game, your production and security investments were severely out of sync. A business that expands without protecting itself is a prime target for attackers, while one that over-invests in security without generating revenue won't last long either. In the real world, this approach leads to breaches, financial losses, and reputational damage. You made it to the end — but next time, remember: a strong company is a balanced one.\n"
		
		green_label.text = "Green status bar perc: %.2f%%" % perc_contatore_verde
		yellow_label.text = "Yellow status bar perc: %.2f%%" % perc_contatore_giallo
		red_label.text = "Red status bar perc: %.2f%%" % perc_contatore_rosso
	else:
		title_label.text = "Room for Improvement"
		title_label.add_theme_color_override("font_color", Color("ffea00"))
		content_label.text = "The game is done!
		
		You built a solid company, but your investments were often out of balance. There were stretches where production ran ahead of security — or where you focused so much on protection that your output suffered. In the real world, both gaps are dangerous: an unprotected company is a target, but an unprofitable one can't survive either. Next time, try to keep both sides of your business growing together.\n"
		green_label.text = "Green status bar perc: %.2f%%" % perc_contatore_verde
		yellow_label.text = "Yellow status bar perc: %.2f%%" % perc_contatore_giallo
		red_label.text = "Red status bar perc: %.2f%%" % perc_contatore_rosso
	
	colorRect.show()
	audio_stream_player.play()
	popup.popup_centered()

func _on_popup_panel_hide():
	# Quando il popup si chiude (in qualsiasi modo), nascondiamo lo sfondo
	colorRect.hide()
	
	Global.save_game()

func _on_continue_button_pressed() -> void:
	continue_button.pivot_offset = continue_button.size / 2
	continue_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	continue_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	popup.hide()
	colorRect.hide()
	Global.save_game()
