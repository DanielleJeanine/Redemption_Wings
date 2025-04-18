extends CharacterBody2D

@export var speed: float = 650
@export var vel_player: float = 400.0
@export var at_basic: PackedScene
@export var max_charge_time: float = 3.0
@export var max_attack_damage: float = 5.0  # << Novo export para controlar o dano máximo
@export var max_lives: int = 3
@export var invulnerability_time: float = 1.0
@export var knockback_force: float = 500.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var charge_light: PointLight2D = $ChargeLight

var direction_mov_player: Vector2 = Vector2.ZERO
var last_direction_x: int = 1
var attack_hold_time: float = 0.0
var is_charging: bool = false
var current_lives: int = max_lives
var is_invulnerable: bool = false

signal lives_changed(new_lives)  # Sinal para atualizar o HUD
signal damage_taken(amount)

func _ready():
	# Conecte o sinal de área entrou (se estiver usando Area2D)
	if has_node("HitboxArea"):
		$HitboxArea.area_entered.connect(_on_hitbox_area_entered)

func _on_hitbox_area_entered(area):
	# Se a área que entrou é de um inimigo
	if area.is_in_group("enemy_hitbox"):
		take_damage(1)

func _physics_process(delta):
	mov_player()
	handle_attack_charge(delta)
	
	global_position.x = clamp(global_position.x, 164, 1276)
	global_position.y = clamp(global_position.y, 119, 688)

func mov_player() -> void:
	direction_mov_player = Vector2.ZERO

	if Input.is_action_pressed("mv_right"):
		direction_mov_player.x = 1
	elif Input.is_action_pressed("mv_left"):
		direction_mov_player.x = -1

	if Input.is_action_pressed("mv_up"):
		direction_mov_player.y = -1
	elif Input.is_action_pressed("mv_down"):
		direction_mov_player.y = 1

	if direction_mov_player.x != 0:
		last_direction_x = int(direction_mov_player.x)

	velocity = direction_mov_player.normalized() * vel_player
	move_and_slide()

func handle_attack_charge(delta):
	if Input.is_action_pressed("at_basic"):
		attack_hold_time += delta
		update_charge_effect()

	if Input.is_action_just_released("at_basic"):
		print("...released: " + str(attack_hold_time))
		atirar(attack_hold_time)
		attack_hold_time = 0.0
		reset_charge_effect()

func update_charge_effect():
	var charge_ratio = min(attack_hold_time / max_charge_time, 1.0)
	charge_light.visible = true
	charge_light.energy = charge_ratio * 1.5
	charge_light.scale = Vector2.ONE * (1.0 + charge_ratio * 2.0)
	sprite_2d.modulate = Color(1.0, 1.0 - charge_ratio * 0.3, 1.0 - charge_ratio * 0.3)

func reset_charge_effect():
	charge_light.visible = false
	charge_light.energy = 0.0
	charge_light.scale = Vector2.ONE
	sprite_2d.modulate = Color.WHITE

func atirar(hold_time: float) -> void:
	if at_basic:
		var orb = at_basic.instantiate()
		orb.position = position + Vector2(last_direction_x * 30, 0)

		# Corrige o visual do orb: evita que ele nasça com cor preta
		if orb.has_node("Sprite2D"):
			orb.get_node("Sprite2D").modulate = Color(1, 1, 1, 1)  # cor branca, visível

		get_parent().add_child(orb)

		var damage = lerp(0.0, max_attack_damage, clamp(hold_time / max_charge_time, 0.0, 1.0))
		orb.powerShot(damage)
		print("Dano do tiro: ", damage)

func take_damage(amount: int):
	emit_signal("damage_taken", amount)
	if is_invulnerable:
		return
	
	current_lives -= amount
	# Garante que não vai para menos de 0
	current_lives = max(0, current_lives)
	lives_changed.emit(current_lives)  # Emite o sinal para o HUD
	
	# Efeitos de dano
	is_invulnerable = true
	apply_knockback()
	blink_effect()
	
	# Temporizador de invulnerabilidade
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false
	
	# Verifica se o jogador morreu
	if current_lives <= 0:
		player_die()

func apply_knockback():
	# Aplica um knockback para trás baseado na última direção
	var knockback_direction = Vector2(-last_direction_x, -0.5).normalized()
	velocity = knockback_direction * knockback_force
	move_and_slide()

func blink_effect():
	# Faz o sprite piscar durante a invulnerabilidade
	var blink_times = 6
	var blink_interval = invulnerability_time / (blink_times * 2)
	
	for i in blink_times:
		sprite_2d.modulate.a = 0.5
		await get_tree().create_timer(blink_interval).timeout
		sprite_2d.modulate.a = 1.0
		await get_tree().create_timer(blink_interval).timeout

func player_die():
	# Implemente o que acontece quando o jogador morre
	print("Player morreu!")
	# Exemplo: recarregar a cena
	get_tree().reload_current_scene()
