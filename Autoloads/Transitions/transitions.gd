#This is an autoload named Transitions
extends CanvasLayer

@export var screen_cover:ColorRect

var animation_progress_tween:Tween

func animate_diamond_wipe_and_return_animation_tween(start_color:Color, end_color:Color, duration:float) -> Tween:
	animation_progress_tween = TweenUtilities.kill_and_recreate_tween(self, animation_progress_tween)
	
	screen_cover.material.set_shader_parameter("progress", 0.0)
	screen_cover.material.set_shader_parameter("start_color", start_color)
	screen_cover.material.set_shader_parameter("end_color", end_color)
	
	animation_progress_tween.tween_property(screen_cover.material, "shader_parameter/progress", 1, duration)
	return animation_progress_tween
