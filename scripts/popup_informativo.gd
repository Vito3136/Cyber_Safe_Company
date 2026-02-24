extends CanvasLayer

@onready var popup = $PopupPanel
@onready var label_testo = $PopupPanel/MarginContainer/VBoxContainer/ContentLabel
@onready var timer = $Timer
@onready var colorRect = $ColorRect
@onready var ok_button = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer/OkButton
@onready var upgrade_button = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer/UpgradeButton
@onready var audio_stream_player = $PopupPanel/AudioStreamPlayer

var apparizione_attuale: int = 0
var upgrade_id: String
var testi = [
	"You can't defend what you can't see. Without a SIEM system, threats can move freely inside your network for days — or weeks — before anyone notices. Level 1 starts collecting and correlating logs from every system in your infrastructure, giving you full visibility into what's really happening inside your company.",
	"A single employee clicking the wrong link is all it takes to compromise your entire network. EDR software monitors every device in real time and isolates infected machines the moment suspicious behavior is detected — before the threat can spread to your servers or other workstations. One click shouldn't cost you everything.",
	"Your server room contains the most critical infrastructure in your company — and right now, anyone with a keycard can walk in. Biometric Access Control replaces traditional credentials with retina and fingerprint scanners, ensuring that only verified personnel can ever gain physical access. Because some threats don't come through a cable.",
	"Not all threats announce themselves. Hackers hide malicious code inside perfectly normal-looking traffic, slipping past basic defenses undetected. A Next-Gen Hardware Firewall inspects every single packet entering your network and shuts down threats before they even get close to your servers. Don't leave your front door unguarded.",
	"What happens to your business if your main server goes down? Without redundancy, the answer is: everything stops. RAID/Cluster Redundancy mirrors your data across multiple systems so that if one server is hit by malware or hardware failure, another takes over instantly — zero downtime, zero data loss.",
	"Passwords alone are not enough anymore. They get phished, leaked, and guessed every single day. MFA adds a second layer of protection that stops unauthorized access cold — even if an attacker already has your credentials. It's one of the cheapest upgrades available, and one of the most powerful.",
	"When a threat is detected, every second counts. Manual response takes time your company doesn't have. The SOAR module automates your entire threat response workflow — hostile IP detected, firewall updated, threat neutralized. All of it, before a human even reads the alert.",
	"Sometimes the threat is already inside. A compromised employee account looks completely legitimate to traditional security tools — same username, same password, full access. UEBA learns how each person in your company normally behaves and raises the alarm the moment something feels off. Because the details are what give attackers away."
]
var upgrade_ids_correlati = [
	"siem_1",
	"edr",
	"biometric",
	"firewall",
	"redundancy_system",
	"mfa",
	"soar",
	"ueba"
]
var intervalli = [240.0, 900.0, 900.0, 900.0, 900.0, 900.0, 900.0, 900.0]

func _ready():
	if popup:
		popup.hide()
		colorRect.hide()
		
		popup.popup_hide.connect(_on_popup_panel_hide)
		
	await get_tree().process_frame
	
	apparizione_attuale = Global.apparizione_attuale_informativo
	
	# Colleghiamo il segnale del timer
	timer.timeout.connect(_on_timer_timeout)
	
	if apparizione_attuale < intervalli.size() and Global.tutorial_totale_effettuato:
		avvia_prossimo_timer()
	else:
		Global.tutorial_finito.connect(_on_tutorial_finito_dal_segnale)

func _on_tutorial_finito_dal_segnale():
	avvia_prossimo_timer()

func avvia_prossimo_timer():
	if apparizione_attuale < intervalli.size():
		if Global.timer_residuo_informativo > 0:
			timer.wait_time = Global.timer_residuo_informativo
			Global.timer_residuo_informativo = 0
		else:
			timer.wait_time = intervalli[apparizione_attuale]
		timer.one_shot = true
		timer.start()
		print("Prossimo consiglio tra: ", timer.wait_time, " secondi.")

func _on_timer_timeout():
	# 1. Controlliamo se l'upgrade relativo a questo consiglio è già stato fatto
	upgrade_id = upgrade_ids_correlati[apparizione_attuale]
	
	var purchased_upgrade = false
	for up in Global.office_performed_upgrades:
		if up.upgrade_id == upgrade_id:
			purchased_upgrade = true
			break
			
	for up in Global.server_room_performed_upgrades:
		if up.upgrade_id == upgrade_id:
			purchased_upgrade = true
			break
			
	for up in Global.siem_room_performed_upgrades:
		if up.upgrade_id == upgrade_id:
			purchased_upgrade = true
			break
			
	if purchased_upgrade:
		print("Upgrade già effettuato per: ", upgrade_id, ". Salto il popup informativo.")
		apparizione_attuale += 1
		avvia_prossimo_timer()
		return 
	
	label_testo.text = testi[apparizione_attuale]
	colorRect.show()
	audio_stream_player.play()
	popup.popup_centered()
	apparizione_attuale += 1
	
	Global.apparizione_attuale_informativo = apparizione_attuale
	Global.save_game()

# --- FUNZIONI PER I PULSANTI ---

func _on_ok_button_pressed() -> void:
	ok_button.pivot_offset = ok_button.size / 2
	ok_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	ok_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	popup.hide()
	colorRect.hide()
	avvia_prossimo_timer()
	Global.save_game()

func _on_upgrade_button_pressed() -> void:
	upgrade_button.pivot_offset = upgrade_button.size / 2
	upgrade_button.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(0.05).timeout
	upgrade_button.scale = Vector2(1, 1)
	await get_tree().create_timer(0.05).timeout
	popup.hide()
	colorRect.hide()
	
	if (upgrade_id == "siem_1" || upgrade_id == "soar" || upgrade_id == "ueba"):
		get_tree().change_scene_to_file("res://scenes/sala_siem_soc.tscn")
	elif (upgrade_id == "edr" || upgrade_id == "mfa"):
		get_tree().change_scene_to_file("res://scenes/uffici.tscn")
	elif (upgrade_id == "firewall" || upgrade_id == "redundancy_system" || upgrade_id == "biometric"):
		get_tree().change_scene_to_file("res://scenes/sala_server.tscn")
	avvia_prossimo_timer()
	Global.save_game()

func _on_popup_panel_hide():
	# Quando il popup si chiude (in qualsiasi modo), nascondiamo lo sfondo
	colorRect.hide()
	
	if timer.is_stopped():
		avvia_prossimo_timer()
	Global.save_game()
