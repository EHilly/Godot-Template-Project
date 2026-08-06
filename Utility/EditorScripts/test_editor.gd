@tool
class_name TestEditor
extends EditorScript

func _run() -> void:
	print(get_all_filenames_in_directory_and_subdirectories("res://", ".gd"))

static func get_all_filenames_in_directory_and_subdirectories(directory_path:String, file_extension:String = "") -> Set:
	var filenames:Set = Set.new([])
	
	for file in DirAccess.get_files_at(directory_path):
		if ((file_extension == "") or file.ends_with(file_extension)):
			filenames.add(file)
	
	for subdirectory in DirAccess.get_directories_at(directory_path):
		var subdirectory_full_path = directory_path + "/" + subdirectory
		var filenames_in_subdirectory = get_all_filenames_in_directory_and_subdirectories(subdirectory_full_path, file_extension)
		filenames = filenames.union(filenames_in_subdirectory)
	
	return filenames


static func get_num_lines_in_file(file_path: String) -> int:
	var file_access = FileAccess.open(file_path, FileAccess.READ)
	var file_contents = file_access.get_as_text()
	var lines = file_contents.split("\n")
	return len(lines)
