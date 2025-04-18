extends Control

@onready var hearts: Array = [
	$HBoxContainer/Life1,
	$HBoxContainer/Life2,
	$HBoxContainer/Life3
]

# Atualiza a exibição dos corações baseado nas vidas atuais
func update_hearts(current_lives: int):
	for i in range(hearts.size()):
		if i < current_lives:
			hearts[i].visible = true 
		else:
			hearts[i].visible = false 
			
