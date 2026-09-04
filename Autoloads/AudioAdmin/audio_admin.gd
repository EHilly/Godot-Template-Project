# This is an autoload named AudioAdmin
extends Node

@export var sfx_player_manager:SfxPlayerManager

func play_sound_effect(stream:AudioStream):
	sfx_player_manager.play_sound_effect(stream)
