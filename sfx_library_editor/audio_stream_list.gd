@tool
class_name AudioStreamList
extends ItemList


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if get_viewport().gui_get_drag_data():
			print_debug(_can_drop_data(event.position, get_viewport().gui_get_drag_data()))
		#print_debug(get_viewport().gui_get_drag_data())

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if typeof(data) == TYPE_DICTIONARY:
		return true
	return false

	
func _drop_data(position: Vector2, data: Variant) -> void:
	var audio_stream = data.get("resource")
	if audio_stream is AudioStream:
		print("Dropped AudioStream:", audio_stream)
		# You can now assign it to a player or store it
