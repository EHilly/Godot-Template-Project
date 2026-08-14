#This is an autoload named Transitions
extends CanvasLayer

@export var screen_cover:ColorRect

var animation_progress_tween:Tween

func animate_diamond_wipe(start_color:Color, end_color:Color, duration:float) -> void:
	_refresh_animation_progress_tween()
	
	screen_cover.material.set_shader_parameter("progress", 0.0)
	screen_cover.material.set_shader_parameter("start_color", start_color)
	screen_cover.material.set_shader_parameter("end_color", end_color)
	
	animation_progress_tween.tween_property(screen_cover.material, "shader_parameter/progress", 1, duration)

func _refresh_animation_progress_tween():
	if (animation_progress_tween != null):
		animation_progress_tween.kill()
	animation_progress_tween = create_tween()
