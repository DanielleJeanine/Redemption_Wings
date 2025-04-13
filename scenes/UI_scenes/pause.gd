extends CanvasLayer


@onready var resume_btn = $menu_pause/continuar_btn

func _ready():
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("pause_btn"):
		visible = true
		get_tree().paused = true
		resume_btn.grab_focus()

func _on_continuar_btn_pressed():
	get_tree().paused = false
	visible = false

func _on_sair_btn_2_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI_scenes/orquestradorDeCenas.tscn")
