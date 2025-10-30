class_name OperationResource
extends Resource


var condition: ConditionResource
var effects: Array[EffectResource]


func _init(condition_: ConditionResource, effects_: Array[EffectResource]) -> void:
	condition = condition_
	effects.append_array(effects_)
