class_name EnemyCardDropzone
extends CardDropzone


@export var hp := 30

@onready var label = $Label


func _ready():
	label.text = "%s" % hp
	
#func card_dropped(card_ : Card):
	#if card_pile:
		#get_parent().mana -= card_.resource.cost
		##hp -= card.card_data.power
		#label.text = "%s" % hp
		#card_pile.set_card_pile(card_, FrameworkSettings.PileType.PLAY)
		#apply_default_effects(card_)
	#
#func can_drop_card(card_ : Card):
	#return get_parent().mana >= card_.resource.cost
	##return card.card_data.type == "Attack" and get_parent().mana >= card.resource.cost
	#
#func apply_default_effects(card_ : Card) -> void:
	#for effect_resource in card_.resource.default_effects:
		#bank.apply_effect(effect_resource)
