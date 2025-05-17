@tool
extends EditorPlugin

var interface

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Adding the plugins main interface
	interface = preload("res://addons/atk_tools/editor/interface.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, interface)
	
	## ===== Adding the Tools available within the plugin ====== ##
	# Randomizer
	add_autoload_singleton("Randomizer", "res://addons/atk_tools/tools/randomizer.gd")


func _exit_tree() -> void:
	# Removing the plugins main interface
	if interface:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, interface)
		interface.queue_free()

	## ===== Removing the Tools available within the plugin ====== ##
	# Randomizer
	remove_autoload_singleton("Randomizer")
