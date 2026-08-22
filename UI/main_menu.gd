class_name MainMenu
extends CanvasLayer

@export var play_button:Button
@export var options_button:Button
@export var credits_button:Button
@export var quit_button:Button

@export var credit_screen:Submenu


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_was_pressed)
	options_button.pressed.connect(_on_options_button_was_pressed)
	credits_button.pressed.connect(_on_credits_button_was_pressed)
	quit_button.pressed.connect(_on_quit_button_was_pressed)
	
	credit_screen.visibility_changed.connect(_on_credit_screen_visibility_changed)
	
	play_button.grab_focus.call_deferred()


func _on_play_button_was_pressed():
	get_tree().change_scene_to_file("res://Levels/empty_test_scene.tscn")

func _on_options_button_was_pressed():
	pass

func _on_credits_button_was_pressed():
	credit_screen.visible = true
	visible = false	
	
func _on_quit_button_was_pressed():
	get_tree().quit()

func _on_credit_screen_visibility_changed():
	if (!credit_screen.visible):
		visible = true
		credits_button.grab_focus()
