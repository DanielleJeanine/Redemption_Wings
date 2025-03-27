extends Area2D
class_name at_basic
@export var speed: float = 700

func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x > 1290:
		queue_free()
