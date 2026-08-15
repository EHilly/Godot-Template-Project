class_name MainMenu
extends CanvasLayer

@export var play_button:Button
@export var options_button:Button
@export var credits_button:Button
@export var quit_button:Button


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_was_pressed)
	options_button.pressed.connect(_on_options_button_was_pressed)
	credits_button.pressed.connect(_on_credits_button_was_pressed)
	quit_button.pressed.connect(_on_quit_button_was_pressed)

func _on_play_button_was_pressed():
	pass

func _on_options_button_was_pressed():
	pass

func _on_credits_button_was_pressed():
	pass
	
func _on_quit_button_was_pressed():
	get_tree().quit()
