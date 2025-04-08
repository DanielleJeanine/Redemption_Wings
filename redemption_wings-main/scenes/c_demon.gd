extends CharacterBody2D

@export var vida: float = 2.0
@export var speed: float = 200.0

func _ready():
	add_to_group("inimigos")

func _physics_process(delta):
	velocity = Vector2.LEFT * speed
	move_and_slide()

	if saiu_da_tela():
		queue_free()

func levar_dano(dano: float):
	vida -= dano
	if vida <= 0:
		morrer()

func morrer():
	queue_free()

func saiu_da_tela() -> bool:
	var extents = $CollisionShape2D.shape.extents if has_node("CollisionShape2D") else Vector2.ZERO
	return global_position.x + extents.x < -50
