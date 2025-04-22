extends CharacterBody2D

# Configurações de movimento
@export var speed := 150.0
@export var vertical_movement_range := 460.0
@export var vida: float = 200.0

# Projéteis
@export var basic_projectile_scene: PackedScene
@export var explosive_scene: PackedScene
@export var power_beam_scene: PackedScene

# Tempos de ataque
@export var basic_attack_interval := 0.8
@export var explosive_attack_interval := 0.5
@export var power_beam_interval := 0.2
@export var power_beam_duration := 3.0
@export var power_beam_time := 0.0

# Variáveis internas
var moving_down := true
var starting_y := 0.0
var target_y := 0.0
var basic_attack_timer := 0.0
var explosive_attack_timer := 0.0
var power_beam_timer := 0.0
var power_beam_count := 0
var max_power_beams := 20
var state := "descending" # "descending", "ascending", "power_attack"

@onready var player := get_node("/root/Game/Player") # Ajuste o caminho para o seu jogador
@onready var screen_size := get_viewport_rect().size

func _ready():
	$HitboxArea.area_entered.connect(_on_hitbox_area_entered)
	starting_y = position.y
	target_y = starting_y + vertical_movement_range
	position.x = screen_size.x - 100 # Posiciona no lado direito da tela

func _process(delta):
	power_beam_time += delta
	match state:
		"descending":
			move_down(delta)
		"ascending":
			move_up(delta)
		"power_attack":
			power_attack(delta)

func move_down(delta):
	position.y += speed * delta
	
	# Atira projéteis básicos enquanto desce
	basic_attack_timer += delta
	if basic_attack_timer >= basic_attack_interval:
		basic_attack_timer = 0.0
		shoot_basic_projectile()
	
	# Verifica se chegou ao fundo
	if position.y >= target_y:
		state = "ascending"
		explosive_attack_timer = 0.0

func move_up(delta):
	position.y -= speed * delta
	
	# Atira esferas explosivas enquanto sobe
	explosive_attack_timer += delta
	if explosive_attack_timer >= explosive_attack_interval:
		explosive_attack_timer = 0.0
		shoot_explosive_sphere()
	
	if position.y <= 80.0:
		state = "descending"
		basic_attack_timer = 0.0

	# Verifica o momento do power_beam
	if position.y <= 320 and power_beam_time >= 8.0:
		state = "power_attack"
		power_beam_timer = 0.0
		power_beam_count = 0
		power_beam_time = 0

func power_attack(delta):
	power_beam_timer += delta
	
	# Dispara rajadas de poder
	if power_beam_timer >= power_beam_interval and power_beam_count < max_power_beams:
		power_beam_timer = 0.0
		power_beam_count += 1
		shoot_power_beam()
	
	# Termina o ataque de poder e volta a descer
	if power_beam_count >= max_power_beams and power_beam_timer >= power_beam_duration:
		state = "descending"
		basic_attack_timer = 0.0

func shoot_basic_projectile():
	if not player or not basic_projectile_scene:
		return
	
	var projectile = basic_projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.direction = (player.global_position - global_position).normalized()

func shoot_explosive_sphere():
	if not explosive_scene:
		return
	
	var explosive = explosive_scene.instantiate()
	get_parent().add_child(explosive)
	explosive.global_position = global_position
	# Explosivas caem em direção ao fundo da tela
	explosive.direction = Vector2(-1.0, randf_range(-0.5, 0.5))

func shoot_power_beam():
	if not power_beam_scene:
		return
	
	# Rajadas alternando direção
	var direction = Vector2.UP if power_beam_count % 2 == 0 else Vector2.DOWN
	
	var beam = power_beam_scene.instantiate()
	get_parent().add_child(beam)
	beam.global_position = global_position
	beam.direction = Vector2(-1.0, randf_range(-0.7, 0.7))

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
