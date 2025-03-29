extends CharacterBody2D

@export var speed: float = 650
@export var at_basic: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var vel_player: float = 400.0

var direction_mov_player: Vector2 = Vector2.ZERO
var last_direction_x: int = 1
var attack_hold_time: float = 0.0

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
		print('holding attack...')
		attack_hold_time += delta

	if Input.is_action_just_released("at_basic"):
		print('...released: ' + str(attack_hold_time))
		atirar(attack_hold_time)
		attack_hold_time = 0.0

func atirar(hold_time: float) -> void:
	if at_basic:
		var orb = at_basic.instantiate()
		orb.position = position + Vector2(last_direction_x * 30, 0)
		
		print('attacking at: ' + str(last_direction_x))
		
		if (hold_time >= 1.0):
			print('power shot!')
			orb.powerShot(hold_time)

		get_parent().add_child(orb)
