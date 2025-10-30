class_name Sked
extends PanelContainer


@export var operation_scene : PackedScene

@export var card: Card
@export var default_condition: ConditionResource

@onready var operations = %Operations


func init_operations() -> void:
	init_default_operation()
	
func init_default_operation() -> void:
	var operation = preload("res://entities/sked/operation/operation.tscn").instantiate()
	operations.add_child(operation)
	operation.resource = OperationResource.new(default_condition, card.resource.default_effects)
	
	#for effects in card.resource.default_effects:
		#add_operation(effects)
	#
#func add_operation(effects_: EffectResource, condition_: ConditionResource = default_condition) -> void:
	#var operation = operation_scene.instantiate()
	#operation.condition = condition_
	#operation.effects = effects_
	#
	#if default_condition == condition_:
		#%DefaultOperations.add_child(operation)
