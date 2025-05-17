@tool
extends VBoxContainer

@onready var axis_x: CheckBox = %AxisX
@onready var axis_y: CheckBox = %AxisY
@onready var axis_z: CheckBox = %AxisZ
@onready var scale_value: SpinBox = %ScaleValue

var _scale: float = 1.0



func _on_scale_value_value_changed(value: float) -> void:
	pass # Replace with function body.
