extends CardDropzone


func card_dropped(card : Card):
	if card_pile:
		#get_parent().mana -= card.card_data.cost
		#if card.card_data.type == "Block":
			#get_parent().block += card.card_data.block_amount
		#if card.card_data.type == "Power":
			#card.card_data.handle_power_type(card_pile, card)
		card_pile.set_card_pile(card, CardPile.Piles.play_pile)
	
func can_drop_card(_card : Card):
	return true
	#var type_matches = card.card_data.type == "Block" or card.card_data.type == "Power"
	#return type_matches and get_parent().mana >= card.card_data.cost
