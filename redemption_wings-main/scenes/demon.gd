extends CharacterBody2D

@export var horizontal_speed := 300.0
@export var vertical_speed := 150.0
@export var direction_change_time := 1.5
@export var spawn_margin := 50.0
@export var despawn_margin := 50.0
@export var vida: float = 6.0

@export var bullet_scene: PackedScene
@export var fire_rate := 1.5  # Segundos entre disparos
@export var bullet_speed := 600.0
@export var bullet_offset := Vector2(-20, 0)  # Posição relativa para spawn

@export var limite_superior_y := 70.0  # Limite superior da tela
@export var limite_inferior_y := 650.0  # Limite inferior da tela
@export var margem_seguranca := 50.0    # Margem para não encostar nas bordas

var vertical_direction := 1.0  # 1 para baixo, -1 para cima
var direction_timer := 0.0
var random_y_speed := 0.0
var fire_timer := 0.0

func _ready():
	add_to_group("inimigos")
	randomize()
	posicionar_no_lado_direito()
	# Define uma velocidade vertical inicial aleatória
	random_y_speed = randf_range(vertical_speed * 0.7, vertical_speed * 1.3)
	$HitboxArea.area_entered.connect(_on_hitbox_area_entered)
	fire_timer = fire_rate * randf()  # Dispersão inicial

func _physics_process(delta):
	
	# Atualiza o timer de mudança de direção
	direction_timer += delta
	if direction_timer >= direction_change_time:
		mudar_direcao()
		direction_timer = 0.0
	
	# Movimento vertical com limitação
	velocity.y = clamp(
		velocity.y, 
		-vertical_speed, 
		vertical_speed
	)
	
	# Aplica os limites de posição
	position.y = clamp(
		position.y, 
		limite_superior_y + margem_seguranca, 
		limite_inferior_y - margem_seguranca
	)
	
	# Movimento horizontal e vertical
	velocity = Vector2(
		-horizontal_speed,
		vertical_direction * random_y_speed
	)
	
	move_and_slide()
	
	# Lógica de disparo
	fire_timer -= delta
	if fire_timer <= 0:
		shoot()
		fire_timer = fire_rate
	
	# Verifica se saiu da tela
	if out_screen():
		queue_free()

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

func posicionar_no_lado_direito():
	var viewport = get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	
	# Posição Y aleatória dentro da área segura
	var spawn_y = randf_range(
		viewport_size.y * 0.1, 
		viewport_size.y * 0.9
	)
	
	position = Vector2(viewport_size.x + spawn_margin, spawn_y)

func mudar_direcao():
	# Inverte a direção vertical com 70% de chance
	if randf() > 0.3:
		vertical_direction *= -1
	
	# Aleatoriza a velocidade vertical novamente
	random_y_speed = randf_range(vertical_speed * 0.5, vertical_speed * 1.5)
	
	# Aleatoriza o tempo para próxima mudança (entre 1 e 3 segundos)
	direction_change_time = randf_range(1.0, 3.0)

func out_screen() -> bool:
	var viewport = get_viewport()
	var viewport_rect = viewport.get_visible_rect()
	var extents = $CollisionShape2D.shape.extents if has_node("CollisionShape2D") else Vector2.ZERO
	
	# Verifica se saiu completamente pela esquerda ou pelas bordas superior/inferior
	return (
		global_position.x + extents.x < -despawn_margin or
		global_position.y - extents.y > viewport_rect.size.y + despawn_margin or
		global_position.y + extents.y < -despawn_margin
	)

func shoot():
	if bullet_scene == null:
		push_warning("Nenhuma cena de projétil atribuída")
		return
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	# Posiciona o projétil com offset
	bullet.position = position + bullet_offset
	if bullet.has_method("set_direction"):  # Verifica se o método existe
		bullet.set_direction(Vector2.LEFT)
	elif bullet.has("direction"):  # Alternativa: verifica se a propriedade existe
		bullet.direction = Vector2.LEFT
	else:
		push_error("Projétil não tem propriedade/método 'direction'")
	
	if bullet.has_method("set_speed"):
		bullet.set_speed(bullet_speed)
	elif bullet.has("speed"):
		bullet.speed = bullet_speed
	
	# Efeito sonoro
	if has_node("ShootSound"):
		$ShootSound.play()
