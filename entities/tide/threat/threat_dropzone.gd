class_name ThreatCardDropzone
extends CardDropzone


@export var tide: Tide


func add_card(card_: Card) -> void:
	super(card_)
	tide.board.card_pile.remove_child(card_)
	card_.target_position = Vector2()
	card_.position = Vector2()
	add_child(card_)
	
func card_dropped(card_ : Card):
	super(card_)
	can_drop_card(card_)
	
func _on_gui_input(event_: InputEvent) -> void:
	if event_ is InputEventMouseButton and event_.button_index == MOUSE_BUTTON_LEFT:
		if event_.pressed:
			if tide.board.bank.selected_damage_token != null:
				apply_selected_damage_token()
	
func apply_selected_damage_token() -> void:
	var token = tide.board.bank.selected_damage_token
	var card = get_child(0)
	card.threat_resource.wound_int += token.value_int
	card.update_threat_health_token()
	tide.board.bank.remove_selected_damage_token()
	threat_eliminated()
	
func threat_eliminated() -> void:
	var card = get_child(0)
	if card.threat_resource.wound_int < card.threat_resource.health_int: return
	card.threat_resource.reset()
	tide.active_dropzones_threats.erase(self)
	visible = false
	remove_child(card)
	tide.board.card_pile.add_child(card)
	#card.swith_side()
	tide.board.card_pile.set_card_pile(card, FrameworkSettings.PileType.HAND)
