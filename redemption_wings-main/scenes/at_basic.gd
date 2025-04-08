extends Area2D
class_name at_basic

@export var speed: float = 700
@export var damage: float = 10
@export var showGlow: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var glow: PointLight2D = $Glow

func _ready():
	if glow:  # Garante que o nó existe antes de acessar
		glow.visible = showGlow
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x > 1290:
		queue_free()

func powerShot(charge_damage: float):
	damage = charge_damage
	speed = 700 + (charge_damage - 1.0) * 100
	scale = Vector2.ONE + Vector2(charge_damage - 1.0, charge_damage - 1.0) * 0.5

	showGlow = true
	if glow:
		glow.visible = true
		glow.energy = (charge_damage - 1.0) * 2.0

func _on_body_entered(body):
	if body.is_in_group("inimigos"):
		if body.has_method("levar_dano"):
			body.levar_dano(damage)
		queue_free()
