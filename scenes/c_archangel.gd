extends CharacterBody2D

@export var speed: float = 650
@export var at_basic: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var vel_player : float = 400.0

var direction_mov_player : Vector2 = Vector2(0, 0) 
var last_direction_x : int = 1 

func _ready():
	pass 

func _process(delta):
	mov_player()

func mov_player() -> void:
	#Movimento Horizontal
	if Input.is_action_pressed("mv_right"):
		direction_mov_player.x = 1
	elif  Input.is_action_pressed("mv_left"):
		direction_mov_player.x = -1
	else:
		direction_mov_player.x = 0

	#Movimento Vertical
	if  Input.is_action_pressed("mv_up"):
		direction_mov_player.y = -1
	elif Input.is_action_pressed("mv_down"):
		direction_mov_player.y = 1
	else:
		direction_mov_player.y = 0
		
	if Input.is_action_just_pressed("at_basic"):
		atirar()

#Aplica as mudanças na direção do player
	velocity = direction_mov_player.normalized() * vel_player
	move_and_slide()

func atirar() -> void:
	var orb = at_basic.instantiate()
	orb.position = position + Vector2 (0, 0)
	get_parent().add_child(orb)
	
