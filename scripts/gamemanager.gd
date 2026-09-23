extends Node2D
# Export Variables for UI
# GAME UI
@export var health_bar: ProgressBar
@export var kill_label: Label
@export var points_label: Label
@export var mag_label: Label 
@export var reserve_ammo_label: Label
# DEBUG UI
@export var debug_shoot_label: Label
@export var debug_damage_label: Label
# UPGRADE
@export var upgrade_ui: CanvasLayer
@export var shoot_cooldown_button: Button
@export var shoot_cooldown_label: Label
# Export Variables for DEBUG
@export var damage: bool
@export var shoot: bool
# Export Variables for CharacterBody2D
var player
var player_scene = load("res://scenes/player.tscn")
@export var player_spawn: Marker2D
# Functions
func _ready():
	player = get_tree().get_root().get_node("CharacterBody2D")
	get_tree().current_scene.get_node("GameTimer").start()
	#export variables
	GameManager.health_bar = $"GameUI/health-bar"
	GameManager.points_label = $"GameUI/points-label"
	GameManager.mag_label = $"GameUI/mag-label"
	GameManager.reserve_ammo_label = $"GameUI/reserve-ammo-label"
	GameManager.debug_damage_label = $"DebugUI/damage-label-holder/damage-label"
	GameManager.debug_shoot_label = $"DebugUI/shoot-label-holder/shoot-label"
	GameManager.upgrade_ui = $UpgradeUI
	GameManager.shoot_cooldown_button = $"UpgradeUI/upgrade-shoot-cooldown-button"
	GameManager.shoot_cooldown_label = $"UpgradeUI/shoot-cooldown-stat"
	GameManager.player = $CharacterBody2D
func _process(delta: float) -> void:
	get_tree().current_scene.get_node("GameUI").get_node("timer-label").text = str(ceil(get_tree().current_scene.get_node("GameTimer").time_left))
	pass

# // Player Respawn
func respawn_player():
	var old_player = get_node_or_null("CharacterBody2D")
	if old_player:
		old_player.queue_free()
	var new_player = player_scene.instantiate()
	var new_camera = Camera2D.new()
	new_camera.zoom = Vector2(1,1)
	new_camera.position = Vector2(4,0)
	new_camera.enabled = true
	new_player.add_child(new_camera)
	new_player.position = player_spawn.position
	new_player.name = "CharacterBody2D"
	GameManager.player = new_player
	add_child(new_player)
func give_point(amount) -> void:
	#normal
	player.points += amount
	points_label.text = str(player.points)
# // Damage
func enable_damage():
	damage = true
	debug_damage_label.text = "Damage: %s" % damage
func disable_damage():
	damage = false
	debug_damage_label.text = "Damage: %s" % damage
# // Ammo
func calc_fill(amount, mag, reserve, mag_limit := 10, reserve_limit := 20):
	var mag_space = mag_limit - mag
	var reserve_space = reserve_limit - reserve
	var give_mag = min(amount, mag_space)
	amount -= give_mag
	var give_reserve = min(amount, reserve_space)
	return {
		"mag": give_mag,
		"reserve": give_reserve
	}
func transfer(amount, current, limit):
	var space = limit - current
	return min(amount, space)

func give_ammo(amount):
	var mag_limit = 10
	var reserve_limit = 20
	var give_mag = transfer(amount, player.ammo, mag_limit)
	player.ammo += give_mag
	amount -= give_mag
	var give_reserve = transfer(amount, player.reserve_ammo, reserve_limit)
	player.reserve_ammo += give_reserve
	mag_label.text = str(player.ammo)
	reserve_ammo_label.text = str(player.reserve_ammo)
func calculate_ammo_to_give(amount, mag, reserve):
	var mag_space = 10 - mag
	var reserve_space = 20 - reserve
	var give_mag = min(amount, mag_space)
	amount -= give_mag
	var give_reserve = min(amount, reserve_space)
	amount -= give_reserve
	return {
		"give_mag": give_mag,
		"give_reserve": give_reserve
	}
func calculate_reload(mag, reserve):
	var mag_space = 10 - mag
	var give_mag = min(mag_space, reserve)
	return give_mag
# // Loot
func get_loot(label: Label):
	if label.text.contains("x"):
		var parts = label.text.split("x")
		var amount = int(parts[0].strip_edges())
		var item = parts[1].strip_edges()
		return {
			"item": item,
			"amount": amount
		}

func _game_time_over() -> void:
	GameManager.give_point(20)
	respawn_player()


func _bullet_floor_touch(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
