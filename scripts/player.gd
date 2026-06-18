extends CharacterBody2D

var gm
var speed_player: float = 500.0
var jump_player: float = -450.0
var health: int = 5
var can_shoot = true
var can_damage = false
var ammo = 10
var points = 0

@export var bullet_scene: PackedScene
@export var player: Node
@export var bullet_spawn: Marker2D
@export var pivot: Node2D

@export var health_label: Label
@export var points_label: Label
@export var damage_label: Label
@export var shoot_label: Label
@export var ammo_label: Label


func _ready():
	gm = get_tree().get_root().get_node("Node2D")
	add_to_group("player")

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
		if ammo > 0 and can_shoot: 
			print("shooting bullets")
			spawn_bullet()
			can_shoot = false
			shoot_label.text = "Shoot: %s" % can_shoot
			$ShootCooldown.start($ShootCooldown.wait_time)

func spawn_bullet() -> void:
	var b = bullet_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - bullet_spawn.global_position).normalized()
	b.rotation = dir.angle()
	b.global_position = bullet_spawn.global_position
	add_sibling(b)
	ammo -= 1
	ammo_label.text = "Ammo: %s" % ammo

func _player_damage_enter(area: Area2D) -> void:
	if area.name == "RobotAreaHitbox":
		print("Player touched by robot")
		can_damage = true
		damage_label.text = "Damage: %s" % can_damage
		_damage_cooldown()
		$DamageCooldown.start($DamageCooldown.wait_time)

func _player_damage_exit(area: Area2D) -> void:
	can_damage = false
	damage_label.text = "Damage: %s" % can_damage

func _damage_cooldown() -> void:
	if can_damage:
		damage_label.text = "Damage: %s" % can_damage
		health -= 1
		health_label.text = "Health: %s" % health
		if health <= 0:
			get_tree().reload_current_scene()

func _shoot_cooldown() -> void:
	can_shoot = true
	shoot_label.text = "Shoot: %s" % can_shoot
	$ShootCooldown.stop()
