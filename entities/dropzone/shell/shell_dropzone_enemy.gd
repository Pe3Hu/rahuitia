extends CardDropzone


@export var hp := 30

@onready var label = $Label


func _ready():
	label.text = "%s" % hp
	
func card_dropped(card : Card):
	if card_pile:
		get_parent().mana -= card.resource.cost
		#hp -= card.card_data.power
		label.text = "%s" % hp
		card_pile.set_card_pile(card, CardPile.Piles.play_pile)
	
func can_drop_card(card : Card):
	return get_parent().mana >= card.resource.cost
	#return card.card_data.type == "Attack" and get_parent().mana >= card.resource.cost
