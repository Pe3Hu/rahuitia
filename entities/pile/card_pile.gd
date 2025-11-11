class_name CardPile 
extends Control


#region signal
signal draw_updated
signal hand_updated
signal play_updated
signal discard_updated
signal card_removed_from_dropzone(dropzone : CardDropzone, card: Card)
signal card_added_to_dropzone(dropzone : CardDropzone, card: Card)
signal card_hovered(card: Card)
signal card_unhovered(card: Card)
signal card_clicked(card: Card)
signal card_dropped(card: Card)
signal card_removed_from_game(card: Card)
#endregion

@export var bank: Bank
@export var default_core_deck: DeckResource
@export var card_scene: PackedScene

#region pile vars
@export_group("Pile Positions")
@export var draw_position: Vector2 = Vector2(20, 460)
@export var hand_position: Vector2 = Vector2(630, 460)
@export var play_position: Vector2 = Vector2(1250, 460)
@export var discard_position: Vector2 = Vector2(1550, 460)

@export_group("Pile Displays")
@export var stack_display_gap: int = 8
@export var max_stack_display: int = 6

@export_group("Cards")
@export var card_return_speed: float = 0.15

@export_group("Draw Pile")
@export var click_draw_pile_to_draw: bool = true
@export var cant_draw_at_hand_limit: bool = true
@export var shuffle_discard_on_empty_draw: bool = true
@export var draw_direction: FrameworkSettings.PileDirection = FrameworkSettings.PileDirection.UP

@export_group("Hand Pile")
@export var hand_enabled: bool = true
@export var hand_face_up: bool = true
@export var max_hand_size: int = 10 # if any more cards are added to the hand, they are immediately discarded
@export var max_hand_spread: float = 700
@export var card_hover_distance: float = 30
@export var drag_when_clicked: bool = true
## This works best as a 2-point linear rise from -X to +X
@export var hand_rotation_curve: Curve
## This works best as a 3-point ease in/out from 0 to X to 0
@export var hand_vertical_curve: Curve
#@export var drag_sort_enabled:  = true this would be nice to have, but based on how dragging works I'm not 100% sure how to handle it, possibly disable mouse input on the card being dragged? 

@export_group("Discard Pile")
@export var discard_face_up: bool = true
@export var discard_layout: FrameworkSettings.PileDirection = FrameworkSettings.PileDirection.UP

@export_group("Play Pile")
@export var play_stack_display_gap: float = 48
@export var play_face_up: bool = true
@export var play_layout: FrameworkSettings.PileDirection = FrameworkSettings.PileDirection.DOWN
#endregion

#region array
var card_database: Array[JSON]
var card_collection: Array[JSON]

var play_cards: Array[Card]
var hand_cards: Array[Card]
var draw_cards: Array[Card]
var discard_cards: Array[Card]
#endregion

var spread_curve:  = Curve.new()


#region set get card
# this is really the only way we should move cards between piles
func set_card_pile(card_: Card, pile_type_: FrameworkSettings.PileType) -> void:
	remove_card_from_piles(card_)
	maybe_remove_card_from_any_dropzones(card_)
	
	match pile_type_:
		FrameworkSettings.PileType.PLAY:
			play_cards.push_back(card_)
			emit_signal("play_updated")
		FrameworkSettings.PileType.DISCARD:
			discard_cards.push_back(card_)
			emit_signal("discard_updated")
		FrameworkSettings.PileType.HAND:
			hand_cards.push_back(card_)
			card_.switch_side()
			emit_signal("hand_updated")
		FrameworkSettings.PileType.DRAW:
			draw_cards.push_back(card_)
			emit_signal("draw_updated")
			card_.switch_side()
	
	reset_target_positions()
	
func set_card_dropzone(card_: Card, dropzone_: CardDropzone) -> void:
	remove_card_from_piles(card_)
	maybe_remove_card_from_any_dropzones(card_)
	dropzone_.add_card(card_)
	emit_signal("card_added_to_dropzone", dropzone_, card_)
	reset_target_positions()
	
