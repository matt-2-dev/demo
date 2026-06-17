extends CharacterBody2D

var speed_player: float = 500.0
var jump_player: float = -450.0
var health: int = 5
var can_shoot = false

@export var bullet_scene: PackedScene
@export var player: Node
@export var bullet_spawn: Marker2D
@export var pivot: Node2D
@export var damage_cooldown: Timer

func _ready() -> void:
	add_to_group("player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction: Vector2 = Vector2(0.0,0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	if direction.x:
		velocity.x = direction.x * speed_player
	else:
		velocity.x = move_toward(velocity.x, 0, speed_player)
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_player
	if Input.is_action_pressed("ui_shoot"):
		if $ShootCooldown.is_stopped():
			$ShootCooldown.start($ShootCooldown.wait_time)
		else:
			$ShootCooldown.stop()
func spawn_bullet() -> void:
	var b = bullet_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - bullet_spawn.global_position).normalized()
	b.rotation = dir.angle()
	b.global_position = bullet_spawn.global_position
	add_sibling(b)


func _player_damage(area: Area2D) -> void:
	if area.name == "RobotAreaHitbox":
		print("Player touched by robot")
		damage_cooldown.start(damage_cooldown.wait_time)

func _damage_cooldown() -> void:
	health -= 1
	print("Player Damage: ", health)
	if health <= 0:
		damage_cooldown.stop()
		get_tree().reload_current_scene()


func _shoot_cooldown() -> void:
	spawn_bullet()
