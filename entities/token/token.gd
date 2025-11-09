class_name Token
extends TextureRect


#region signal
#signal token_hovered
#signal token_unhovered
signal token_clicked
signal token_dropped
#endregion

@export var bank: Bank

@export var core: FrameworkSettings.CoreType = FrameworkSettings.CoreType.DEFAULT:
	set(value_):
		core = value_
		#FrameworkSettings.cor
		if core != FrameworkSettings.CoreType.DEFAULT:
			texture = load("res://entities/token/images/core/{path}.png".format({"path": FrameworkSettings.core_to_string[core]}))
@export var faction: FrameworkSettings.FactionType = FrameworkSettings.FactionType.DEFAULT:
	set(value_):
		faction = value_
		visible = faction != FrameworkSettings.FactionType.DEFAULT
		if faction != FrameworkSettings.FactionType.DEFAULT:
			texture = load("res://entities/token/images/faction/{path}.png".format({"path": FrameworkSettings.faction_to_string[faction]}))
@export var value_int: int = -1:
	set(value_):
		value_int = value_
		%ValueLabel.visible = value_int != -1
		%ValueLabel.text = str(value_)
@export var condition: FrameworkSettings.ConditionType = FrameworkSettings.ConditionType.DEFAULT:
	set(value_):
		condition = value_
		%ConditionLabel.visible = condition != FrameworkSettings.ConditionType.DEFAULT
		#%ConditionLabel.text = FrameworkSettings

var is_selected: bool = false


func _ready():
	connect("token_clicked", func():
		bank.board.targeting_line.set_point_position(0, global_position - bank.board.position + size * 0.5)
		bank.board.targeting_line.visible = true
	)
	connect("token_dropped", func():
		bank.board.targeting_line.visible = false
	)
	
func _on_gui_input(event_: InputEvent):
	if event_ is InputEventMouseButton and event_.button_index == MOUSE_BUTTON_LEFT:
		if event_.pressed:
			switch_is_selected()
	
func switch_is_selected() -> void:
	if bank == null: return
	is_selected = !is_selected
	
	if is_selected:
		bank.board.custom_cursor.current_state = FrameworkSettings.CursorState.HOLD
		bank.selected_damage_token = self
		emit_signal("token_clicked")
		z_index = 40
	else:
		bank.board.custom_cursor.current_state = FrameworkSettings.CursorState.IDLE
		bank.selected_damage_token = null
		emit_signal("token_dropped")
		z_index = 0
	
func _process(_delta):
	if is_selected:
		#var target_position = position
		#target_position.y += 80
		#target_position.x += 180
		#panel_container.position = target_position
		bank.board.targeting_line.set_point_position(1, get_global_mouse_position() - bank.board.position)


func _on_mouse_entered() -> void:
	if bank == null: return
	bank.board.custom_cursor.current_state = FrameworkSettings.CursorState.SELECT
	
func _on_mouse_exited() -> void:
	if bank == null: return
	if is_selected: return
	bank.board.custom_cursor.current_state = FrameworkSettings.CursorState.IDLE
