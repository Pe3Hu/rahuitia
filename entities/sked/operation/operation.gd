class_name Operation
extends PanelContainer


@onready var condition_box = %ConditionBox
@onready var condition_token = %ConditionToken
@onready var result_tokens = %ResultTokens


var resource: OperationResource:
	set(value_):
		resource = value_
		init_tokens()


func init_tokens() -> void:
	if resource.condition.type == FrameworkSettings.ConditionType.DEFAULT:
		condition_box.visible = false
	else:
		condition_token.condition = resource.condition.type
	
	for effect_resource in resource.effects:
		add_token(effect_resource)
	
func add_token(effect_resource_: EffectResource) -> void:
	var token = preload("res://entities/token/token.tscn").instantiate()
	token.type = effect_resource_.type
	token.value_int = effect_resource_.value_int
	result_tokens.add_child(token)
