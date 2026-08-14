class_name FileUtilities
extends Node


static func modify_active_script_source_code(script:Script, new_source_code:String):
	EditorInterface.get_script_editor().close_file(script.resource_path)
	script.source_code = new_source_code
	ResourceSaver.save(script, script.resource_path)
	EditorInterface.edit_script(script)


static func get_all_filenames_in_directory_and_subdirectories(directory_path:String, file_extension:String = "", should_include_full_paths:bool = false) -> Set:
	var filenames:Set = Set.new([])
	
	#print("Exploring this directory: %s" % directory_path)
	
	for file in DirAccess.get_files_at(directory_path):
		if ((file_extension == "") or file.ends_with(file_extension)):
			if (should_include_full_paths):
				var full_path := directory_path + file
				#print("Adding this filepath: %s" % full_path)
				filenames.add(full_path)
			else:
				#print("Value of should_include_full_paths is %s" % should_include_full_paths)
				filenames.add(file)
	
	for subdirectory in DirAccess.get_directories_at(directory_path):
		if (!subdirectory.begins_with(".")):
			var subdirectory_full_path = directory_path + subdirectory + "/"
			var filenames_in_subdirectory = get_all_filenames_in_directory_and_subdirectories(subdirectory_full_path, file_extension, should_include_full_paths)
			filenames = filenames.union(filenames_in_subdirectory)
		
	return filenames


static func get_num_lines_in_file(file_path: String) -> int:
	var file_access = FileAccess.open(file_path, FileAccess.READ)
	var file_contents = file_access.get_as_text()
	var lines = file_contents.split("\n")
	return len(lines)
