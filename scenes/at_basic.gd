extends Area2D
class_name at_basic

@export var speed: float = 700
@export var damage: float = 10
@export var showGlow: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var glow: PointLight2D = $Glow # Light effect for power attack

func _ready():
	glow.visible = showGlow

func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x > 1290:
		queue_free()

func powerShot(hold_time: float):
	 # Activate glow for powerful shots
	speed += hold_time * 100
	damage = 10 + hold_time * 5
	scale += Vector2(hold_time * 0.5, hold_time * 0.5)
	showGlow = true
