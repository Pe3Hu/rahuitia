class_name CardDropzone 
extends Control


#region vars
@export var bank: Bank
@export var card_pile: CardPile

@export var stack_display_gap: int = 8
@export var max_stack_display: int = 6
@export var card_face_up: bool = true
@export var can_drag_top_card: bool = true
@export var held_card_direction: bool = true
@export var layout: FrameworkSettings.PileDirection = FrameworkSettings.PileDirection.UP

var held_cards: Array[Card]
#endregion


#region card get
func get_top_card() -> Card:
	if held_cards.size() > 0:
		return held_cards[held_cards.size() - 1]
	return null
	
func get_card_at(index_: int) -> Card:
	if held_cards.size() > index_:
		return held_cards[index_]
	return null
	
func get_total_held_cards() -> int:
	return held_cards.size()
	
func get_held_cards() -> Array[Card]:
	return held_cards.duplicate() # duplicate to allow the user to mess with the array without messing with this one!!!
#endregion

#region card chek
func is_holding(card_) -> bool:
	return held_cards.find(card_) != -1
	
func can_drop_card(_card: Card) -> bool:
	return visible
#endregion

#region card position
func card_dropped(card_: Card) -> void:
	if card_pile:
		card_pile.set_card_dropzone(card_, self)
	
func add_card(card_: Card) -> void:
	held_cards.push_back(card_)
	#update_target_positions()
	
func remove_card(card_: Card) -> void:
	held_cards = held_cards.filter(func (a): return a != card_)
	#update_target_positions()
	
func update_target_positions() -> void:
	for _i in held_cards.size():
		var card = held_cards[_i]
		var target_position = position
		target_position += BoardHelper.get_position_shift(self, _i)
		
		if card_face_up:
			card.set_direction(Vector2.UP)
		else:
			card.set_direction(Vector2.DOWN)
		if card.is_clicked:
			card.z_index = 3000 + _i 
		else:
			card.z_index = _i
		card.move_to_front() # must also do this to account for INVISIBLE INTERACTION ORDER
		card.target_position = target_position
#endregion

func _process(_delta) -> void:
	update_target_positions()
