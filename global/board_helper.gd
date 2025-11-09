extends Node



func get_cardzone_position_shift(card_dropzone_: CardDropzone, index_: int) -> Vector2:
	var position_shift = Vector2()
	
	match card_dropzone_.layout:
		FrameworkSettings.PileDirection.UP:
			if index_ <= card_dropzone_.max_stack_display:
				position_shift.y -= index_ * card_dropzone_.stack_display_gap
			else:
				position_shift.y -= card_dropzone_.stack_display_gap * card_dropzone_.max_stack_display
		FrameworkSettings.PileDirection.DOWN:
			if index_ <= card_dropzone_.max_stack_display:
				position_shift.y += index_ * card_dropzone_.stack_display_gap
			else:
				position_shift.y += card_dropzone_.stack_display_gap * card_dropzone_.max_stack_display
		FrameworkSettings.PileDirection.RIGHT:
			if index_ <= card_dropzone_.max_stack_display:
				position_shift.x += index_ * card_dropzone_.stack_display_gap
			else:
				position_shift.x += card_dropzone_.stack_display_gap * card_dropzone_.max_stack_display
		FrameworkSettings.PileDirection.LEFT:
			if index_ <= card_dropzone_.max_stack_display:
				position_shift.x -= index_ * card_dropzone_.stack_display_gap
			else:
				position_shift.x -= card_dropzone_.stack_display_gap * card_dropzone_.max_stack_display
	
	return position_shift
	
func get_pile_position_shift(pile_: CardPile, index_: int, direction_: FrameworkSettings.PileDirection) -> Vector2:
	var position_shift = Vector2()
	
	match direction_:
		FrameworkSettings.PileDirection.UP:
			if index_ <= pile_.max_stack_display:
				position_shift.y -= index_ * pile_.stack_display_gap
			else:
				position_shift.y -= pile_.stack_display_gap * pile_.max_stack_display
		FrameworkSettings.PileDirection.DOWN:
			if index_ <= pile_.max_stack_display:
				position_shift.y += index_ * pile_.stack_display_gap
			else:
				position_shift.y += pile_.stack_display_gap * pile_.max_stack_display
		FrameworkSettings.PileDirection.RIGHT:
			if index_ <= pile_.max_stack_display:
				position_shift.x += index_ * pile_.stack_display_gap
			else:
				position_shift.x += pile_.stack_display_gap * pile_.max_stack_display
		FrameworkSettings.PileDirection.LEFT:
			if index_ <= pile_.max_stack_display:
				position_shift.x -= index_ * pile_.stack_display_gap
			else:
				position_shift.x -= pile_.stack_display_gap * pile_.max_stack_display
	
	return position_shift
