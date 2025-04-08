extends CharacterBody2D

@export var vida: float = 2.0  # Agora ele "morre" com 2 de dano
@export var speed := 200
@export var spawn_y_margin_top := 0.9  # 90% da tela
@export var spawn_y_margin_bottom := 0.1  # 10% da tela
@export var despawn_margin := 50.0  # Margem para destruir o inimigo
@export var spawn_interval := 4.0

var spawn_timer := 0.0

func _ready():
	add_to_group("inimigos")  # Adiciona ao grupo de inimigos para detecção
	calcular_posicao_spawn()
	spawn_timer = spawn_interval

func _physics_process(delta):
	# Move para a esquerda
	velocity = Vector2.LEFT * speed
	move_and_slide()
	
	# Verifica se saiu da tela pela esquerda
	if out_screen():
		queue_free()
	
	# Lógica do timer de spawn
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_novo_inimigo()
		spawn_timer = spawn_interval

func levar_dano(dano: float):
	vida -= dano
	print("Dano recebido: ", dano, " | Vida restante: ", vida)
	if vida <= 0:
		morrer()

func morrer():
	print("Inimigo morreu!")
	queue_free()

func spawn_novo_inimigo():
	var novo_inimigo = duplicate()
	get_parent().add_child(novo_inimigo)
	novo_inimigo.position = calcular_posicao_spawn()

func calcular_posicao_spawn() -> Vector2:
	var viewport = get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	return Vector2(
		viewport_size.x + despawn_margin,
		randf_range(viewport_size.y * spawn_y_margin_bottom, viewport_size.y * spawn_y_margin_top)
	)

func out_screen() -> bool:
	var viewport_rect = get_viewport_rect()
	var extents = $CollisionShape2D.shape.extents if has_node("CollisionShape2D") else Vector2.ZERO
	return global_position.x + extents.x < -despawn_margin
