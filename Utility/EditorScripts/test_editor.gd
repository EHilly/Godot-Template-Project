@tool
class_name TestEditor
extends EditorScript

func _run() -> void:
	print(FileUtilities.get_all_filenames_in_directory_and_subdirectories("res://", ".gd"))
