extends Node2D
var speed: float = 350.0
@export var spawn_point: Marker2D
@export var spawn_timer: Timer
@export var robot: PackedScene
@onready var player = get_tree().get_first_node_in_group("player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _cooldown() -> void:
	var r = robot.instantiate()
	r.rotation = spawn_point.rotation
	r.global_position = spawn_point.global_position
	add_sibling(r)
