extends Node2D
# Export Variables for UI
# GAME UI
@export var health_bar: ProgressBar
@export var points_label: Label
@export var mag_label: Label
@export var reserve_ammo_label: Label
# DEBUG UI
@export var debug_shoot_label: Label
@export var debug_damage_label: Label
# Export Variables for DEBUG
@export var damage: bool
@export var shoot: bool
# Export Variables for CharacterBody2D
@export var player: CharacterBody2D
# Functions
# // Points
func give_point(amount) -> void:
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
