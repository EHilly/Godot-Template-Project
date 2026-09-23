@tool
class_name StaticCreateMethod
extends EditorScript

'''
This is a pattern that I like to use for small projects.
Suppose we have a scene with this uid: "uid://du6nmhclrgepo"
And suppose this scene's class is Bullet
It'd be nice if Bullet had a static factory method that instantiates the bullet scene, like this:
	class_name Bullet
	...
	const _SELF_SCENE = preload("uid://du6nmhclrgepo")
	static func create() -> Bullet:
		var bullet:Bullet = _SELF_SCENE.instantiate()
		return bullet

This editor script creates that for you.

Note that because we're using class_name and preload(), we incur the loading cost every time the game starts. 
For a larger project, we might want to use a system that loads resources in the background instead.
'''

func _run() -> void:
	var current_script:Script = EditorInterface.get_script_editor().get_current_script()
	
	if (current_script == null):
		print("[StaticCreateMethod] Warning: no active script")
		return
	elif (current_script.get_global_name() == ""):
		print("[StaticCreateMethod] Warning: active script has no class_name")
		return
	elif (current_script.source_code.contains("static func create")):
		print("[StaticCreateMethod] Warning: active script already has a static create() func")
		return
	
	var modified_source_code = _make_modified_source_code(current_script)
	FileUtilities.modify_active_script_source_code(current_script, modified_source_code)


func _make_static_create_func(current_script:Script) -> String:
	var tscn_resource_path:String = current_script.resource_path.replace(".gd", ".tscn")
	var tscn_resource_uid:String = ResourceUID.path_to_uid(tscn_resource_path)
	var snake_case_class_name:String = current_script.resource_path.get_file().split(".")[0]

	var static_create_func = "const _SELF_SCENE = preload('%s')\n\n" % tscn_resource_uid
	static_create_func += "static func create() -> %s:\n" % current_script.get_global_name()
	static_create_func += "\tvar %s:%s = _SELF_SCENE.instantiate()\n" % [snake_case_class_name, current_script.get_global_name()]
	static_create_func += "\treturn %s" % snake_case_class_name
	
	return static_create_func


func _make_modified_source_code(current_script:Script) -> String:
	var new_source_code = current_script.source_code
	
	var first_function_index = current_script.source_code.find("func ")
	if (first_function_index == -1):
		print("Couldn't find a function match")
		new_source_code += "\n\n" + _make_static_create_func(current_script)
	else:
		var insertion_index = first_function_index
		
		var previous_double_linebreak_index:int = current_script.source_code.rfind("\n\n", first_function_index)
		if (previous_double_linebreak_index != -1):
			insertion_index = previous_double_linebreak_index + 2			

		new_source_code = current_script.source_code.substr(0, insertion_index) \
						  + _make_static_create_func(current_script) + "\n\n" \
						  + current_script.source_code.substr(insertion_index)
	
	return new_source_code
