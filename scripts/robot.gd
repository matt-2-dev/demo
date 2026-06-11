extends CharacterBody2D


const SPEED = 280.0
var health = 2
@export var speed: float = 350.0
var player
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
func _physics_process(delta) -> void:
	if player == null:
		return
	# Calculate direction toward player
	var direction = (player.global_position - global_position).normalized()

	# Apply movement
	velocity = direction * speed
	move_and_slide()

func _robot_damage(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		if health > 0:
			health -= 1
		else:
			queue_free()
