class_name ScrollCardDropzone
extends CardDropzone


@export var library: Library
@export var level_int: int = 1


func init_scroll_cards() -> void:
	#var b = library.board
	#var a = library.board.card_pile
	if library.board.card_pile == null: return
	if level_int > 1: return
	var deck = load("res://entities/deck/scroll_{level}_deck.tres".format({"level": level_int}))
	var core_card_resources = deck.core_cards.duplicate()
	#core_card_resources.shuffle()
	
	for core_card_resource in core_card_resources:
		var card = library.board.card_pile.create_card(core_card_resource)
		add_card(card)
	
func add_card(card_: Card) -> void:
	super(card_)
	
	if library.board.card_pile.get_children().has(card_):
		library.board.card_pile.remove_child(card_)
	
	add_child(card_)
	
func draw_topdeck() -> Card:
	var index = get_child_count() - 1
	if index == -1: return null
	var card = get_child(index)
	remove_child(card)
	return card
	
func place_card_on_bottom(card_: Card) -> void:
	if card_ == null: return
	#var previous_cards = []
	#while get_child_count() > 0:
	#	var card = get_child(0)
	#var a = card_.get_parent()
	add_child(card_)
	move_child(card_, 0)
	
func _on_gui_input(event_: InputEvent) -> void:
	if event_ is InputEventMouseButton and event_.button_index == MOUSE_BUTTON_LEFT:
		if event_.pressed:
			if library.pedestal.is_mouse_inside:
				receive_core_card()
	
func receive_core_card() -> void:
	var card = draw_topdeck()
	library.board.card_pile.set_card_pile(card, FrameworkSettings.PileType.HAND)
	#card.board = library.board
	card.board.card_pile.add_child(card)
	card.switch_side()
	library.pedestal.discard_cards()
