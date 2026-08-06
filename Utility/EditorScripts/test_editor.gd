@tool
class_name TestEditor
extends EditorScript

func _run() -> void:
	print(_get_all_files_in_directory_and_subdirectories("res://", ".gd"))

static func _get_all_files_in_directory_and_subdirectories(directory_path:String, file_extension:String = "") -> Set:
	var files:Set = Set.new([])
	
	for file in DirAccess.get_files_at(directory_path):
		if ((file_extension == "") or file.ends_with(file_extension)):
			files.add(file)
	
	for subdirectory in DirAccess.get_directories_at(directory_path):
		var subdirectory_full_path = directory_path + "/" + subdirectory
		var files_in_subdirectory = _get_all_files_in_directory_and_subdirectories(subdirectory_full_path, file_extension)
		files = files.union(files_in_subdirectory)
	
	return files
