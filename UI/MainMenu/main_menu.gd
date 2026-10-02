class_name MainMenu
extends CanvasLayer

@export var play_button:Button
@export var options_button:Button
@export var credits_button:Button
@export var quit_button:Button

@export var credits_submenu:Submenu

@export var main_menu_music_stream:AudioStream

var scene_to_load_when_play_button_is_pressed:PackedScene = preload("uid://du6nmhclrgepo") #res://Levels/test_scene.tscn

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_was_pressed)
	options_button.pressed.connect(_on_options_button_was_pressed)
	credits_button.pressed.connect(_on_credits_button_was_pressed)
	quit_button.pressed.connect(_on_quit_button_was_pressed)
	
	credits_submenu.visibility_changed.connect(_on_credits_submenu_visibility_changed)
	
	play_button.grab_focus.call_deferred()
	
	AudioAdmin.music_player_manager.play_music(main_menu_music_stream, 0)


func _on_play_button_was_pressed():
	Transitions.animate_diamond_wipe(Color.TRANSPARENT, Color.BLACK, 0.5)
	await Transitions.animation_finished
	Transitions.animate_diamond_wipe(Color.BLACK, Color.TRANSPARENT, 0.5)
	get_tree().change_scene_to_packed(scene_to_load_when_play_button_is_pressed)
	

func _on_options_button_was_pressed():
	pass

func _on_credits_button_was_pressed():
	credits_submenu.visible = true
	visible = false	
	
func _on_quit_button_was_pressed():
	get_tree().quit()

func _on_credits_submenu_visibility_changed():
	if (!credits_submenu.visible):
		visible = true
		credits_button.grab_focus()
