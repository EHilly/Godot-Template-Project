class_name TestScene
extends Node2D

@export var error_sound_effect:AudioStream
@export var short_beep_sound_effect:AudioStream
@export var click_sound_effect:AudioStream

@export var music_stream:AudioStream

func _ready() -> void:
	AudioAdmin.music_player_manager.play_music(music_stream)

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("up")):
		AudioAdmin.sfx_player_manager.play_sound_effect(error_sound_effect)
	if (event.is_action_pressed("left")):
		Transitions.animate_diamond_wipe_and_return_animation_tween(Color.BLACK, Color.TRANSPARENT, 1)
	if (event.is_action_pressed("right")):
		Transitions.animate_diamond_wipe_and_return_animation_tween(Color.TRANSPARENT, Color.BLACK, 1)
	elif (event.is_action_pressed("primary_action")):
		AudioAdmin.sfx_player_manager.play_sound_effect(short_beep_sound_effect)
	elif (event.is_action_pressed("secondary_action")):
		AudioAdmin.sfx_player_manager.play_sound_effect(click_sound_effect)
	
