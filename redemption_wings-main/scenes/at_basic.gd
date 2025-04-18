extends Area2D
class_name Projectile

@export var speed: float = 700
@export var damage: float = 10
@export var showGlow: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var glow: PointLight2D = $Glow

func _ready():
	add_to_group("projeteis")
	# Configuração para detectar tanto corpos quanto áreas
	connect("body_entered", _on_collision)
	connect("area_entered", _on_collision)

func _process(delta):
	position.x += speed * delta
	if position.x > 1290:
		queue_free()

func _on_collision(target):
	if target.is_in_group("inimigos"):
		# Tenta causar dano no alvo direto ou em seu parente
		var enemy = target if target.has_method("levar_dano") else target.get_parent()
		if enemy and enemy.has_method("levar_dano"):
			enemy.levar_dano(damage)
			queue_free()

func powerShot(charge_damage: float):
	damage = charge_damage
	speed = 700 + (charge_damage - 1.0) * 100
	scale = Vector2.ONE * (1.0 + (charge_damage - 1.0) * 0.5)
	
	if glow:
		glow.visible = true
		glow.energy = (charge_damage - 1.0) * 2.0
