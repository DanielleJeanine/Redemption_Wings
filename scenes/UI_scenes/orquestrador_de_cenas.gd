extends Node

@onready var menu_principal = $MenuInicial
@onready var Controles = $Controles
@onready var game = $Game
@onready var player= $Game/Player
@onready var parallax = $Game/ParallaxBackground
@onready var play_btn = $MenuInicial/VBoxContainer/Play_btn
@onready var controles_btn = $MenuInicial/VBoxContainer/Controles_btn

func _ready():
	play_btn.grab_focus()
	game.visible = false
	player.set_process(false)
	player.set_physics_process(false)
	player.set_process_input(false)
	parallax.set_process(false)

func _on_play_btn_pressed():
	menu_principal.visible = false
	game.visible = true
	
	player.set_process(true)
	player.set_physics_process(true)
	player.set_process_input(true)
	parallax.set_process(true)
	
func _on_controles_btn_pressed():
	menu_principal.visible = false
	Controles.visible = true
	
	
func _on_exit_btn_pressed():
	get_tree().quit()


func _on_voltar_menu_btn_pressed():
	Controles.visible = false
	menu_principal.visible = true
	
	player.set_process(false)
	player.set_physics_process(false)
	player.set_process_input(false)
	parallax.set_process(false)
	
