extends Node2D

@export var loot_scene: PackedScene
@export var spawn_points: Array[Node2D]
@export var loot_spawn_timer: Timer

var gm
var max_loot = 7
@export var current_loot = 0

func _ready():
	loot_spawn_timer.start()
	gm = get_tree().get_root().get_node("Node2D")

func get_free_spawn_point() -> Node2D:
	var free_points = []
	for sp in spawn_points:
		if not sp.get_meta("occupied"):
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
	loot.position = sp.position
	gm.add_child(loot)

	sp.set_meta("occupied", true)
	loot.connect("tree_exited", func():
		sp.set_meta("occupied", false)
	)
	current_loot += 1
func _loot_spawn_timer() -> void:
	spawn_random_loot()