func get_cards_in_pile(pile_type_: FrameworkSettings.PileType) -> Array:
	match pile_type_:
		FrameworkSettings.PileType.PLAY:
			return play_cards.duplicate()
		FrameworkSettings.PileType.DISCARD:
			return discard_cards.duplicate()
		FrameworkSettings.PileType.HAND:
			return hand_cards.duplicate()
		FrameworkSettings.PileType.DRAW:
			return draw_cards.duplicate()
	
	return []
	
func get_card_in_pile_at(pile_type_: FrameworkSettings.PileType, card_index_: int) -> Variant:
	match pile_type_:
		FrameworkSettings.PileType.PLAY:
			if play_cards.size() > card_index_: return play_cards[card_index_]
		FrameworkSettings.PileType.DISCARD:
			if discard_cards.size() > card_index_: return discard_cards[card_index_]
		FrameworkSettings.PileType.HAND:
			if hand_cards.size() > card_index_: return hand_cards[card_index_]
		FrameworkSettings.PileType.DRAW:
			if draw_cards.size() > card_index_: return draw_cards[card_index_]
	
	return null
	
func get_card_pile_size(pile_type_: FrameworkSettings.PileType) -> int:
	match pile_type_:
		FrameworkSettings.PileType.PLAY:
			return play_cards.size()
		FrameworkSettings.PileType.DISCARD:
			return discard_cards.size()
		FrameworkSettings.PileType.HAND:
			return hand_cards.size()
		FrameworkSettings.PileType.DRAW:
			return draw_cards.size()
	
	return 0
#endregion

func remove_card_from_game(card : Card) -> void:
	remove_card_from_piles(card)
	maybe_remove_card_from_any_dropzones(card)
	emit_signal("card_removed_from_game", card)
	card.queue_free()
	reset_target_positions()
	
func is_hand_enabled() -> bool:
	return hand_enabled
	
func remove_card_from_piles(card_: Card) -> void:
	if hand_cards.find(card_) != -1:
		hand_cards.erase(card_)
		emit_signal("hand_updated")
	elif draw_cards.find(card_) != -1:
		draw_cards.erase(card_)
		emit_signal("draw_updated")
	elif play_cards.find(card_) != -1:
		play_cards.erase(card_)
		emit_signal("play_updated")
	elif discard_cards.find(card_) != -1:
		discard_cards.erase(card_)
		emit_signal("discard_updated")
	
func create_card_in_dropzone(card_resource_: CardResource, dropzone_: CardDropzone) -> void:
	var card = create_card(card_resource_)
	card.position = dropzone_.position
	set_card_dropzone(card, dropzone_)
	
func create_card_in_pile(card_resource_: CardResource, pile_type_: FrameworkSettings.PileType) -> Card:
	var card = create_card(card_resource_)
	
	match pile_type_:
		FrameworkSettings.PileType.PLAY:
			card.position = hand_position
		FrameworkSettings.PileType.DISCARD:
			card.position = play_position
		FrameworkSettings.PileType.HAND:
			card.position = discard_position
		FrameworkSettings.PileType.DRAW:
			card.position = draw_position
			#card.rotation_degrees = 270
	
	set_card_pile(card, pile_type_)
	return card
	
func maybe_remove_card_from_any_dropzones(card : Card) -> void:
	var all_dropzones:  = []
	get_dropzones(get_tree().get_root(), "CardDropzone", all_dropzones)
	for dropzone in all_dropzones:
		if dropzone.is_holding(card):
			dropzone.remove_card(card)
			emit_signal("card_removed_from_dropzone", dropzone, card)
	
func get_card_dropzone(card : Card) -> Variant:
	var all_dropzones:  = []
	get_dropzones(get_tree().get_root(), "CardDropzone", all_dropzones)
	for dropzone in all_dropzones:
		if dropzone.is_holding(card):
			return dropzone
	return null
	
func get_dropzones(node: Node, className : String, result : Array) -> void:
	if node is CardDropzone:
		result.push_back(node)
	for child in node.get_children():
		get_dropzones(child, className, result)
	
