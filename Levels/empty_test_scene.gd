class_name EmptyTestScene
extends Node2D

@export var error_sound_effect:AudioStream
@export var short_beep_sound_effect:AudioStream
@export var click_sound_effect:AudioStream

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("up")):
		AudioAdmin.play_sound_effect(error_sound_effect)
	if (event.is_action_pressed("left")):
		Transitions.animate_diamond_wipe(Color.BLACK, Color.TRANSPARENT, 1)
	if (event.is_action_pressed("right")):
		Transitions.animate_diamond_wipe(Color.TRANSPARENT, Color.BLACK, 1)
	elif (event.is_action_pressed("primary_action")):
		AudioAdmin.play_sound_effect(short_beep_sound_effect)
	elif (event.is_action_pressed("secondary_action")):
		AudioAdmin.play_sound_effect(click_sound_effect)
	
