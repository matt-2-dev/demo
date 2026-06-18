extends Node2D
# Export Variables for UI
@export var health_label: Label
@export var points_label: Label
@export var ammo_label: Label
@export var shoot_label: Label
@export var damage_label: Label
# Export Variables for Game
@export var damage: bool
@export var shoot: bool
@export var points: int
@export var ammo: int
# Export Variables for CharacterBody2D
@export var player: CharacterBody2D
# Functions
# // Points
func give_point() -> void:
	points += 1
	points_label.text = "Points: %s" % points
# // Damage
func enable_damage():
	damage = true
	damage_label.text = "Damage: %s" % damage
func disable_damage():
	damage = false
	damage_label.text = "Damage: %s" % damage
# // Ammo
func give_ammo(amount):
	ammo += amount
	ammo_label.text = "Ammo: %s" % ammo
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
