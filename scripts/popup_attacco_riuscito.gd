extends CanvasLayer

@onready var popup = $PopupPanel
@onready var label_testo = $PopupPanel/MarginContainer/VBoxContainer/ContentLabel
@onready var timer = $Timer
@onready var colorRect = $ColorRect
@onready var ok_button = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer/OkButton
@onready var audio_stream_player = $PopupPanel/AudioStreamPlayer

var apparizione_attuale: int = 0
var testi = [
	"An attacker moved laterally through your network for days without triggering a single alert. By the time the breach was discovered, significant damage had already been done. The incident response has drained -30% of your current funds. A SIEM system would have flagged the anomaly on day one.",
	"A malicious link clicked by one of your employees allowed a virus to spread across multiple workstations and reach your servers before anyone noticed. Containment and recovery operations have cost your company -40% of your current funds. EDR Software would have isolated the threat before it ever left the first machine.",
	"An unauthorized individual gained physical access to your server room and tampered with critical hardware. The damage has cost your company -45% of your current funds. Biometric Access Control would have stopped them at the door.",
	"A hacker successfully infiltrated your network through a disguised malicious packet that your basic firewall failed to detect. Sensitive data was compromised and recovery operations have cost your company -50% of your current funds. A Next-Gen Hardware Firewall would have stopped this before it even got close.",
	"Malware struck your primary server and brought it offline. With no backup system in place, operations halted completely until the server could be restored. The downtime and recovery costs have drained -50% of your current funds. RAID Redundancy would have kept everything running without missing a beat.",
	"An attacker gained access to your systems using a stolen employee password. With no second verification layer in place, the breach went undetected until it was too late. The damage control has drained -50% of your current funds. MFA would have blocked the intrusion instantly.",
	"A hostile IP gained access to your systems and had several minutes to operate freely before your team was even aware of the intrusion. The damage caused has cost your company -55% of your current funds. The SOAR module would have blocked the connection in seconds — automatically.",
	"A compromised employee account was used to exfiltrate confidential data from inside your network. Because no behavioral monitoring was in place, the anomaly went completely unnoticed. The financial fallout has cost your company -60% of your current funds. UEBA would have flagged this in seconds."
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
	
	apparizione_attuale = Global.apparizione_attuale_riuscito
	
	# Colleghiamo il segnale del timer
	timer.timeout.connect(_on_timer_timeout)
	
	if apparizione_attuale < intervalli.size():
		avvia_prossimo_timer()

func avvia_prossimo_timer():
	if apparizione_attuale < intervalli.size():
		if Global.timer_residuo_riuscito > 0:
			timer.wait_time = Global.timer_residuo_riuscito
			Global.timer_residuo_riuscito = 0
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
			
	if purchased_upgrade:
		print("Upgrade già effettuato per: ", id_da_controllare, ". Salto il popup dell'attacco riuscito.")
		apparizione_attuale += 1
		avvia_prossimo_timer()
		return
	
	applica_penale_economica(apparizione_attuale)
	
	label_testo.text = testi[apparizione_attuale]
	colorRect.show()
	audio_stream_player.play()
	popup.popup_centered() 
	apparizione_attuale += 1
	
	Global.apparizione_attuale_riuscito = apparizione_attuale 
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

func applica_penale_economica(indice_attacco):
	var percentuale_da_togliere : float = 0.0
	
	match indice_attacco:
		0: percentuale_da_togliere = 0.30 # -30% (Siem 1)
		1: percentuale_da_togliere = 0.40 # -40% (EDR)
		2: percentuale_da_togliere = 0.45 # -45% (Biometric)
		3: percentuale_da_togliere = 0.50 # -50% (Firewall)
		4: percentuale_da_togliere = 0.50 # -50% (RAID)
		5: percentuale_da_togliere = 0.50 # -50% (MFA)
		6: percentuale_da_togliere = 0.55 # -55% (SOAR)
		7: percentuale_da_togliere = 0.60 # -60% (UEBA)
	
	var perdita = int(Global.monete * percentuale_da_togliere)
	Global.monete -= perdita
	
	# Emetti il segnale per aggiornare la UI delle monete subito
	Global.update_monete.emit(Global.monete)
	
	print("ATTACCO RIUSCITO! Persi: ", perdita, " monete. Saldo attuale: ", Global.monete)
