extends CharacterBody2D

@export var max_speed := 250.0
@export var acceleration := 800.0
@export var gravity := 1200.0
@export var health_bar: ProgressBar
@export var loot_scene: PackedScene
var health = 3
var player
var gm
var gameUI

func _ready():
	player = get_tree().get_first_node_in_group("player")
	gm = get_tree().get_root().get_node("Node2D")
	gameUI = get_tree().get_root().get_node("Node2D/GameUI")
	add_to_group("enemy")
	health_bar.value = 3
func drop_ammo():
	gm.give_ammo(floor(randi_range(3, 4)))
func drop_points():
	gm.give_point(floor(randi_range(5,10)))
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
		area.queue_free()
		health -= 1
		health_bar.value = health
		if health <= 0:
			drop_ammo()
			queue_free()
		if randf() < 0.12:
			drop_points()
			gm.give_point(floor(randi_range(5,10)))
			gameUI.get_node("kills-label").text = str(
				int(gameUI.get_node("kills-label").text) + 1
			)
