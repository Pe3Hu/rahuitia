class_name CardCoreResource
extends CardResource


@export var level: int = 0
@export_enum("tactic", "ally") var type: String = "tactic"
@export_enum("council", "viren", "silver", "junker") var faction: String
@export var cost: int = 0

@export var default_effects: Array[EffectResource]
