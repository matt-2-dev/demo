extends CanvasLayer

@export var shoot_cooldown_button: Button
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
	pass # upgrade logic here beta
