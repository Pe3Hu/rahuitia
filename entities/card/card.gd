@tool
class_name Card
extends PanelContainer


#region signal
signal card_hovered(card: Card)
signal card_unhovered(card: Card)
signal card_clicked(card: Card)
signal card_dropped(card: Card)
#endregion

#region var
@export var board: Board

@onready var frontface = %Frontface
@onready var backface = %Backface

#@export var card_data: CardData
@export var core_resource: CardCoreResource
@export var threat_resource: CardThreatResource:
	set(value_):
		threat_resource = value_
		threat_resource.preparation()

var frontface_texture: String
var backface_texture: String

var is_clicked: bool = false
var mouse_is_hovering: bool = false
var drag_when_clicked: bool = true

var target_position: #Vector2 = Vector2.ZERO:
	set(value_):
		if get_parent() is ScrollCardDropzone: return
		#if get_parent() is ThreatCardDropzone: return
		target_position = value_
var return_speed: float = 0.2
var hover_distance: float = 10
var last_child_count: int = 0
#endregion


#region get set
#func get_custom_class(): return "Card"
	#
#func is_custom_class(name): return name == "Card"
	
func set_direction(card_is_facing: Vector2) -> void:
	backface.visible = card_is_facing == Vector2.DOWN
	frontface.visible = card_is_facing == Vector2.UP
	
func set_disabled(value_: bool) -> void:
	if value_:
		mouse_is_hovering = false
		is_clicked = false
		rotation = 0
		var parent = get_parent()
		if parent is CardPile:
			parent.reset_card_z_index()
	
func get_dropzones(node: Node, className: String, result: Array) -> void:
	if node is CardDropzone:
		result.push_back(node)
	for child in node.get_children():
		get_dropzones(child, className, result)
	
func get_configuration_warnings():
	if get_child_count() != 2:
		return [ "This node must have 2 TextureRect as children, one named `Frontface` and one named `Backface`." ]
	for child in get_children():
		if not child is TextureRect or (child.name != "Frontface" and child.name != "Backface"):
			return [ "This node must have 2 TextureRect as children, one named `Frontface` and one named `Backface`." ]
	return []
#endregion

func _ready() -> void:
	if Engine.is_editor_hint():
		set_disabled(true)
		update_configuration_warnings()
		return
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("gui_input", _on_gui_input)
	if frontface_texture:
		frontface.texture = load(frontface_texture)
		backface.texture = load(backface_texture)
		#custom_minimum_size = frontface.texture.get_size()
		pivot_offset = frontface.texture.get_size() / 2
		mouse_filter = Control.MOUSE_FILTER_PASS
	
func card_can_be_interacted_with() -> bool:
	var parent = get_parent()
	var is_valid = false
	
	if parent is CardPile:
		# check for cards in hand
		if parent.is_card_in_hand(self):
			is_valid = parent.is_hand_enabled() and not parent.is_any_card_clicked()
		# check for cards in dropzone
		var dropzone = parent.get_card_dropzone(self)
		if dropzone:
			is_valid = dropzone.get_top_card() == self and not parent.is_any_card_clicked()
	
	return is_valid
	
func _process(_delta):
	if is_clicked and drag_when_clicked:
		target_position = get_global_mouse_position() - size * 0.5
	if is_clicked:
		position = target_position
	elif position != target_position:
		if position == null: 
			return
		if typeof(target_position) != TYPE_VECTOR2: 
			return
		#var a = [position, target_position, return_speed]
		#print([target_position, typeof(target_position)])
		#print(a)
		position = lerp(position, target_position, return_speed)
		
	if Engine.is_editor_hint() and last_child_count != get_child_count():
		update_configuration_warnings()
		last_child_count = get_child_count()

#region mouse
func _on_mouse_entered() -> void:
	#check if is hovering should be turned on
	if card_can_be_interacted_with():
		board.custom_cursor.current_state = FrameworkSettings.CursorState.SELECT
		mouse_is_hovering = true
		target_position.y -= hover_distance
		var parent = get_parent()
		parent.reset_card_z_index()
		emit_signal("card_hovered", self)
	
func _on_mouse_exited():
	if is_clicked:
		return
	if mouse_is_hovering:
		board.custom_cursor.current_state = FrameworkSettings.CursorState.IDLE
		mouse_is_hovering = false
		target_position.y += hover_distance
		var parent = get_parent()
		if parent is CardPile:
			parent.reset_card_z_index()
		emit_signal("card_unhovered", self)
	
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var parent = get_parent()
			
			if card_can_be_interacted_with():
				is_clicked = true
				board.custom_cursor.current_state = FrameworkSettings.CursorState.HOLD
				rotation = 0
				parent.reset_card_z_index()
				emit_signal("card_clicked", self)
			
			if parent is CardPile and parent.get_card_pile_size(FrameworkSettings.PileType.DRAW) > 0 and parent.is_hand_enabled() and parent.get_cards_in_pile(FrameworkSettings.PileType.DRAW).find(self) != -1 and not parent.is_any_card_clicked() and parent.click_draw_pile_to_draw:
				parent.draw(1)
		else:
			#event released
			if is_clicked:
				is_clicked = false
				board.custom_cursor.current_state = FrameworkSettings.CursorState.IDLE
				mouse_is_hovering = false
				rotation = 0
				var parent = get_parent()
				
				if board.tide.is_mouse_inside:
					if board.bank.can_drop_card(self):
						board.bank.card_dropped(self)
					else:
						parent.call_deferred("reset_target_positions")
				else:
					if parent is CardPile and parent.is_card_in_hand(self):
						parent.call_deferred("reset_target_positions")
					var all_dropzones:= []
					get_dropzones(get_tree().get_root(), "CardDropzone", all_dropzones)
					for dropzone in all_dropzones:
						if dropzone.get_global_rect().has_point(get_global_mouse_position()):
							if dropzone.can_drop_card(self):
								dropzone.card_dropped(self)
								break
				emit_signal("card_dropped", self)
				emit_signal("card_unhovered", self)
#endregion
