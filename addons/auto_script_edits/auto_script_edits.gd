@tool
extends EditorPlugin

var script_editor: ScriptEditor
var known_gdscript_files:Set = Set.new()


func _enter_tree() -> void:
	script_editor = get_editor_interface().get_script_editor()
	
	if (script_editor == null):
		print("[AutoScriptEdits] ERROR: Could not get editor references")
		return
	
	known_gdscript_files = FileUtilities.get_all_filenames_in_directory_and_subdirectories("res://", ".gd").duplicate()
	
	script_editor.editor_script_changed.connect(_on_editor_script_changed)


func _exit_tree() -> void:
	if (script_editor != null and script_editor.editor_script_changed.is_connected(_on_editor_script_changed)):
		script_editor.editor_script_changed.disconnect(_on_editor_script_changed)


func _on_editor_script_changed(script:Script) -> void:
	var script_filepath := script.resource_path
	var script_filename := script_filepath.get_file()
	
	if (!known_gdscript_files.has(script_filename)):
		known_gdscript_files.add(script_filename)
		create_tween().tween_callback(_on_opened_new_script.bind(script, script_filename)).set_delay(0.1)


func _on_opened_new_script(script:Script, script_filename:String):
	var new_source_code := script.source_code
	
	#If class_name isn't present, add it
	if (script.get_global_name() == ""):
		var script_filename_without_extension = script_filename.split(".")[0]
		var pascal_case_class_name = _convert_snake_case_to_pascal_case(script_filename_without_extension)
		new_source_code = new_source_code.replace("extends ", ("class_name %s\nextends " % pascal_case_class_name))
		modify_script_source_code(script, new_source_code)


static func modify_script_source_code(script:Script, new_source_code:String):
	var is_script_open:bool = false
	var current_script:Script = EditorInterface.get_script_editor().get_current_script()
	
	EditorInterface.get_script_editor().close_file(script.resource_path)
	#script_editor.close_file(script.resource_path)
	script.source_code = new_source_code
	ResourceSaver.save(script, script.resource_path)
	EditorInterface.edit_script(script)


func _convert_snake_case_to_pascal_case(snake_case_string: String) -> String:
	var parts = snake_case_string.split("_")
	var pascal_case_string = ""
	
	for part in parts:
		if part.length() > 0:
			pascal_case_string += part[0].to_upper() + part.substr(1)
	
	return pascal_case_string


func get_plugin_name() -> String:
	return "Auto Script Edits"
