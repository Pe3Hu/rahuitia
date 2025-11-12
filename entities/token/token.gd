class_name Token
extends TextureRect


#region signal
#signal token_hovered
#signal token_unhovered
signal token_clicked
signal token_dropped
#endregion

#region var
@export var bank: Bank

@export var type: FrameworkSettings.TokenType = FrameworkSettings.TokenType.DEFAULT:
	set(value_):
		type = value_
		if type != FrameworkSettings.TokenType.DEFAULT:
			update_colors()
			texture = load("res://entities/token/images/type/{path}.png".format({"path": FrameworkSettings.token_to_string[type]}))
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
@export var value_not_int: int = 0:
	set(value_):
		value_not_int = value_
		%ValueLabel.visible = false#value_not_int == -1
		update_colors()
		#match type:
			#FrameworkSettings.TokenType.DANGER:
				#match value_not_int:
					#FrameworkSettings.TokenType.DAMAGE:
						#modulate = Color.DARK_RED
					#FrameworkSettings.TokenType.ARMOR:
						#modulate = Color.ROYAL_BLUE
@export var condition: FrameworkSettings.ConditionType = FrameworkSettings.ConditionType.DEFAULT:
	set(value_):
		condition = value_
		%ConditionLabel.visible = condition != FrameworkSettings.ConditionType.DEFAULT
		#%ConditionLabel.text = FrameworkSettings

var is_selected: bool = false
#endregion

#region color
var angle: float = 90
var shader_color_start: Color
var shader_color_end: Color
#endregion


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
		z_index = 101
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
	
func update_colors() -> void:
	var max_h = 360.0
	var h_start = 0.0
	var h_end = 0.0
	var s_start = 1.0
	var s_end = 0.6
	var v_start = 0.6
	var v_end = 1.0
	
	match type:
		FrameworkSettings.TokenType.ACTION:
			h_start = 100.0
			h_end = 120.0
			angle = -60.0
		FrameworkSettings.TokenType.ARMOR:
			h_start = 200.0
			h_end = 220.0
			angle = 0.0
			#h_start = 200.0
			#h_end = 220.0
			#s_start = 0.4
			#s_end = 0.5
			#v_start = 0.4
			#v_end = 0.5
			#angle = 0.0
		FrameworkSettings.TokenType.DEFENSIVE:
			h_start = 200.0
			h_end = 220.0
			angle = 0.0
		FrameworkSettings.TokenType.LEVEL:
			h_start = 200.0
			h_end = 220.0
			s_start = 0.4
			s_end = 0.5
			v_start = 0.4
			v_end = 0.5
			angle = 0.0
		FrameworkSettings.TokenType.CREDIT:
			h_start = 50.0
			h_end = 70.0
			angle = -100.0
		FrameworkSettings.TokenType.DAMAGE:
			h_start = 40.0
			h_end = 20.0
			v_start = 0.9
			angle = -30.0
		FrameworkSettings.TokenType.OFFENSIVE:
			h_start = 40.0
			h_end = 20.0
			angle = -30.0
		FrameworkSettings.TokenType.HEALTH:
			h_start = 340.0
			h_end = 360.0
			v_start = 0.9
			angle = -30.0
		FrameworkSettings.TokenType.DANGER:
			match value_not_int:
				FrameworkSettings.DangerType.DAMAGE:
					h_start = 40.0
					h_end = 20.0
					angle = -30.0
				FrameworkSettings.DangerType.ARMOR:
					h_start = 200.0
					h_end = 220.0
					angle = 0.0
					#h_start = 200.0
					#h_end = 220.0
					#s_start = 0.4
					#s_end = 0.5
					#v_start = 0.4
					#v_end = 0.5
					#angle = 0.0
					
	
	shader_color_start = Color.from_hsv(h_start / max_h, s_start, v_start)
	shader_color_end = Color.from_hsv(h_end / max_h, s_end, v_end)
	
	material = ShaderMaterial.new()
	material.shader = load("res://entities/token/token gradient.gdshader")
	material.set_shader_parameter("color_start", shader_color_start)
	material.set_shader_parameter("color_end", shader_color_end)
	material.set_shader_parameter("angle", angle)
	
