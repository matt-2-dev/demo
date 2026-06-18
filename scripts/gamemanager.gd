extends Node2D
# Export Variables for UI
@export var health_label: Label
var points_label
var ammo_label
var shoot_label: Label
var damage_label: Label
var max_ammo_label
# Export Variables for Game
@export var damage: bool
@export var shoot: bool
# Export Variables for CharacterBody2D
@export var player: CharacterBody2D
# Functions
func _ready() -> void:
	points_label = $"DebugUI/points-text-holder/points-label"
	ammo_label = $"DebugUI/ammo-text-holder/ammo-label"
	max_ammo_label = $"DebugUI/max_ammo-text-holder/max_ammo-label"
# // Points
func give_point() -> void:
	player.points += 1
	points_label.text = "Points: %s" % player.points
# // Damage
func enable_damage():
	damage = true
	damage_label.text = "Damage: %s" % damage
func disable_damage():
	damage = false
	damage_label.text = "Damage: %s" % damage
# // Ammo
func give_ammo(amount):
	var mag_limit = 10
	var reserve_limit = 20
	var total_limit = mag_limit + reserve_limit

	var mag_space = mag_limit - player.ammo
	var reserve_space = reserve_limit - player.max_ammo
	var total_space = total_limit - (player.ammo + player.max_ammo)

	print("mag space:", mag_space, "reserve space:", reserve_space, "total space:", total_space)
	if total_space <= 0:
		print("No space left")
		return
	if reserve_space > 0 and amount > 0:
		var give_to_reserve = min(amount, reserve_space)
		player.max_ammo += give_to_reserve
		amount -= give_to_reserve
		print("gave reserve:", give_to_reserve)
	mag_space = mag_limit - player.ammo
	if mag_space > 0 and amount > 0:
		var give_to_mag = min(amount, mag_space)
		player.ammo += give_to_mag
		amount -= give_to_mag
		print("gave mag:", give_to_mag)
	ammo_label.text = "Ammo: %s" % player.ammo
	max_ammo_label.text = "Max Ammo: %s" % player.max_ammo
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
