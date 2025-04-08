extends Control

@export var game_scene : PackedScene

func _on_play_btn_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_exit_btn_pressed():
	get_tree().quit()
