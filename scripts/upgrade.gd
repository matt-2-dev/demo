extends CanvasLayer

@export var shoot_cooldown_upgrade: Button
@export var point_per_kill_upgrade: Button
@export var point_per_kill_stat: Label
@export var shoot_cooldown_stat: Label
var player 
# player stats
var ammo
var reserve_ammo
var points
var health

func _ready():
	player = get_node("../CharacterBody2D")
	ammo = player.ammo
	reserve_ammo = player.reserve_ammo
	points = player.points
	health = player.health
# upgrade shoot cooldown button
func _upgrade_shoot_cooldown() -> void:
	print("button for upgrade shoot cooldown is pressed :0")
func _upgrade_point_per_kill() -> void:
	print("you press")
func _exit() -> void:
	visible = false
