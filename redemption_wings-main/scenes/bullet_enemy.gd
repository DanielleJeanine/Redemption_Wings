extends Area2D

@export var speed := 600.0
@export var damage : float = 1.0
@export var lifetime := 3.0  # Tempo de vida em segundos

@onready var hitbox_area := $HitboxArea as Area2D
@onready var life_timer := $LifeTimer as Timer

var direction := Vector2.LEFT  # Variável privada

func _ready():
	# Conexão segura dos sinais
	if hitbox_area:
		hitbox_area.body_entered.connect(_on_hitbox_body_entered)
	else:
		push_error("HitboxArea não encontrado na cena do projétil!")
	
	if life_timer:
		life_timer.wait_time = lifetime
		life_timer.start()
	else:
		push_warning("LifeTimer não encontrado, usando fallback")
		await get_tree().create_timer(lifetime).timeout
		queue_free()

func _physics_process(delta):
	position += direction * speed * delta
	
	# Destruir quando sair da tela pela esquerda (com margem de segurança)
	if position.x < -100:
		queue_free()

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func set_speed(new_speed: float):
	speed = new_speed

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		var player = body if body.has_method("take_damage") else body.get_parent()
		if player and player.has_method("take_damage"):
			player.take_damage(damage)
	queue_free()

func _on_life_timer_timeout():
	queue_free()
