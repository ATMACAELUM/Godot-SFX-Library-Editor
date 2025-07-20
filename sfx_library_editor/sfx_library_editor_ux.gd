@tool
class_name LibraryEditorUX
extends Control



@export var _keys_navigation_container: ItemList
@export var _values_container: ItemList

@export var _new_sfx_tag_button: Button
@export var _delete_sfx_tag_button: Button
@export var _delete_sfx_button: Button
@export var _new_sfx_tag_input: LineEdit

@export_group("Audio Player", "_ap")
@export var _ap_selected_audio_name_label: Label
@export var _ap_audio_stream_player: AudioStreamPlayer
@export var _ap_stream_progress_bar: ProgressBar
@export var _ap_play_button: Button
@export var _ap_pause_button: Button
@export var _ap_restart_button: Button

var _sfx_reference: SFXLibrary
var _selected_key_name = ""
var _selected_key_id: int
var _selected_value: int
var _selected_stream: AudioStream


func _ready() -> void:
	_new_sfx_tag_button.pressed.connect(_add_new_sfx_tag_key)
	_delete_sfx_tag_button.pressed.connect(_delete_sfx_tag)
	_delete_sfx_button.pressed.connect(_delete_sfx)
	_keys_navigation_container.item_selected.connect(_on_key_pressed)
	_values_container.item_selected.connect(_on_value_pressed)
	
	_ap_audio_stream_player.get_playback_position()
	_ap_play_button.pressed.connect(_play)
	_ap_pause_button.pressed.connect(_pause)
	_ap_restart_button.pressed.connect(_restart)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_released(): return
		if _can_drop_data(event.position, get_viewport().gui_get_drag_data()):
			_drop_data(event.position, get_viewport().gui_get_drag_data())


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if typeof(data) == TYPE_DICTIONARY:
		return true
	return false


func _drop_data(position: Vector2, data: Variant) -> void:
	if !data.has("files"): return
	for path in data.get("files"):
		var obj = load(path)
		if obj is not AudioStream: 
			return
			
	if !_sfx_reference.sfx_library.has(_selected_key_name): return
	for path in data.get("files"):
		var obj = load(path)
		_add_sfx_to_library(_selected_key_name, obj)
	_refresh()


func load_sfx_library(sfx_library: SFXLibrary):
	_sfx_reference = sfx_library
	_refresh()


func _refresh():
	_keys_navigation_container.clear()
	_values_container.clear()
	for each in _sfx_reference.sfx_library.keys():
		var i = _keys_navigation_container.add_item(each)
	if _selected_key_name != "" and _sfx_reference.sfx_library.keys().has(_selected_key_name):
		_on_key_pressed(_selected_key_id)


func _add_new_sfx_tag_key():
	if _new_sfx_tag_input.text == "" or _new_sfx_tag_input.text == " ": 
		push_error("Cannot add a empty tag.")
		return
	_sfx_reference.sfx_library[_new_sfx_tag_input.text] = []
	_new_sfx_tag_input.clear()
	_refresh()
	_save_reference()


func _delete_sfx_tag():
	if is_instance_valid(_sfx_reference) == false:
		return
	if !_sfx_reference.sfx_library.has(_selected_key_name): return
	_sfx_reference.sfx_library.erase(_selected_key_name)
	_refresh()
	_save_reference()


func _delete_sfx():
	if is_instance_valid(_sfx_reference) == false: return
	if !_sfx_reference.sfx_library.has(_selected_key_name): return
	_sfx_reference.sfx_library[_selected_key_name].pop_at(_selected_value)
	_refresh()
	_save_reference()


func _add_sfx_to_library(tag: StringName, audio):
	if is_instance_valid(_sfx_reference) == false: return
	if !_sfx_reference.sfx_library.has(tag): return
	_sfx_reference.sfx_library[tag].append(audio)
	_save_reference()


func _on_key_pressed(id):
	var key = _keys_navigation_container.get_item_text(id)
	if is_instance_valid(_sfx_reference) == false:
		return
	_selected_key_name = key
	_selected_key_id = id
	var values = _sfx_reference.sfx_library.get(key)
	#_keys_navigation_container.clear()
	_values_container.clear()
	for sfx in values:
		_values_container.add_item(str(sfx))
		AudioStreamWAV


func _on_value_pressed(id):
	_selected_value = id
	_load_player()

## Player Functions
func _load_player():
	if is_instance_valid(_sfx_reference) == false:return
	if !_sfx_reference.sfx_library.has(_selected_key_name): return
	if is_instance_valid(_ap_audio_stream_player) == false: return
	
	var stream: AudioStream = _sfx_reference.sfx_library.get(_selected_key_name)[_selected_value]
	_ap_selected_audio_name_label.text = str(stream)
	_ap_audio_stream_player.stream = stream


func _play():
	if is_instance_valid(_ap_audio_stream_player) == false: return
	_ap_audio_stream_player.play()
	pass


func _pause():
	if is_instance_valid(_ap_audio_stream_player) == false: return
	if _ap_audio_stream_player.playing:
		_ap_audio_stream_player.stop()


func _restart():
	if is_instance_valid(_ap_audio_stream_player) == false: return
	if _ap_audio_stream_player.playing:
		_ap_audio_stream_player.stop()
	_ap_audio_stream_player.seek(0)


func _save_reference():
	var ok = ResourceSaver.save(_sfx_reference, _sfx_reference.resource_path)