func load_json_cards_from_path(path : String) -> Array:
	var found = []
	if path:
		var json_as_text = FileAccess.get_file_as_string(path)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			for character in json_as_dict:
				found.push_back(character)
	return found
	
func reset() -> void:
	reset_card_collection()
	
func reset_card_collection() -> void:
	for child in get_children():
		remove_card_from_piles(child)
		maybe_remove_card_from_any_dropzones(child)
		remove_card_from_game(child)
	
	init_core_cards()
	
	set_draw_target_positions(true)
	emit_signal("draw_updated")
	emit_signal("hand_updated")
	emit_signal("play_updated")
	emit_signal("discard_updated")
	
func init_core_cards() -> void:
	for _i in default_core_deck.core_cards.size():
		var core_card_resource = default_core_deck.core_cards[_i]
		var card = create_card_in_pile(core_card_resource, FrameworkSettings.PileType.DRAW)
		var threat_card_resource = default_core_deck.threat_cards[_i]
		card.set_threat_resource(threat_card_resource)
		#var card = create_card(card_resource)
		#draw_cards.push_back(card)
	
	draw_cards.shuffle()
	
func _ready() -> void:
	size = Vector2.ZERO
	spread_curve.add_point(Vector2(0, -1), 0, 0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR)
	spread_curve.add_point(Vector2(1, 1), 0, 0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR)
	reset_card_collection()
	reset_target_positions()
	
#region target positions
func reset_target_positions() -> void:
	set_draw_target_positions()
	set_hand_target_positions()
	set_play_target_positions()
	set_discard_target_positions()
	
func set_draw_target_positions(instantly_move_: bool = false) -> void:
	for _i in draw_cards.size():
		var card = draw_cards[_i]
		card.z_index = 10 + _i
		card.target_position = draw_position + BoardHelper.get_pile_position_shift(self, _i, draw_direction)
		card.set_direction(Vector2.DOWN)
		if instantly_move_:
			card.position = card.target_position
	
func set_hand_target_positions() -> void:
	if hand_position == null: return
	for _i in hand_cards.size():
		var card = hand_cards[_i]
		card.move_to_front()
		var hand_ratio = 0.5
		if hand_cards.size() > 1:
			hand_ratio = float(_i) / float(hand_cards.size() - 1)
		var target_position = hand_position
		var card_spacing = max_hand_spread / (hand_cards.size() + 1)
		target_position.x += (_i + 1) * card_spacing - max_hand_spread / 2.0
		if hand_vertical_curve:
			target_position.y -= hand_vertical_curve.sample(hand_ratio)
		if hand_rotation_curve:
			card.rotation = deg_to_rad(hand_rotation_curve.sample(hand_ratio))
		if hand_face_up:
			card.set_direction(Vector2.UP)
		else:
			card.set_direction(Vector2.DOWN)
		card.target_position = target_position
	while hand_cards.size() > max_hand_size:
		set_card_pile(hand_cards[hand_cards.size() - 1], FrameworkSettings.PileType.DISCARD)
	reset_hand_z_index()
	
func set_discard_target_positions() -> void:
	for _i in discard_cards.size():
		var card = discard_cards[_i]
		if discard_face_up:
			card.set_direction(Vector2.UP)
		else:
			card.set_direction(Vector2.DOWN)
		card.z_index = 10 + _i
		card.rotation = 0
		card.target_position = discard_position + BoardHelper.get_pile_position_shift(self, _i, discard_layout)
	
func set_play_target_positions() -> void:
	for _i in play_cards.size():
		var card = play_cards[_i]
		if play_face_up:
			card.set_direction(Vector2.UP)
		else:
			card.set_direction(Vector2.DOWN)
		card.z_index = 10 + _i
		card.rotation = 0
		card.target_position = play_position + BoardHelper.get_pile_position_shift(self, _i, play_layout)
	
func update_target_position() -> void:
	pass
#endregion
	
# called by Card
func reset_card_z_index() -> void:
	for _i in draw_cards.size():
		var card = draw_cards[_i]
		card.z_index = 10 + _i
	for _i in play_cards.size():
		var card = play_cards[_i]
		card.z_index = 10 + _i
	for _i in discard_cards.size():
		var card = discard_cards[_i]
		card.z_index = 10 + _i
	reset_hand_z_index()
	
