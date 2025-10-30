extends CardDropzone


func card_dropped(card : Card):
	if card_pile:
		get_parent().mana -= 1
		card.card_data.upgrade()
		card_pile.set_card_pile(card, CardPile.Piles.discard_pile)
	
func can_drop_card(_card : Card):
	return get_parent().mana >= 1
