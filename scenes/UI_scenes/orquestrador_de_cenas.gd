extends Node

@onready var menu_principal = $MenuInicial
@onready var play_btn = $MenuInicial/VBoxContainer/Play_btn

func _ready():
	play_btn.grab_focus()

func _on_play_btn_pressed():
	menu_principal.visible = false
	
func _on_exit_btn_pressed():
	get_tree().quit()
