class_name Pedestal
extends PanelContainer


@export var library: Library

@onready var scroll_dropzones: = [
	%ScrollDropzone1,
	%ScrollDropzone2,
	%ScrollDropzone3
]

var is_mouse_inside: bool = false



func refill_scroll_dropzones() -> void:
	var library_scroll = library.get_scroll_on_pedestal()
	for scroll_dropzone in scroll_dropzones:
		if scroll_dropzone.library == null:
			scroll_dropzone.library = library
		
		var card = library_scroll.draw_topdeck()
		scroll_dropzone.add_card(card)
	
	switch()
	
func discard_cards() -> void:
	switch()
	var library_scroll = library.get_scroll_on_pedestal()
	for scroll_dropzone in scroll_dropzones:
		var card = scroll_dropzone.draw_topdeck()
		library_scroll.place_card_on_bottom(card)
	
func _on_mouse_entered() -> void:
	is_mouse_inside = true
	
func _on_mouse_exited() -> void:
	is_mouse_inside = false
	
func switch() -> void:
	visible = !visible
	library.visible = visible
	library.board.card_pile.visible = !visible
