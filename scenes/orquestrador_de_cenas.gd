extends Node

@onready var menu_principal = $MenuInicial

func _on_play_btn_pressed():
	menu_principal.visible = false
	
