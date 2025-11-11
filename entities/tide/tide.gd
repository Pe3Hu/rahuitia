class_name Tide
extends PanelContainer


@export var board: Board

@onready var threat_dropzones: = [
	%ThreatDropzone1,
	%ThreatDropzone2,
	%ThreatDropzone3,
	%ThreatDropzone4,
	%ThreatDropzone5,
	%ThreatDropzone6,
]

var active_dropzones_threats: Array[ThreatCardDropzone]
var is_refilled: bool = false
var is_mouse_inside: bool = false



func end_of_turn() -> void:
	refill_threat_dropzones()
	
func refill_threat_dropzones() -> void:
	var loop_limit = 10
	var loop_stoper = 0
	is_refilled = active_dropzones_threats.size() >= FrameworkSettings.TURN_THREAT_MIN
	while !is_refilled:
		draw_threat_card()
		loop_stoper += 1
		if loop_stoper == loop_limit:
			is_refilled = true
	
func draw_threat_card() -> void:
	var threat_dropzone = get_free_threat_dropzone()
	if threat_dropzone == null: 
		is_refilled = true
		return
	
	active_dropzones_threats.append(threat_dropzone)
	threat_dropzone.visible = true
	board.card_pile.set_topdeck_to_threat_dropzone(threat_dropzone)
	is_refilled = active_dropzones_threats.size() >= FrameworkSettings.TURN_THREAT_MIN
	
func get_free_threat_dropzone() -> ThreatCardDropzone:
	if active_dropzones_threats.size() == threat_dropzones.size(): return null
	var index = active_dropzones_threats.size()
	return threat_dropzones[index]
	
func _on_mouse_entered() -> void:
	is_mouse_inside = true
	
func _on_mouse_exited() -> void:
	is_mouse_inside = false
