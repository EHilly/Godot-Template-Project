@tool
class_name AutoScriptEdits
extends EditorPlugin

const READY_FUNCTION_STUB:String = "# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body."

const PROCESS_FUNCTION_STUB:String = "# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass"

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
	if (script == null): 
		return #When godot first opens, sometimes the editor_script_changed signal gets emitted with a null value
		
	var script_filepath := script.resource_path
	var script_filename := script_filepath.get_file()
	
	if (_is_new_script(script)):
		known_gdscript_files.add(script_filename)
		create_tween().tween_callback(_on_opened_new_script.bind(script, script_filename)).set_delay(0.1)


#New scripts sometimes come with functions defined (e.g. _ready())
#But they typically don't have any vars declared
func _is_new_script(script:Script):
	return !known_gdscript_files.has(script.resource_path.get_file()) \
		   and !script.source_code.contains("var")


func _on_opened_new_script(script:Script, script_filename:String):
	var new_source_code := script.source_code
	
	#If class_name isn't present, add it. Oh, also avoid adding it to autoloads
	if (script.get_global_name() == ""):
		var script_filename_without_extension = script_filename.split(".")[0]
		var pascal_case_class_name = _convert_snake_case_to_pascal_case(script_filename_without_extension)
		
		if (script.resource_path.contains("Autoloads/")):
			new_source_code = new_source_code.replace("extends ", ("# This is an autoload named %s\nextends " % pascal_case_class_name))
		else:
			new_source_code = new_source_code.replace("extends ", ("class_name %s\nextends " % pascal_case_class_name))

	new_source_code = new_source_code.replace(READY_FUNCTION_STUB, "")
	new_source_code = new_source_code.replace(PROCESS_FUNCTION_STUB, "")
	
	if (script.source_code != new_source_code):
		FileUtilities.modify_active_script_source_code(script, new_source_code)
	

func _convert_snake_case_to_pascal_case(snake_case_string: String) -> String:
	var parts = snake_case_string.split("_")
	var pascal_case_string = ""
	
	for part in parts:
		if part.length() > 0:
			pascal_case_string += part[0].to_upper() + part.substr(1)
	
	return pascal_case_string


func get_plugin_name() -> String:
	return "Auto Script Edits"
