extends Node2D

@export var loot_scene: PackedScene
@export var spawn_points: Array[Node2D]

var loot_types = ["ammo", "health", "points"]

func spawn_random_loot():
	var loot = loot_scene.instantiate()

	loot.loot_type = loot_types.pick_random()
	loot.amount = randi_range(1, 10)

	var point = spawn_points.pick_random()
	loot.position = point.position

	add_child(loot)
