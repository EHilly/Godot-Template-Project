class_name TweenUtilities
extends Node

static func kill_and_recreate_tween(node:Node, tween:Tween) -> Tween:
	if (tween != null):
		tween.kill()
	return node.create_tween()
