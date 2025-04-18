extends Node2D

@export var bat_scene: PackedScene  # Atribua c_demon.tscn aqui no editor
@export var demon_scene: PackedScene
@export var intervalo: float = 4.0
@export var margem_topo := 0.9
@export var margem_base := 0.1
@export var margem_lateral := 50.0

var tempo := 0.0

func _ready():
	tempo = intervalo

func _process(delta):
	tempo -= delta
	if tempo <= 0:
		spawn_inimigo()
		tempo = intervalo

func spawn_inimigo():
	if bat_scene == null:
		print("⚠️ Cena demon.tscn não atribuída ao export!")
		return
	if demon_scene == null:
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
