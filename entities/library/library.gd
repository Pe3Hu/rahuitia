class_name Library
extends PanelContainer


@export var board: Board

@onready var pedestal: Pedestal = %Pedestal
@onready var scroll_dropzones: = [
	%ScrollDropzone1,
	%ScrollDropzone2,
	%ScrollDropzone3,
	%ScrollDropzone4,
	%ScrollDropzone5,
]


func init_scroll_core_cards() -> void:
	for scroll_dropzone in scroll_dropzones:
		scroll_dropzone.init_scroll_cards()
	
func get_scroll_on_pedestal() -> ScrollCardDropzone:
	var index = FrameworkSettings.TEMPORARY_LEVEL - 1
	if scroll_dropzones.size() <= index:
		print("")
		return null
	return scroll_dropzones[index]
	
