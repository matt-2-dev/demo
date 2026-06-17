extends CharacterBody2D

@export var max_speed := 150.0
@export var acceleration := 800.0
@export var gravity := 1200.0
var health = 3
var player

func _ready():
	player = get_tree().get_first_node_in_group("player")
func _physics_process(delta):
	if player == null:
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = (player.global_position - global_position).normalized()
	velocity.x = move_toward(velocity.x, direction.x * max_speed, acceleration * delta)
	move_and_slide()
func _bullet_hit(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		if health == 0:
			queue_free()
		health -=1
