extends CharacterBody2D

@export var vida: float = 2.0
@export var speed: float = 200.0
@export var damage: float = 1.0

func _ready():
	add_to_group("inimigos")
	# Configura a área de hitbox
	$HitboxArea.body_entered.connect(_on_hitbox_body_entered)
	$HitboxArea.area_entered.connect(_on_hitbox_area_entered)

func _physics_process(delta):
	velocity = Vector2.LEFT * speed
	move_and_slide()
	
	# Empurrar jogador sem afetar movimento do inimigo
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):
			collision.get_collider().take_damage(damage)

	if saiu_da_tela():
		queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)

func _on_hitbox_area_entered(area):
	if area.is_in_group("projeteis"):
		levar_dano(area.damage)
		area.queue_free()

func levar_dano(dano: float):
	vida -= dano
	if vida <= 0:
		morrer()

func morrer():
	queue_free()

func saiu_da_tela() -> bool:
	var extents = $CollisionShape2D.shape.extents
	return global_position.x + extents.x < -50
