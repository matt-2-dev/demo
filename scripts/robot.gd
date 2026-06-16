extends CharacterBody2D

var health = 2
var player_inside := false
@export var damage_cooldown := 0.5

@export var speed: float = 350.0
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta) -> void:
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.is_in_group("player"):
		player_inside = true
		_damage_loop(area)
		print("looping damage")

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_inside = false

func _damage_loop(player):
	while player_inside:
		player._player_damage()
		await get_tree().create_timer(damage_cooldown).timeout
