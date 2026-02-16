extends Resource
class_name CardData

@export var titolo: String = ""
@export_multiline var descrizione: String = ""
@export var costo: int = 0

## L'identificativo unico di questo upgrade (es: "presa_liv_1")
@export var upgrade_id: String = ""
## L'ID richiesto per sbloccare questo upgrade (es: lasciarlo vuoto per il primo livello)
@export var required_id: String = ""
## Inserisci qui il nome di un evento che deve essere nel Global.eventi_completati
@export var required_event: String = ""
