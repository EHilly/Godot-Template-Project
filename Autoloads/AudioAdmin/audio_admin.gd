# This is an autoload named AudioAdmin
extends Node

const INITIAL_NUM_SOUND_EFFECT_PLAYERS:int = 8

var _active_sound_effect_players:Set = Set.new()
var _inactive_sound_effect_players:Set = Set.new()

func play_sound_effect(stream:AudioStream):
	var player:AudioStreamPlayer
	if (_inactive_sound_effect_players.size() == 0):
		player = _add_sound_effect_player()
	else:
		player = _inactive_sound_effect_players.pop()
	
	_active_sound_effect_players.add(player)
	player.stream = stream
	player.play()

func _add_sound_effect_player() -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.finished.connect(func(): _on_sound_effect_player_finished(player))
	add_child(player)
	return player

func _on_sound_effect_player_finished(player:AudioStreamPlayer):
	_active_sound_effect_players.erase(player)
	_inactive_sound_effect_players.add(player)

func _ready() -> void:
	for i in INITIAL_NUM_SOUND_EFFECT_PLAYERS:
		_inactive_sound_effect_players.add(_add_sound_effect_player())
