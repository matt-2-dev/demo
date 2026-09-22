extends Node2D

@export var loot_scene: PackedScene
@onready var loot_spawn_timer: Timer = $LootTimer
@export var spawn_points: Array[Node2D]

var main_scene
var gm
var max_loot = 7
@export var current_loot = 0

func _ready():
	main_scene = get_tree().current_scene
	spawn_points = [
		main_scene.get_node("LootPoints").get_node("Point1"),
		main_scene.get_node("LootPoints").get_node("Point2"),
		main_scene.get_node("LootPoints").get_node("Point3"),
		main_scene.get_node("LootPoints").get_node("Point4")
	]
	loot_spawn_timer.start()
	gm = GameManager

func get_free_spawn_point() -> Node2D:
	var free_points = []
	for sp in spawn_points:
		if not is_instance_valid(sp):
			continue
		if not sp.get_meta("occupied", false):
			free_points.append(sp)
	if free_points.is_empty():
		return null
	return free_points.pick_random()
func spawn_random_loot():
	if current_loot >= max_loot:
		return
	var sp = get_free_spawn_point()
	if sp == null:
		return
	var loot = loot_scene.instantiate()
	loot.loot_type = "Health"
	loot.amount = randi_range(5, 20)
	var label = loot.get_node("loot-label-holder/loot-text")
	label.text = "5x %s" % loot.loot_type
	loot.global_position = sp.global_position
	get_tree().current_scene.add_child(loot)
	sp.set_meta("occupied", true)
	loot.tree_exited.connect(func():
		if is_instance_valid(sp):
			sp.set_meta("occupied", false)
			current_loot -= 1
		current_loot += 1
	)
func _loot_spawn_timer() -> void:
	spawn_random_loot()
