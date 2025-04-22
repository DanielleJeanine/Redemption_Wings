extends Node2D

@export var bat_scene: PackedScene  # Atribua c_demon.tscn aqui no editor
@export var demon_scene: PackedScene
@export var boss_scene: PackedScene
@export var intervalo: float = 4.0
@export var margem_topo := 0.9
@export var margem_base := 0.1
@export var margem_lateral := 50.0

var tempo := 0.0
var monstros_spawnados := 0
var boss_spawnado := false
var total_monstros_para_boss := 10 

@onready var label_contagem: Label  # Adicione um nó Label na sua cena e conecte aqui

func _ready():
	label_contagem = get_node("Label")
	tempo = intervalo
	atualizar_ui_contagem()

func _process(delta):
	if boss_spawnado:
		return
	
	tempo -= delta
	if tempo <= 0:
		spawn_inimigo()
		tempo = intervalo

func spawn_inimigo():
	if bat_scene == null or demon_scene == null:
		print("⚠️ Cena demon.tscn não atribuída ao export!")
		return
	
	var enemy1 = bat_scene.instantiate()
	var enemy2 = demon_scene.instantiate()
	add_child(enemy1)
	add_child(enemy2)
	
	var viewport_size = get_viewport().get_visible_rect().size
	enemy1.position = Vector2(
		viewport_size.x + margem_lateral,
		randf_range(viewport_size.y * margem_base, viewport_size.y * margem_topo)
	)
	enemy2.position = Vector2(
		viewport_size.x + margem_lateral,
		randf_range(viewport_size.y * margem_base, viewport_size.y * margem_topo)
	)
	
	 # Atualiza contagem
	monstros_spawnados += 2  # Conta dois monstros por spawn
	atualizar_ui_contagem()
	
	# Verifica se é hora de spawnar o boss
	if monstros_spawnados >= total_monstros_para_boss and not boss_spawnado:
		spawn_boss()

func spawn_boss():
	if boss_scene == null:
		print("⚠️ Cena do boss não atribuída!")
		return
		
	var boss = boss_scene.instantiate()
	add_child(boss)
	   
	var viewport_size = get_viewport().get_visible_rect().size
	boss.position = Vector2(
		viewport_size.x - 150,  # Posição no lado direito
		viewport_size.y / 2  # Meio da tela verticalmente
	)
	
	boss_spawnado = true
	# Atualiza a UI para mostrar que o boss chegou
	label_contagem.text = "BOSS CHEGOU!"

func atualizar_ui_contagem():
	if label_contagem:
		var faltam = max(0, total_monstros_para_boss - monstros_spawnados)
		label_contagem.text = "Monstros até o boss: %d" % faltam
