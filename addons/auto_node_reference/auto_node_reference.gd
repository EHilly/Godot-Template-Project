@tool
extends EditorPlugin


func _build() -> bool:
	_populate_null_exported_node_references_for_all_tscns_in_project()
	return true

func _populate_null_exported_node_references_for_all_tscns_in_project():
	var all_tscn_paths = FileUtilities.get_all_filenames_in_directory_and_subdirectories("res://", ".tscn", true)
	for tscn_filepath in all_tscn_paths.elements():
		var scene_root_node:Node = load(tscn_filepath).instantiate()
		_populate_null_exported_node_references_on_node_and_all_descendants(scene_root_node)
		_save_modified_tscn(tscn_filepath, scene_root_node)

func _save_modified_tscn(tscn_filepath:String, modified_root_node:Node):
	var packed_scene = PackedScene.new()
	packed_scene.pack(modified_root_node)
	ResourceSaver.save(packed_scene, tscn_filepath)
	if (EditorInterface.get_open_scenes().has(tscn_filepath)):
		EditorInterface.reload_scene_from_path(tscn_filepath)

func _populate_null_exported_node_references_on_node_and_all_descendants(current_node:Node):
	_populate_null_exported_node_references_on_node(current_node)
	for child_node in current_node.get_children():
		_populate_null_exported_node_references_on_node_and_all_descendants(child_node)

func _populate_null_exported_node_references_on_node(current_node:Node):
	var attached_script:Script = current_node.get_script()
	if (attached_script != null):
		for property in attached_script.get_script_property_list():
			if (_is_property_an_exported_node_reference_variable(property)):
				if (current_node.get(property.get("name")) == null):
					_attempt_to_assign_node_reference_variable_property(current_node, property)

func _attempt_to_assign_node_reference_variable_property(node:Node, property:Dictionary):
	#print("For %s, attempting to assign a var named %s by finding a descendant of type %s" % [node.name, property.get("name"), property.get("class_name")])
	var candidate_descendants = node.find_children("*", property.get("class_name"))
	var best_descendant:Node
	if (len(candidate_descendants) > 1):
		best_descendant = _pick_best_node_based_on_name_similarity(candidate_descendants, property.get("name"))
	elif (len(candidate_descendants) == 1):
		best_descendant = candidate_descendants[0]
	else:
		return
	node.set(property.get("name"), best_descendant)
	
func _pick_best_node_based_on_name_similarity(nodes:Array[Node], target_name:String) -> Node:
	var best_node:Node = nodes[0]
	var best_similarity = nodes[0].name.similarity(target_name)
	
	for current_node in nodes.slice(1):
		var current_node_similarity = current_node.name.similarity(target_name)
		if (current_node_similarity > best_similarity):
			best_node = current_node
			best_similarity = current_node_similarity
	
	return best_node

func _is_property_an_exported_node_reference_variable(property:Dictionary) -> bool:
	var usage_flags = property.get("usage")
	return ((usage_flags & PROPERTY_USAGE_SCRIPT_VARIABLE) > 0) \
			and ((usage_flags & PROPERTY_USAGE_STORAGE) > 0) \
			and (property.get("hint") == PROPERTY_HINT_NODE_TYPE)
