@tool
class_name SimpleCardPile 
extends EditorPlugin


func _enter_tree():
	add_custom_type("CardPile", "Control", preload("card_pile.gd"), preload("card_icon.png"))
	add_custom_type("Card", "Control", preload("res://entities/card/card.gd"), preload("card_icon.png"))
	add_custom_type("CardDropzone", "Control", preload("res://entities/pile/dropzone/card_dropzone.gd"), preload("card_icon.png"))
	add_custom_type("CardPileDebugger", "RichTextLabel", preload("card_pile_debugger.gd"), preload("card_icon.png"))
	
func _exit_tree():
	remove_custom_type("CardPile")
	remove_custom_type("Card")
	remove_custom_type("CardDropzone")
	remove_custom_type("CardPileDebugger")
