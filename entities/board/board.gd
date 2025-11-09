class_name Board
extends MarginContainer



#region vars
@onready var cursor: CustomCursor = %CustomCursor

@onready var card_pile: CardPile = %CardPile
@onready var block_card_dropzone = %BlockCardDropzone
#@onready var panel_container = $PanelContainer
#@onready var rich_text_label = %RichTextLabel
@onready var targeting_line = %TargetingLine2D

@onready var bank: Bank = %Bank
@onready var custom_cursor: CustomCursor = %CustomCursor

var current_hovered_card : Card

var block := 0 :
	set(val):
		block = val
		_update_display()
var mana := 4 :
	set(val):
		mana = val
		_update_display()
#endregion



func _ready():
	#await get_tree().create_timer(4.1)
	card_pile.draw(FrameworkSettings.ENEMY_LIMIT)
	card_pile.connect("card_hovered", func(card):
		#rich_text_label.text = card.card_data.format_description()
		#panel_container.visible = true
		current_hovered_card = card
	)
	card_pile.connect("card_unhovered", func(_card):
		#panel_container.visible = false
		current_hovered_card = null
	)
	card_pile.connect("card_clicked", func(card):
		targeting_line.set_point_position(0, card.global_position - position + card.size * 0.5)
		targeting_line.visible = true
	)
	card_pile.connect("card_dropped", func(_card):
		targeting_line.visible = false
	)
	
func _on_end_turn_button_pressed():
	#mana = starting_mana
	block = 0
	for card in card_pile.get_cards_in_pile(FrameworkSettings.PileType.PLAY):
		card_pile.set_card_pile(card, FrameworkSettings.PileType.DISCARD)
	for card in card_pile.get_cards_in_pile(FrameworkSettings.PileType.HAND):
		card_pile.set_card_pile(card, FrameworkSettings.PileType.DISCARD)
	card_pile.draw(FrameworkSettings.ENEMY_LIMIT)
	bank.end_of_turn()
	
func _update_display():
	#mana_label.text = "%s" % [ mana ]
	#block_label.text = "%s" % [ block ]
	pass
	
func _process(_delta):
	if current_hovered_card:
		var target_pos = current_hovered_card.position
		target_pos.y += 80
		target_pos.x += 180
		#panel_container.position = target_pos
		targeting_line.set_point_position(1, get_global_mouse_position() - position)
	
func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
	
func _on_gui_input(event_: InputEvent):
	if event_ is InputEventMouseButton and event_.button_index == MOUSE_BUTTON_LEFT:
		if event_.pressed:
			if bank.selected_damage_token != null:
				bank.selected_damage_token.switch_is_selected()
