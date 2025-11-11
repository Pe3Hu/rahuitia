class_name CardCoreResource
extends CardResource


@export var level: int = 0
@export var type: FrameworkSettings.CoreType = FrameworkSettings.CoreType.TACTIC
@export var faction: FrameworkSettings.FactionType = FrameworkSettings.FactionType.DEFAULT
@export var cost: int = 0

@export var default_effects: Array[EffectResource]
