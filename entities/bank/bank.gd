class_name Bank
extends PanelContainer


#region vars
@export var token_scene: PackedScene

const core_types = ["action", "credit", "health", "armor"]

@export var board: Board

@onready var action_token: Token = %ActionToken
@onready var credit_token: Token = %CreditToken
@onready var armor_token: Token = %ArmorToken
@onready var health_token: Token = %HealthToken
@onready var damage_tokens: HBoxContainer = %DamageTokens

var selected_damage_token: Token
#endregion


func apply_effect(effect_resource_: EffectResource) -> void:
	match effect_resource_.type:
		FrameworkSettings.EffectType.DAMAGE:
			add_damage_token(effect_resource_)
		FrameworkSettings.EffectType.CREDIT:
			credit_token.value_int += effect_resource_.value_int
		FrameworkSettings.EffectType.ACTION:
			action_token.value_int += effect_resource_.value_int
		FrameworkSettings.EffectType.HEAL:
			health_token.value_int += effect_resource_.value_int
		FrameworkSettings.EffectType.ARMOR:
			armor_token.value_int += effect_resource_.value_int
	
func add_damage_token(effect_resource_: EffectResource) -> void:
	var token = token_scene.instantiate()
	token.type = effect_resource_.type
	token.value_int = effect_resource_.value_int
	token.bank = self
	damage_tokens.add_child(token)
	
func end_of_turn() -> void:
	reset_tokens()
	
func reset_tokens() -> void:
	action_token.value_int = FrameworkSettings.TURN_ACTION
	armor_token.value_int = 0
	reset_damage_tokens()
	
func reset_damage_tokens() -> void:
	while damage_tokens.get_child_count() > 0:
		var token = damage_tokens.get_child(0)
		damage_tokens.remove_child(token)
		token.queue_free()
	
func remove_selected_damage_token() -> void:
	damage_tokens.remove_child(selected_damage_token)
	selected_damage_token.queue_free()
	selected_damage_token = null
	board.targeting_line.visible = false

func can_drop_card(card_ : Card):
	return action_token.value_int >= card_.core_resource.cost
	
func card_dropped(card_ : Card):
	action_token.value_int -= card_.core_resource.cost
	board.card_pile.set_card_pile(card_, FrameworkSettings.PileType.PLAY)
	apply_default_effects(card_)
	
func apply_default_effects(card_ : Card) -> void:
	for effect_resource in card_.core_resource.default_effects:
		apply_effect(effect_resource)
