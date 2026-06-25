@tool
extends EditorPlugin

# Preload the scene file path
const EZ_THEME = preload("res://addons/EZ-Theme/EZ-Theme.tscn")
var ui_instance: Control

func _enter_tree() -> void:
	# Create an instance of your pre-made UI scene
	ui_instance = EZ_THEME.instantiate()
	
	# Add the instance to the inspector sidebar dock
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, ui_instance)

func _exit_tree() -> void:
	# Always clean up the UI when the plugin is turned off
	if ui_instance:
		remove_control_from_docks(ui_instance)
		ui_instance.queue_free()
