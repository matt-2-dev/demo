extends CharacterBody2D

var gm
var speed_player: float = 500.0
var jump_player: float = -450.0

var can_shoot = true
var can_damage = true
# Game UI
var health_bar: ProgressBar = GameManager.health_bar
var kill_label: Label = GameManager.kill_label
var points_label: Label = GameManager.points_label
#var mag_label: Label = GameManager.mag_label
var reserve_ammo_label: Label = GameManager.reserve_ammo_label
# Debug UI
var damage_debug_label: Label = GameManager.debug_damage_label
var shoot_debug_label: Label = GameManager.debug_shoot_label
# PLAYER STATS
@export var ammo = 10
@export var points = 0
@export var reserve_ammo = 10
@export var health = 5
# Upgrade UI
var upgrade_ui: CanvasLayer = GameManager.upgrade_ui
var shoot_cooldown_button: Button = GameManager.shoot_cooldown_button
var shoot_cooldown_label: Label = GameManager.shoot_cooldown_label
# other
@export var bullet_scene: PackedScene
@export var player: Node
@export var bullet_spawn: Marker2D
var pivot: Node2D

func _ready():
	bullet_scene = load("res://scenes/bullet.tscn")
	gm = GameManager
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
			spawn_bullet()
			can_shoot = false
			GameManager.debug_shoot_label.text = "Shoot: %s" % can_shoot
			$ShootCooldown.start($ShootCooldown.wait_time)
	if Input.is_action_just_pressed("ui_reload"):
		if player.reserve_ammo > 0 and player.ammo < 10:
			print("reloading")
			reload()
	# UPGRADE UI
	if Input.is_action_just_pressed("ui_upgrade"):
		GameManager.upgrade_ui.visible = true
func reload():
	var mag_limit = 10
	var needed = mag_limit - ammo
	var give = min(needed, reserve_ammo)
	ammo += give
	reserve_ammo -= give
	GameManager.mag_label.text = str(ammo)
	GameManager.reserve_ammo_label.text = str(reserve_ammo)
func spawn_bullet() -> void:
	var b = bullet_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - bullet_spawn.global_position).normalized()
	b.global_position = bullet_spawn.global_position
	b.rotation = dir.angle()
	get_tree().current_scene.add_child(b)
	ammo -= 1
	GameManager.mag_label.text = str(ammo)
func _player_damage_enter(area: Area2D) -> void:
	if area.name == "RobotAreaHitbox":
		can_damage = true
		GameManager.debug_damage_label.text = "Damage: %s" % can_damage
		_damage_cooldown()
		$DamageCooldown.start($DamageCooldown.wait_time)
func _player_damage_exit(area: Area2D) -> void:
	can_damage = false
	GameManager.debug_damage_label.text = "Damage: %s" % can_damage

func _damage_cooldown() -> void:
	if can_damage:
		GameManager.debug_damage_label.text = "Damage: %s" % can_damage
		health -= 1
		GameManager.health_bar.value = health
		if health <= 0:
			get_tree().reload_current_scene()
func _shoot_cooldown() -> void:
	can_shoot = true
	GameManager.debug_shoot_label.text = "Shoot: %s" % can_shoot
	$ShootCooldown.stop()
