extends CharacterBody2D

@export var max_speed := 105.0
@export var acceleration := 800.0
@export var gravity := 1200.0
@export var health_bar: ProgressBar
var health = 3
var gm 
var gameUI

func _ready():
	gameUI = get_tree().get_root().get_node("Node2D/GameUI")
	add_to_group("enemy")
	health_bar.value = 3
func drop_ammo():
	GameManager.give_ammo(5)
func drop_points():
	GameManager.give_point(1)
func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(player):
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = (player.global_position - global_position).normalized()
	velocity.x = move_toward(
		velocity.x,
		direction.x * max_speed,
		acceleration * delta
	)
	move_and_slide()
func _bullet_hit(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
		health -= 1
		health_bar.value = health
		if health <= 0:
			drop_ammo()
			queue_free()
			drop_points()
			gameUI.get_node("kills-label").text = str(
				int(gameUI.get_node("kills-label").text) + 1
			)
