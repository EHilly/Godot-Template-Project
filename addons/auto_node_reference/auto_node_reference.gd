@tool
extends EditorPlugin


func _build() -> bool:
	_populate_exported_node_references_for_all_tscns_in_project()
	return true

func _populate_exported_node_references_for_all_tscns_in_project():
	var all_tscn_paths = FileUtilities.get_all_filenames_in_directory_and_subdirectories("res://", ".tscn", true)
	for tscn_filepath in all_tscn_paths.elements():
		var scene_root_node:Node = load(tscn_filepath).instantiate()
		_populate_exported_node_references_on_node_and_all_descendants(scene_root_node)
		var attached_script = scene_root_node.get_script()
		if (attached_script != null):
			print("Root node of %s has an attached script" % tscn_filepath)


func _log_string_to_test_file(string:String):
	var file_access = FileAccess.open("res://test.txt", FileAccess.READ_WRITE)
	var contents = file_access.get_as_text()
	contents += string + "\n"
	file_access.store_string(contents)
	file_access.close()

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
