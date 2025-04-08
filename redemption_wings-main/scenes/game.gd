extends Node2D

@export var inimigo_scene: PackedScene  # Atribua c_demon.tscn aqui no editor
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
	if inimigo_scene == null:
		print("⚠️ Cena c_demon.tscn não atribuída ao export!")
		return

	var inimigo = inimigo_scene.instantiate()
	add_child(inimigo)

	var viewport_size = get_viewport().get_visible_rect().size
	inimigo.position = Vector2(
		viewport_size.x + margem_lateral,
		randf_range(viewport_size.y * margem_base, viewport_size.y * margem_topo)
	)
