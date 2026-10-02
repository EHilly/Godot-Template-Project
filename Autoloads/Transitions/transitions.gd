#This is an autoload named Transitions
extends CanvasLayer

signal animation_finished

@export var screen_cover:ColorRect

var _animation_progress_tween:Tween

func animate_diamond_wipe(start_color:Color, end_color:Color, duration:float):
	if _animation_progress_tween != null and _animation_progress_tween.is_running():
		push_warning("Tried to start transition animation while one was already running")
	else:
		_animation_progress_tween = TweenUtilities.kill_and_recreate_tween(self, _animation_progress_tween)
		
		screen_cover.material.set_shader_parameter("progress", 0.0)
		screen_cover.material.set_shader_parameter("start_color", start_color)
		screen_cover.material.set_shader_parameter("end_color", end_color)
		
		_animation_progress_tween.tween_property(screen_cover.material, "shader_parameter/progress", 1, duration)
		_animation_progress_tween.finished.connect(animation_finished.emit)
