class_name CardPileDebugger 
extends RichTextLabel

@export var card_pile : CardPile


func _ready():
	text += "Signal Debugger:\n"
	card_pile.connect("draw_pile_updated", func(): text += "Draw Pile Updated\n")
	card_pile.connect("hand_pile_updated", func(): text += "Hand Pile Updated\n")
	card_pile.connect("discard_pile_updated", func(): text += "Discard Pile Updated\n")
	card_pile.connect("card_removed_from_dropzone", func(_dropzone, _card): text += "Card Removed From Dropzone\n")
	card_pile.connect("card_added_to_dropzone", func(_dropzone, _card): text += "Card Added To Dropzone\n")
	card_pile.connect("card_hovered", func(card): text += "%s hovered\n" % card.card_data.nice_name)
	card_pile.connect("card_unhovered", func(card): text += "%s unhovered\n" % card.card_data.nice_name)
	card_pile.connect("card_clicked", func(card): text += "%s clicked\n" % card.card_data.nice_name)
	card_pile.connect("card_dropped", func(card): text += "%s dropped\n" % card.card_data.nice_name)
	card_pile.connect("card_removed_from_game", func(card): text += "%s removed from game\n" % card.card_data.nice_name)
