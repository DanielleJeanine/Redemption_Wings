extends CharacterBody2D

@export var speed: float = 650
@export var vel_player: float = 400.0
@export var at_basic: PackedScene
@export var max_charge_time: float = 3.0
@export var max_attack_damage: float = 5.0  # << Novo export para controlar o dano máximo

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var charge_light: PointLight2D = $ChargeLight

var direction_mov_player: Vector2 = Vector2.ZERO
var last_direction_x: int = 1
var attack_hold_time: float = 0.0
var is_charging: bool = false

func _physics_process(delta):
	mov_player()
	handle_attack_charge(delta)

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
	charge_light.scale = Vector2.ONE * (1.0 + charge_ratio)
	sprite_2d.modulate = Color(1.0, 1.0 - charge_ratio * 0.5, 1.0 - charge_ratio * 0.5)

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
