extends CharacterBody2D

@export var speed: float = 650
@export var at_basic: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var vel_player: float = 400.0
@onready var charge_light: PointLight2D = $ChargeLight

var direction_mov_player: Vector2 = Vector2.ZERO
var last_direction_x: int = 1
var attack_hold_time: float = 0.0
var max_charge_time: float = 3.0
var is_charging: bool = false

func _physics_process(delta):
	mov_player()
	handle_attack_charge(delta)

func mov_player() -> void:
	direction_mov_player = Vector2.ZERO

	#Movimento Horizontal
	if Input.is_action_pressed("mv_right"):
		direction_mov_player.x = 1
	elif Input.is_action_pressed("mv_left"):
		direction_mov_player.x = -1
	else:
		direction_mov_player.x = 0

	#Movimento Vertical
	if Input.is_action_pressed("mv_up"):
		direction_mov_player.y = -1
	elif Input.is_action_pressed("mv_down"):
		direction_mov_player.y = 1
	else:
		direction_mov_player.y = 0

	if direction_mov_player.x != 0:
		last_direction_x = int(direction_mov_player.x)
		#flip character
		#sprite_2d.flip_h = (last_direction_x == -1)

	#Aplica as mudanças na direção do player
	velocity = direction_mov_player.normalized() * vel_player
	move_and_slide()

func handle_attack_charge(delta):
	if Input.is_action_pressed("at_basic"):
		attack_hold_time += delta
		update_charge_effect()
		print('holding attack...')


	if Input.is_action_just_released("at_basic"):
		print('...released: ' + str(attack_hold_time))
		atirar(attack_hold_time)
		attack_hold_time = 0.0
		reset_charge_effect()

func update_charge_effect():
	# Calcula a intensidade do brilho
	var charge_ratio = min(attack_hold_time / max_charge_time, 1.0)

	charge_light.visible = true
	# Ajusta a energia (brilho) e o tamanho da luz
	charge_light.energy = charge_ratio * 1.5
	charge_light.scale = Vector2.ONE * (1.0 + charge_ratio * 1.0)
	sprite_2d.modulate = Color(1.0, 1.0 - charge_ratio * 0.5, 1.0 - charge_ratio * 0.5)

func reset_charge_effect():
	charge_light.visible = false
	charge_light.energy = 0.0
	sprite_2d.modulate = Color.WHITE  # Volta à cor normal
	charge_light.scale = Vector2.ONE

func atirar(hold_time: float) -> void:
	if at_basic:
		var orb = at_basic.instantiate()
		orb.position = position + Vector2(last_direction_x * 30, 0)
		
		print('attacking at: ' + str(last_direction_x))
		
		if (hold_time >= 1.0):
			print('power shot!')
			orb.powerShot(hold_time)

		get_parent().add_child(orb)
