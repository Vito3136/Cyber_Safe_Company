extends CanvasLayer

@onready var popup = $PopupPanel
@onready var label_testo = $PopupPanel/MarginContainer/VBoxContainer/ContentLabel
@onready var timer = $Timer
@onready var colorRect = $ColorRect
@onready var ok_button = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer/OkButton
@onready var audio_stream_player = $PopupPanel/AudioStreamPlayer

var apparizione_attuale: int = 0
var testi = [
	"Suspicious activity was detected moving through your network. Your SIEM system correlated the logs, identified the threat pattern, and raised the alarm in time for it to be neutralized. Without full visibility, this one would have gone completely unnoticed.",
	"A malicious link was clicked by one of your employees. Your EDR software detected the threat instantly, isolated the infected machine, and prevented the virus from spreading to the rest of your network. Crisis averted — your systems are clean.",
	"An unauthorized individual attempted to access your server room. Your biometric scanner rejected the entry attempt immediately — no keycard to steal, no PIN to guess. Physical access denied.",
	"An external intrusion attempt was detected and blocked. Your Next-Gen Hardware Firewall analyzed the incoming traffic, identified the malicious payload hidden inside, and shut it down before it could reach your servers. Your investment just paid off.",
	"Malware targeted your primary server and took it offline. Your redundancy system switched operations to the backup cluster instantly, with no interruption to your business. The threat was contained and the primary server restored without any data loss.",
	"Someone tried to access your systems using stolen employee credentials. Thanks to Multi-Factor Authentication, the login was denied — the attacker had the password, but couldn't get past the second verification step. Your accounts are safe.",
	"A hostile IP attempted to infiltrate your infrastructure. Your SOAR module identified the threat, updated the firewall rules, and blocked the connection — all within seconds, and without any human intervention required. Automated defense at its finest.",
	"Unusual activity was detected on one of your employee accounts — login from an unexpected location at an unusual hour. Your UEBA system flagged the anomaly instantly and blocked the session before any data could be accessed. Without it, this one would have slipped through unnoticed."
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
var intervalli = [630.0, 900.0, 900.0, 900.0, 900.0, 900.0, 900.0, 900.0]

func _ready():
	
	if popup:
		popup.hide()
		colorRect.hide()
		
		popup.popup_hide.connect(_on_popup_panel_hide)
		
	await get_tree().process_frame
	
	apparizione_attuale = Global.apparizione_attuale_tentato
	
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
		if Global.timer_residuo_tentato > 0:
			timer.wait_time = Global.timer_residuo_tentato
			Global.timer_residuo_tentato = 0
		else:
			timer.wait_time = intervalli[apparizione_attuale]
		timer.one_shot = true
		timer.start()
		print("Prossimo consiglio tra: ", timer.wait_time, " secondi.")

func _on_timer_timeout():
	# 1. Controlliamo se l'upgrade relativo a questo consiglio è già stato fatto
	var id_da_controllare = upgrade_ids_correlati[apparizione_attuale]
	
	var purchased_upgrade = false
	for up in Global.office_performed_upgrades:
		if up.upgrade_id == id_da_controllare:
			purchased_upgrade = true
			break
			
	for up in Global.server_room_performed_upgrades:
		if up.upgrade_id == id_da_controllare:
			purchased_upgrade = true
			break
			
	for up in Global.siem_room_performed_upgrades:
		if up.upgrade_id == id_da_controllare:
			purchased_upgrade = true
			break
			
	if !purchased_upgrade:
		print("Upgrade non effettuato per: ", id_da_controllare, ". Salto il popup dell'attacco tentato.")
		apparizione_attuale += 1
		avvia_prossimo_timer()
		return
	
	label_testo.text = testi[apparizione_attuale]
	colorRect.show()
	audio_stream_player.play()
	popup.popup_centered() 
	apparizione_attuale += 1
	
	Global.apparizione_attuale_tentato = apparizione_attuale
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

func _on_popup_panel_hide():
	# Quando il popup si chiude (in qualsiasi modo), nascondiamo lo sfondo
	colorRect.hide()
	
	# IMPORTANTE: Se il popup è stato chiuso cliccando fuori e non dai tasti,
	# dobbiamo assicurarci che il timer per il prossimo consiglio riparta comunque.
	if timer.is_stopped():
		avvia_prossimo_timer()
	Global.save_game()
