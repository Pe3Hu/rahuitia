class_name Board
extends Node2D


const enemy_limit: int = 3

@onready var mana_label = $ManaLabel
@onready var card_pile = $CardPile
@onready var block_card_dropzone = $BlockCardDropzone
@onready var block_label = $BlockLabel
@onready var panel_container = $PanelContainer
@onready var rich_text_label = $PanelContainer/RichTextLabel
@onready var targeting_line_2d = $TargetingLine2D


# seems like these 3 properties would make more sense in as a singleton in a real game?
var starting_mana := 4
var current_hovered_card : Card

var block := 0 :
	set(val):
		block = val
		_update_display()
	
var mana := 4 :
	set(val):
		mana = val
		_update_display()


func _ready():
	card_pile.draw(enemy_limit)
	card_pile.connect("card_hovered", func(card):
		#rich_text_label.text = card.card_data.format_description()
		#panel_container.visible = true
		current_hovered_card = card
	)
	card_pile.connect("card_unhovered", func(_card):
		panel_container.visible = false
		current_hovered_card = null
	)
	card_pile.connect("card_clicked", func(card):
		targeting_line_2d.set_point_position(0, card.position + card.size * 0.5)
		targeting_line_2d.visible = true
	)
	card_pile.connect("card_dropped", func(_card):
		targeting_line_2d.visible = false
	)
	
func _on_end_turn_button_pressed():
	mana = starting_mana
	block = 0
	for card in card_pile.get_cards_in_pile(CardPile.Piles.play_pile):
		card_pile.set_card_pile(card, CardPile.Piles.discard_pile)
	for card in card_pile.get_cards_in_pile(CardPile.Piles.hand_pile):
		card_pile.set_card_pile(card, CardPile.Piles.discard_pile)
	card_pile.draw(enemy_limit)
	
func _update_display():
	mana_label.text = "%s" % [ mana ]
	block_label.text = "%s" % [ block ]
	
func _process(_delta):
	if current_hovered_card:
		var target_pos = current_hovered_card.position
		target_pos.y += 80
		target_pos.x += 180
		panel_container.position = target_pos
		targeting_line_2d.set_point_position(1, get_global_mouse_position())
	
func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
