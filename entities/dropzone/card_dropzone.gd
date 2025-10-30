class_name CardDropzone 
extends Control


@export var card_pile : CardPile
@export var stack_display_gap := 8
@export var max_stack_display := 6
@export var card_face_up := true
@export var can_drag_top_card := true
@export var held_card_direction := true
@export var layout : CardPile.PilesCardLayouts = CardPile.PilesCardLayouts.up

var _held_cards := []


func card_dropped(card_: Card):
	if card_pile:
		card_pile.set_card_dropzone(card_, self)
	
func can_drop_card(_card: Card):
	return visible
	
func get_top_card():
	if _held_cards.size() > 0:
		return _held_cards[_held_cards.size() - 1]
	return null
	
func get_card_at(index):
	if _held_cards.size() > index:
		return _held_cards[index]
	return null
	
func get_total_held_cards():
	return _held_cards.size()
	
func is_holding(card_):
	return _held_cards.find(card_) != -1
	
func get_held_cards():
	return _held_cards.duplicate() # duplicate to allow the user to mess with the array without messing with this one!!!
	
func add_card(card_):
	_held_cards.push_back(card_)
	#_update_target_positions()
	
func remove_card(card_):
	_held_cards = _held_cards.filter(func(c): return c != card_)
	#_update_target_positions()
	
func _update_target_positions():
	for i in _held_cards.size():
		var card = _held_cards[i]
		var target_pos = position
		if layout == CardPile.PilesCardLayouts.up:
			if i <= max_stack_display:
				target_pos.y -= i * stack_display_gap
			else:
				target_pos.y -= stack_display_gap * max_stack_display
		elif layout == CardPile.PilesCardLayouts.down:
			if i <= max_stack_display:
				target_pos.y += i * stack_display_gap
			else:
				target_pos.y += stack_display_gap * max_stack_display
		elif layout == CardPile.PilesCardLayouts.right:
			if i <= max_stack_display:
				target_pos.x += i * stack_display_gap
			else:
				target_pos.x += stack_display_gap * max_stack_display
		elif layout == CardPile.PilesCardLayouts.left:
			if i <= max_stack_display:
				target_pos.x -= i * stack_display_gap
			else:
				target_pos.x -= stack_display_gap * max_stack_display
		if card_face_up:
			card.set_direction(Vector2.UP)
		else:
			card.set_direction(Vector2.DOWN)
		if card.is_clicked:
			card.z_index = 3000 + i 
		else:
			card.z_index = i
		card.move_to_front() # must also do this to account for INVISIBLE INTERACTION ORDER
		card.target_position = target_pos
	
func _process(_delta):
	_update_target_positions()
