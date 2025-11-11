@tool
class_name ShellCard 
extends Card


#region var
# these are custom variables they will be set with data from *collection.json
#@export var value : int
#@export var type : String
#@export var cost : int
@export var description : String

#region core var
@onready var core_name: Label = %CoreName
@onready var core_type: Label = %CoreType
@onready var cost_token: Token = %CostToken
@onready var faction_token: Token = %FactionToken
@onready var level_token: Token = %LevelToken
#endregion

#region threat var
@onready var threat_name: Label = %ThreatName
@onready var threat_type: Label = %ThreatType
@onready var threat_planet: Label = %ThreatPlanet
@onready var threat_keyword: Label = %ThreatKeyword
@onready var threat_danger_token: Token = %ThreatDangerToken
@onready var threat_offensive_token: Token = %ThreatOffensiveToken
@onready var threat_defensive_token: Token = %ThreatDefensiveToken
@onready var threat_aftermath_token: Token = %ThreatAftermathToken
@onready var threat_damage_token: Token = %ThreatDamageToken
@onready var threat_health_token: Token = %ThreatHealthToken
#endregion

@onready var sked = %Sked

var state: FrameworkSettings.SideState = FrameworkSettings.SideState.FRIENDLY:
	set(value_):
		state = value_
		#size = Vector2()
		#
		#match state:
			#FrameworkSettings.SideState.FRIENDLY:
				#pass
			#FrameworkSettings.SideState.HOSTILE:
				#pass
#endregion


func _ready():
	super()
	#card_data.connect("card_data_updated", _update_display)
	core_resource.connect("is_updated", _update_display)
	
	#await get_tree().create_timer(0.1)
	sked.init_operations()
	_update_display()
	
func _update_display():
	update_core()
	
	
	#cost_label.text = "%s" % card_data.cost
	#name_label.text = "%s" % card_data.name
	#type_label.text = "%s" % card_data.type
	#if card_data.type == "Attack":
		#power_label.text = "%s" % card_data.power
		##texture_rect_2.modulate = Color.WHITE
	#elif card_data.type == "Block":
		#power_label.text = "%s" % card_data.block_amount
		##texture_rect_2.modulate = Color.AQUA
	#else:
		#power_label.visible = false
	
func update_core():
	core_name.text = core_resource.name.capitalize()
	core_type.text = FrameworkSettings.card_to_string[core_resource.type].capitalize()
	cost_token.value_int = int(core_resource.cost)
	faction_token.faction = core_resource.faction#.capitalize()
	level_token.value_int = core_resource.level
	
func update_threat():
	threat_name.text = threat_resource.name.capitalize()
	threat_type.text = FrameworkSettings.threat_to_string[threat_resource.type].capitalize()
	threat_planet.text = FrameworkSettings.planet_to_string[threat_resource.planet].capitalize()
	
	threat_keyword.visible = threat_resource.keyword != null
	if threat_resource.keyword != null:
		threat_keyword.text = BoardHelper.get_str_keyword(threat_resource.keyword)
	
	threat_danger_token.visible = threat_resource.danger != FrameworkSettings.DangerType.DEFAULT
	if threat_resource.danger != null:
		threat_danger_token.value_not_int = threat_resource.danger
	
	threat_offensive_token.visible = threat_resource.offensive != null
	if threat_resource.offensive != null:
		threat_offensive_token.value_int = threat_resource.offensive.value_int
	
	threat_defensive_token.visible = threat_resource.defensive != null
	if threat_resource.defensive != null:
		threat_defensive_token.value_int = threat_resource.defensive.value_int
	
	threat_aftermath_token.visible = threat_resource.aftermath != null
	if threat_resource.aftermath != null:
		threat_aftermath_token.type = FrameworkSettings.effect_to_token[threat_resource.aftermath.type]
		threat_aftermath_token.value_int = threat_resource.aftermath.value_int
	
	threat_damage_token.value_int = threat_resource.damage_int
	update_threat_health_token()
	
func update_threat_health_token() -> void:
	threat_health_token.value_int = threat_resource.health_int - threat_resource.wound_int
	
func switch_side() -> void:
	
	match state:
		FrameworkSettings.SideState.HOSTILE:
			state = FrameworkSettings.SideState.FRIENDLY
			frontface.show()
			backface.hide()
		FrameworkSettings.SideState.FRIENDLY:
			state = FrameworkSettings.SideState.HOSTILE
			frontface.hide()
			backface.show()
	
	#%ThreatContainer.size = Vector2(300, 210)
	#%CoreContainer.size = Vector2(210, 300)
	backface.size = Vector2(300, 210)
	frontface.size = Vector2(210, 300)
	
	match state:
		FrameworkSettings.SideState.FRIENDLY:
			size = frontface.size
		FrameworkSettings.SideState.HOSTILE:
			size = backface.size
	
func set_threat_resource(threat_resource_: CardThreatResource) -> void:
	threat_resource = threat_resource_
	threat_resource.connect("is_updated", _update_display)
	update_threat()
	pass
