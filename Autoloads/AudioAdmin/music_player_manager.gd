class_name MusicPlayerManager
extends Node

const FULL_VOLUME_DB:float = 0
const INAUDIBLE_VOLUME_DB:float = -80

@export var active_music_player:AudioStreamPlayer
@export var inactive_music_player:AudioStreamPlayer

var current_track_fade_out_tween:Tween
var new_track_fade_in_tween:Tween

func play_music(music_stream:AudioStream, crossfade_duration:float = 0.5):
	#Fade out the current track
	current_track_fade_out_tween = TweenUtilities.kill_and_recreate_tween(self, current_track_fade_out_tween)
	current_track_fade_out_tween.tween_property(active_music_player, "volume_db", INAUDIBLE_VOLUME_DB, crossfade_duration)
	current_track_fade_out_tween.tween_callback(active_music_player.stop)
	
	#Fade in the new one
	inactive_music_player.volume_db = INAUDIBLE_VOLUME_DB
	new_track_fade_in_tween = TweenUtilities.kill_and_recreate_tween(self, new_track_fade_in_tween)
	new_track_fade_in_tween.tween_property(inactive_music_player, "volume_db", FULL_VOLUME_DB, crossfade_duration)
	inactive_music_player.stream = music_stream
	inactive_music_player.play()
	
	#Swap the "active" and "inactive" references
	var old_active_player = active_music_player
	active_music_player = inactive_music_player
	inactive_music_player = old_active_player
