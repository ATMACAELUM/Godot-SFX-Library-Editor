@tool
extends EditorPlugin

var _library_editor_ux: LibraryEditorUX

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	_load_gui()
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(_library_editor_ux)
	_library_editor_ux.queue_free()
	pass

func _handles(object: Object) -> bool:
	return object is SFXLibrary
	
	
func _edit(object: Object) -> void:
	if object is not SFXLibrary: return
	if !is_instance_valid(_library_editor_ux):
		_load_gui()
	make_bottom_panel_item_visible(_library_editor_ux)
	_bind_to_editor(object)

func _load_gui():
	_library_editor_ux = load("res://addons/sfx_library_editor/sfx_library_editor_ux.tscn").instantiate()
	add_control_to_bottom_panel(_library_editor_ux, "SFX Library Editor")


func _bind_to_editor(object):
	_library_editor_ux.load_sfx_library(object)
