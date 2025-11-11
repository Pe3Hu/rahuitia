class_name CardThreatResource
extends CardResource


@export var planet: FrameworkSettings.PlanetType = FrameworkSettings.PlanetType.DEFAULT
@export var type: FrameworkSettings.ThreatType
@export var offensive: EffectResource
@export var defensive: EffectResource
@export var danger: FrameworkSettings.DangerType = FrameworkSettings.DangerType.DEFAULT
@export var keyword: KeywordResource
@export var aftermath: EffectResource


var wound_int: int = 0:
	set(value_):
		wound_int = value_
		#update_death()
var health_int: int = 0
var damage_int: int = 0


func preparation() -> void:
	update_health()
	update_damage()
	pass


func update_health() -> void:
	health_int = 0
	
	if defensive != null:
		health_int += defensive.value_int
	
	if offensive != null:
		health_int += offensive.value_int
	
	if danger == FrameworkSettings.DangerType.ARMOR:
		health_int += FrameworkSettings.DANGER_MARKER
	
func update_damage() -> void:
	damage_int = 0
	
	if offensive != null:
		damage_int += offensive.value_int
	
	if danger == FrameworkSettings.DangerType.DAMAGE:
		damage_int += FrameworkSettings.DANGER_MARKER
	
func reset() -> void:
	wound_int = 0
	update_health()
	update_damage()
	
#func update_death() -> void:
	#if wound_int < health_int: return
	#apply_death()
	#
#func apply_death() -> void:
	#print("death")
