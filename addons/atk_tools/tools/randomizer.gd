@tool
extends Node

@onready var affect_x: bool
@onready var affect_y: bool
@onready var affect_z: bool
@onready var scale_value: float

var _scale: float = 1.0

var undo_redo : EditorUndoRedoManager

func randomize_scale():
	undo_redo.create_action("Randomize Scale")
	for node: Node3D in _get_selected_nodes():
		var old_scale = node.scale
		node.scale = _get_random_scale()
		undo_redo.add_do_property(node, "scale", node.scale)
		undo_redo.add_undo_property(node, "scale", old_scale)
	undo_redo.commit_action()

func randomize_rotation():
	undo_redo.create_action("Randomize Rotation")
	for node: Node3D in _get_selected_nodes():
		var old_rot = node.global_rotation
		if affect_x == true:
			node.global_rotation.x = _get_random_rotation()
		if affect_y == true:
			node.global_rotation.y = _get_random_rotation()
		if affect_z == true:
			node.global_rotation.z = _get_random_rotation()
		undo_redo.add_do_property(node, "global_rotation", node.global_rotation)
		undo_redo.add_undo_property(node, "global_rotation", old_rot)
	undo_redo.commit_action()

func reset_scale():
	undo_redo.create_action("Reset Scale")
	for node: Node3D in _get_selected_nodes():
		var old_scale = node.global_rotation
		node.scale = Vector3(1,1,1)
		undo_redo.add_do_property(node, "scale", node.scale)
		undo_redo.add_undo_property(node, "scale", old_scale)
	undo_redo.commit_action()

func reset_rotation():
	undo_redo.create_action("Reset Rotation")
	for node in _get_selected_nodes():
		var old_rot = node.global_rotation
		node.global_rotation = Vector3.ZERO
		undo_redo.add_do_property(node, "global_rotation", node.global_rotation)
		undo_redo.add_undo_property(node, "global_rotation", old_rot)
	undo_redo.commit_action()

func _get_selected_nodes() -> Array[Node]:
	var selection = EditorInterface.get_selection()
	var nodes = selection.get_selected_nodes()
	for node in nodes:
		if node is not Node3D:
			nodes.erase(node)
	return nodes

func _get_random_rotation() -> float:
	return deg_to_rad(randf_range(0.0, 360.0))

func _get_random_scale() -> Vector3:
	var random_num = randf_range(0.1, _scale)
	var random_scale = Vector3(random_num, random_num, random_num)
	return random_scale

func _set_scale(value):
	_scale = value

func scatter_on_surface(mesh_instance: MeshInstance3D, source_scene: PackedScene, count: int, parent: Node3D):
	var mesh = mesh_instance.mesh
	if not mesh or mesh.get_surface_count() == 0:
		return

	var arrays = mesh.surface_get_arrays(0)
	var vertices = arrays[Mesh.ARRAY_VERTEX]
	var indices = arrays[Mesh.ARRAY_INDEX]

	for i in count:
		var tri_index = randi() % (indices.size() / 3) * 3
		var a = vertices[indices[tri_index]]
		var b = vertices[indices[tri_index + 1]]
		var c = vertices[indices[tri_index + 2]]

		var r1 = randf()
		var r2 = randf()
		if r1 + r2 > 1.0:
			r1 = 1.0 - r1
			r2 = 1.0 - r2
		var point = a + (b - a) * r1 + (c - a) * r2
		point = mesh_instance.global_transform.basis * point + mesh_instance.global_transform.origin


		var instance = source_scene.instantiate()
		instance.global_position = point
		parent.add_child(instance)