func reset_hand_z_index() -> void:
	for _i in hand_cards.size():
		var card = hand_cards[_i]
		card.z_index = 100 + _i
		card.move_to_front()
		if card.mouse_is_hovering:
			card.z_index = 200 + _i
		if card.is_clicked:
			card.z_index = 300 + _i
	
func is_card_in_hand(card) -> bool:
	return hand_cards.filter(func (a): return a == card).size()
	
func is_any_card_clicked() -> bool:
	for card in hand_cards:
		if card.is_clicked:
			return true
	var all_dropzones:  = []
	get_dropzones(get_tree().get_root(), "CardDropzone", all_dropzones)
	for dropzone in all_dropzones:
		for card in dropzone.get_held_cards():
			if card.is_clicked:
				return true
	return false
	
#public function to try and draw a card 
func draw(num_cards: int = 1) -> void:
	for _i in num_cards:
		if hand_cards.size() >= max_hand_size and cant_draw_at_hand_limit:
			continue
		if !draw_cards.is_empty():
			set_card_pile(draw_cards[draw_cards.size() - 1], FrameworkSettings.PileType.HAND)
		elif shuffle_discard_on_empty_draw and discard_cards.size():
			redraw_discard_cards()
			set_card_pile(draw_cards[draw_cards.size() - 1], FrameworkSettings.PileType.HAND)
	
	reset_target_positions()
	
func redraw_discard_cards() -> void:
	var discard_clone = discard_cards.duplicate()
	for card in discard_clone: # you can't remove things from the thing you loop!!
		set_card_pile(card, FrameworkSettings.PileType.DRAW)
	draw_cards.shuffle()
	
func set_topdeck_to_threat_dropzone(dropzone_: ThreatCardDropzone) -> void:
	if draw_cards.is_empty(): 
		redraw_discard_cards()
	var topdeck = draw_cards[draw_cards.size() - 1]
	
	if draw_cards.size():
		topdeck = draw_cards[draw_cards.size() - 1]
	elif shuffle_discard_on_empty_draw and discard_cards.size():
		var discard_clone = discard_cards.duplicate()
		for card in discard_clone: # you can't remove things from the thing you loop!!
			set_card_pile(card, FrameworkSettings.PileType.DRAW)
		draw_cards.shuffle()
		topdeck = draw_cards[draw_cards.size() - 1]
	
	dropzone_.add_card(topdeck)
	remove_card_from_piles(topdeck)
	maybe_remove_card_from_any_dropzones(topdeck)
	reset_target_positions()
	
func hand_is_at_max_capacity() -> bool:
	return hand_cards.size() >= max_hand_size
	
func sort_hand(sort_func) -> void:
	hand_cards.sort_custom(sort_func)
	reset_target_positions()
	
func create_card(card_core_resource_: CardResource) -> Card:
	var card = card_scene.instantiate()
	card.frontface_texture = "res://entities/card/images/card_empty.png"
	card.backface_texture = "res://entities/card/images/card_back.png"
	card.return_speed = card_return_speed
	card.hover_distance = card_hover_distance
	card.drag_when_clicked = drag_when_clicked
	
	card.core_resource = card_core_resource_
	#card.resource = ResourceLoader.load(json_data.resource_script_path).new()
	#for key in json_data.keys() -> void:
		#if key != "texture_path" and key != "backface_texture_path" and key != "resource_script_path":
			#card.card_data[key] = json_data[key]
	card.connect("card_hovered", func(a) -> void: emit_signal("card_hovered", a))
	card.connect("card_unhovered", func(a) -> void: emit_signal("card_unhovered", a))
	card.connect("card_clicked", func(a) -> void: emit_signal("card_clicked", a))
	card.connect("card_dropped", func(a) -> void: emit_signal("card_dropped", a))
	card.board = bank.board
	add_child(card)
	return card
	
#func _get_card_data_by_name(name_ : String) -> void:
	#for json_data in card_database:
		#if json_data.name == name_:
			#return json_data
	#return null
